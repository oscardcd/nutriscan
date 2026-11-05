# Tareas: captura y modelo de visión

## Objetivo y límites

Implementar el flujo móvil de captura como prototipo educativo y explorar si
las imágenes permiten estimar una **banda probable de IMC**. Cualquier resultado
experimental debe identificarse como tal; la app no se presenta para uso
médico. La pantalla de resultado debe priorizar una descripción breve y no
necesita exponer índices antropométricos ni detalles del modelo.

La app no debe presentar el resultado como diagnóstico ni afirmar que mide el
peso desde una fotografía. La estimación visual es experimental e incierta; si
la calidad de captura o la confianza son insuficientes, se debe pedir repetir o
no mostrar una banda. El proyecto no afirma validez clínica ni autoriza el uso
de resultados para decisiones de salud.

## Estado actual

- [x] Hay una pantalla de captura guiada con marco, instrucciones y controles
  visuales.
- [x] Están declarados `camera`, `flutter_pose_detection` e `image` en
  `pubspec.yaml`.
- [x] Android e iOS declaran permiso/motivo de uso de cámara.
- [x] La pantalla inicia la cámara tras una acción explícita y permite tomar
  una foto local y repetirla.
- [x] Existe un servicio técnico local de detección de pose, aún no conectado a
  la pantalla de captura.
- [ ] No hay segmentación, extracción de medidas físicas ni modelo de IMC.
- [ ] La galería todavía está deshabilitada.
- [ ] La ruta de resultado requiere un `ScreeningResult`, pero la captura no lo
  produce.

## F0 — Definir y validar la viabilidad

- [ ] **Definir el contrato de predicción.** Entrada: estatura confirmada por la
  persona, foto(s) y, si el método lo requiere, edad y sexo. Salida: banda
  probable, confianza/estado de calidad y motivo de rechazo. No devolver peso
  absoluto inferido de la foto.
- [ ] **Fijar criterios de aceptación antes de entrenar.** Acordar criterios
  técnicos y de producto para un experimento educativo: métricas, incertidumbre,
  límites por subgrupo y cuándo abstenerse. No usar exactitud global como único
  criterio ni presentar la evaluación como validación médica.
- [ ] **Diseñar un protocolo de captura reproducible.** Definir vista frontal y
  si la lateral será requisito o mejora; distancia/encuadre, iluminación,
  postura, ropa, fondo, resolución y dispositivos compatibles.
- [ ] **Definir el conjunto de datos y su gobernanza.** Obtener consentimiento
  explícito, procedencia legítima, etiquetas antropométricas de referencia
  medidas de forma independiente, retención y borrado. No usar fotos personales
  o sensibles sin autorización adecuada.
- [ ] **Preparar una evaluación exploratoria sin fuga de datos.** Separar
  participantes —no solo imágenes— entre entrenamiento, validación y prueba;
  documentar el tamaño y las limitaciones. Una muestra pequeña sirve para
  detectar problemas y estimar viabilidad, no para afirmar validez médica.
- [ ] **Comparar una línea base simple** de proporciones/landmarks contra una
  alternativa de modelo. Registrar MAE de IMC si aplica, matriz de confusión,
  sensibilidad por banda, calibración e intervalos de incertidumbre.
- [ ] **Tomar una decisión documentada GO/NO-GO.** Continuar solo si se cumplen
  los criterios predefinidos y no hay fallos inaceptables en subgrupos. Si no,
  mantener captura como guía sin predicción.

**Salida de F0:** protocolo, datos autorizados, informe de evaluación y decisión
de viabilidad. No publicar un modelo ni presentar predicciones a usuarios en
esta fase.

## F1 — Captura móvil confiable

- [x] **Implementar estado y ciclo de vida de cámara.** Solicitar permiso en
  contexto, manejar permiso denegado/permanentemente denegado, cámara ausente,
  errores de inicialización, pausa/reanudación y liberación al salir de la
  pantalla.
- [x] **Conectar la vista previa real** y mostrar estados de inicialización y
  errores de cámara.
- [ ] Adaptar y validar orientación, relación de aspecto, recorte, enfoque y
  exposición en dispositivos de distintas dimensiones.
- [x] **Implementar guía de encuadre y estados de captura.** Mostrar
  instrucciones breves y estados: preparando, vista previa activa, capturando,
  error y repetir. La cámara no se solicita hasta que la persona la activa. No
  mostrar lecturas de sensor que no estén realmente medidas.
