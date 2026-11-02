N# Planning — App Flutter: estado nutricional (sobrepeso / desnutrición) por imágenes

## 1. Cambio de alcance — clave

"No medir peso de una foto". **No se puede** obtener el peso real de una persona desde
una imagen: falta la escala métrica y la densidad corporal. Lo que **sí** es viable es
**estimar el estado nutricional** (banda de IMC) y clasificar: bajo peso / normal /
sobrepeso / obesidad. Eso es lo que pediste (sobrepeso ↔ desnutrición) y es un problema
de **clasificación + regresión sobre antropometría**, no de volumen.

> Regla de oro: esto es una herramienta de **tamizaje (screening)**, NO diagnóstico
> médico. Toda salida lleva disclaimer y sugerencia de evaluación profesional.

## 2. La verdad incómoda (para calibrar expectativas)

Estimar IMC por foto tiene techo real:

- MAE típico en literatura: **~1.5–3 puntos de IMC**. En los bordes (24 vs 26) la
  confusión es alta.
- **Necesitas la estatura** (y sexo/edad). Sin escala métrica en la foto, el peso
  absoluto es imposible; la estatura ancla la escala y define el IMC.
- Ropa, pose, ángulo de cámara, distancia y distorsión de lente degradan mucho.
- El IMC mismo es crudo: un cuerpo musculoso cae en "sobrepeso". Hay que decirlo.

## 3. Cómo se estima (pipeline)

1. **Captura guiada:** cuerpo completo en el encuadre, distancia fija sugerida, ideal
   frontal **+ lateral**.
2. **Segmentación** de la silueta (ML Kit Subject Segmentation / U-Net ligero).
3. **Pose / keypoints** (MediaPipe Pose / MoveNet) → landmarks: hombro, pecho, cintura,
   cadera, muslo, altura total en píxeles.
4. **Normalización por estatura** (píxeles→cm con la altura ingresada).
5. **Índices antropométricos validados** (baratos y explicables, poca data necesaria):
   - Relación cintura–altura (WHtR).
   - Body Roundness Index (BRI).
   - Relative Fat Mass (RFM: usa altura + cintura).
   - Ratios de ancho (hombro/cintura/cadera) y área de silueta / altura².
6. **Modelo:** regresión/CLASIFICACIÓN sobre esos índices → IMC estimado ± IC → banda.
7. **Boost (F2):** CNN (MobileNetV3/EfficientNet-Lite) que regresa IMC desde
   imagen+estatura, combinada con los índices. Requiere dataset etiquetado.

## 4. Fase de salida (lo que ve el usuario)

- Banda: **bajo peso (desnutrición) / normal / sobrepeso / obesidad**.
- IMC estimado con intervalo de confianza.
- **Confianza de la medición** (baja si pose/ángulo/ropa son malos) → pide repetir.
- Disclaimer + recomendación de consultar profesional.
- Historial longitudinal (tracking) — aquí el producto aporta más que una foto suelta.

## 5. Alcance fijado: ADULTOS (≥18)

IMC = peso/altura², bandas OMS: **<18.5 bajo peso · 18.5–24.9 normal ·
25–29.9 sobrepeso · ≥30 obesidad**.

- "Desnutrición" en adulto = IMC <18.5 (bajo peso). La salida se alinea a estas 4 bandas.
- Pide **estatura, sexo y edad** (edad solo enmarca; las bandas OMS adulto no dependen de edad).
- Niños queda **fuera de alcance** (otro motor: z-scores OMS + MUAC).

## 6. Arquitectura Flutter

- **Patrón:** feature-first + MVVM (consistente con Paguí). Estado: Riverpod.
- **Todo on-device** (privacidad: foto corporal = dato biométrico/sensible). No subir
  imágenes crudas. TFLite y plugins de visión en isolates.
- **Backend (mínimo):** Firebase Auth + Firestore (solo métricas/historial, no fotos),
  o ni eso si es 100% local.
- **Capas:** presentation → domain (casos de uso: capturar, medir, clasificar) → data
  (visión, repos, almacenamiento cifrado local).

## 7. Stack / paquetes

- `camera` — captura guiada, overlay de encuadre.
- `flutter_pose_detection` — landmarks de pose con MediaPipe.
- Segmentación de silueta — tecnología por seleccionar e integrar.
- `tflite_flutter` — modelo de IMC/categoría.
- `image` — procesamiento.
- `flutter_riverpod`, `freezed`, `go_router`, `permission_handler`.
- `camera`/`galería` + `flutter_secure_storage` para datos sensibles.

## 8. Privacidad / ético / regulatorio

- Foto corporal = **dato sensible** (salud/biométrico): consentimiento explícito,
  cifrado, borrado fácil, on-device por defecto.
- **No** declarar diagnóstico médico → evita clasificación como dispositivo médico.
  Mantener lenguaje de bienestar/tamizaje.
- **Falso positivo de desnutrición es dañino** → umbrales conservadores + "baja
  confianza" explícita en vez de un resultado firme.
- Sesgos de dataset (etnia, género, contextura) → validar por subgrupos.

## 9. Roadmap

- **F0 — Spike (1–2 sem):** con ~30–50 fotos de IMC conocido, probar si los índices
  (WHtR/BRI/RFM) separan bandas con error útil. Criterio de salida: ¿MAE ≤ ~2–3 IMC?
- **F1 — MVP (3–4 sem):** foto frontal + estatura/sexo/edad → índices → banda + IC +
  confianza. 100% on-device. Disclaimer. Historial local.
- **F2 — v1 (4–6 sem):** frontal + lateral, CNN regresor, mejor calibración de captura,
  tracking longitudinal y gráfica.
- **F3 — v2:** modo clínico, sync opt-in, refuerzo de confianza y anti-sesgo.

## 10. Riesgos

- 2D → IMC inherentemente lossy; grasa vs músculo indistinguibles.
- Dependes de la estatura correcta: si falla, todo falla.
- Ropa/pose/ángulo/distorsión.
- Ético: alarma falsa de desnutrición. Regulatorio si se percibe diagnóstico.
- Dataset: escaso y sesgado; recolección propia es costosa.

## 11. Métricas de éxito

- MAE / MAPE del IMC vs medición real.
- Exactitud de banda; **foco en recall de desnutrición** (no perder casos).
- Calibración de confianza (que "baja confianza" correlacione con error real).
- Latencia on-device < 3–5 s.

## 12. Estructura del repo (feature-first)

```
lib/
  features/
    capture/        # cámara, overlay de encuadre
    measurement/    # silueta + pose + índices
    classify/       # IMC -> banda + confianza
    history/        # tracking longitudinal
  core/             # di, theme, errores, vision/
  data/             # vision/, ml/, local/ (cifrado)
```