- [x] **Capturar una imagen explícitamente** después del consentimiento de la app
  y la acción del usuario; permitir repetir la captura. La foto se conserva en
  memoria hasta repetir o salir y se elimina la copia temporal del plugin.
- [ ] Definir e implementar si se habilita la galería y cómo tratar imágenes
  importadas. En este incremento permanece deshabilitada.
- [ ] **Validar calidad antes de inferir:** persona visible de cuerpo completo,
  cantidad de personas esperada, pose/frontalidad, iluminación, desenfoque,
  oclusiones y encuadre. Cuando no pase los controles, explicar cómo corregirlo
  y no generar resultado.
- [x] **Mantener la captura local y minimizar persistencia.** La foto permanece
  en memoria hasta repetir o salir; se elimina la copia temporal del plugin y
  no se registran imágenes ni metadatos sensibles en logs.
- [x] **Cubrir comportamiento en web.** Mantener estado de captura no disponible
  si el pipeline/modelos no son compatibles; nunca simular una captura o una
  medición.
- [x] **Cubrir flujos con pruebas de widgets** para permisos denegados,
  pausa/reanudación, captura, repetición y disponibilidad web.
- [ ] **Validar permisos y ciclo de vida en dispositivos Android e iOS reales**,
  incluidos ausencia de cámara, interrupciones y recuperación tras salir de
  ajustes.

**Criterio de aceptación:** se puede abrir/cerrar y pausar/reanudar la captura
sin dejar la cámara activa; cada error tiene un estado recuperable; la imagen no
sale del dispositivo. El flujo de permisos/cámara está implementado y cubierto
con cámara falsa en pruebas; la validación final en dispositivos físicos Android
e iOS sigue pendiente.

## F2 — Pipeline de visión sin predicción clínica

- [x] **Definir interfaces de dominio** para calidad, landmarks y errores de
  pose; `PoseDetectionEngine` desacopla el servicio del plugin. La abstracción
  de captura sigue en `features/capture`.
- [x] **Implementar un servicio de pose** con `flutter_pose_detection`.
  Convierte JPEG/PNG a una imagen JPEG con orientación EXIF aplicada, mantiene
  dimensiones y coordenadas normalizadas, limita la entrada a 15 MiB/12 MP y
  devuelve estados para cero/múltiples personas, baja confianza e hitos de
  cuerpo incompletos (filtros técnicos: pose y visibilidad de landmarks ≥0.5).
  El plugin requiere Android API 31+.
- [ ] Validar frontalidad, rotación del dispositivo, encuadre real y salidas del
  plugin en dispositivos físicos. Los umbrales de pose actuales solo son
  filtros técnicos experimentales, no confianza nutricional.
- [ ] **Implementar segmentación de persona** y medir cobertura/contorno.
  Rechazar máscaras vacías, múltiples personas o recortes truncados.
- [ ] **Calcular características con unidades y validaciones explícitas.**
  Registrar el origen y error de cada medida; no convertir píxeles a
  centímetros sin una escala válida. Usar la estatura ingresada solo conforme
  al protocolo validado.
- [x] **Añadir ejecución fuera del hilo UI** para decodificar, orientar y
  normalizar imágenes mediante isolate, con límites de tamaño y timeout. La
  inferencia se delega al plugin nativo; no se mueve un canal de plataforma a
  un isolate Dart.
- [ ] **Verificar determinismo y casos límite** con imágenes sintéticas o
  autorizadas. Las pruebas actuales cubren normalización JPEG/PNG, entradas
  inválidas, límites de bytes, personas simuladas, landmarks incompletos o
  fuera de rango y timeout; quedan rotación EXIF, espejo, fixtures de personas,
  integración con el modelo nativo y segmentación.
- [ ] **Medir latencia y consumo** en dispositivos de referencia de gama baja y
  media; reducir resolución solo sin invalidar las mediciones.

**Estado F2:** parcial. El servicio devuelve pose y estado de calidad técnica o
un error tipado; no produce medidas físicas, IMC ni una predicción. Ningún
estado de pose debe presentarse como confianza nutricional. Segmentación,
características físicas, pruebas del modelo nativo y benchmarks en hardware
siguen pendientes.

**Criterio de aceptación:** cada paso implementado devuelve una pose con
calidad técnica explícita o un error tipado; una entrada inválida nunca se
transforma en valores por defecto que parezcan válidos. El pipeline completo
no se considera terminado hasta cubrir segmentación, medidas y validación en
dispositivos.

## F3 — Modelo, calibración e inferencia on-device

- [ ] **Elegir el objetivo del modelo a partir de F0.** Preferir la salida más
  explicable y evaluable: banda probable o estimación con incertidumbre. No
  entrenar una CNN únicamente porque esté disponible TFLite.
- [ ] **Entrenar y versionar el modelo** con datos consentidos, partición por
  persona y documentación de etiquetas, preprocesamiento, licencias y
  limitaciones.
- [ ] **Evaluar en un test independiente** y por subgrupos relevantes. Publicar
  MAE si se estima IMC, sensibilidad/especificidad por banda, matriz de
  confusión, calibración, intervalos y tasa de abstención.
- [ ] **Definir abstención conservadora.** Si la calidad, incertidumbre o
  calibración no cumple el umbral aprobado, no asignar una banda; pedir nueva
  captura o recomendar una medición convencional.
- [ ] **Convertir/optimizar a TFLite** y verificar que la conversión conserva las
  métricas acordadas. Empaquetar el modelo versionado como asset local.
- [ ] **Implementar el runner TFLite** con preprocesamiento idéntico al de
  entrenamiento, validación de entradas/salidas, liberación del intérprete y
  ejecución fuera del hilo UI.
- [ ] **Probar el modelo empaquetado** con casos de referencia y comparar
  resultados con la versión de evaluación; registrar versión/hash, no datos
  personales.
- [ ] **Establecer actualización y rollback del modelo.** Sin descargar modelos
  silenciosamente ni enviar fotografías; documentar cómo se sustituye la
  versión del asset y se verifica su integridad.

**Criterio de aceptación:** las métricas del modelo convertido cumplen los
umbrales aprobados; su inferencia es local, reproducible y tiene una salida
explícita de abstención.

## F4 — Integración con resultado simplificado

- [ ] **Crear el caso de uso de cribado** que conecte captura → controles de
  calidad → pipeline → predicción y propague errores/abstenciones sin
  inventar `ScreeningResult`.
- [ ] **Acordar el contenido mínimo del resultado:** banda probable destacada,
  una descripción breve y localizada, nota de cribado/no diagnóstico y acción
  para repetir. Mostrar confianza solo si está calibrada y es comprensible.
- [ ] **Evitar presentar IMC, índices, umbrales o falsa precisión** si no son
  necesarios para el usuario o no están validados. Las descripciones de cada
  banda deben revisarse para evitar lenguaje diagnóstico, alarmista o
  estigmatizante.
- [ ] **Conectar la navegación** solo cuando exista una predicción válida.
  Cubrir retorno a captura y estados de error/reintento.
- [ ] **Persistir solo lo aprobado** para el historial. No guardar fotos crudas;
  definir consentimiento, borrado y datos mínimos guardados. Mantener el
  fallback web sin persistencia como limitación visible.
- [ ] **Actualizar traducciones es/en** y las pruebas para cada banda, baja
  confianza, abstención, volver a medir y ausencia de valores ficticios.

**Criterio de aceptación:** el resultado visible contiene únicamente el
resultado probable y descripciones cortas acordadas; no se muestra si la
inferencia falla o se abstiene.

## F5 — Privacidad, seguridad y salida a usuarios

- [ ] Documentar finalidad, consentimiento, datos procesados, retención,
  proveedores/plugins y mecanismo de borrado.
- [ ] Verificar por inspección y pruebas que las imágenes no se suben, sincronizan
  ni aparecen en analytics, logs, crash reports o backups no aprobados.
- [ ] Realizar revisión de sesgos, accesibilidad y lenguaje con revisión
  profesional; atender falsos positivos y negativos de la banda de bajo peso.
- [ ] Definir límites de uso, dispositivos compatibles y texto de ayuda para
  imágenes no utilizables.
- [ ] Hacer piloto controlado antes de liberar y documentar incidentes, métricas,
  versiones del modelo y criterios para desactivar predicciones.

## Orden y dependencias

1. F0 debe aprobar el protocolo, las etiquetas y los criterios antes de entrenar
   o publicar predicciones.
2. F1 puede desarrollarse en paralelo con la evaluación de datos, pero debe
   permanecer sin resultado automático hasta que F0 dé GO.
3. F2 puede probarse con fixtures autorizados; no depende de mostrar resultados.
4. F3 depende de F0 y de un pipeline de entrada reproducible.
5. F4 depende de calidad, inferencia validada y contrato de salida.
6. F5 es requisito para piloto y lanzamiento, no una tarea posterior opcional.
