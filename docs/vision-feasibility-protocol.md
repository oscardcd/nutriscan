# Protocolo F0: viabilidad de estimación visual

## Estado

**Pendiente de evaluación; no existe decisión GO/NO-GO.** No se planifica una
revisión clínica. La pantalla de consentimiento actual permite usar la app,
pero no documenta por sí sola autorización para conservar fotos o usarlas como
datos de investigación o entrenamiento. Esta plantilla no autoriza recolectar
imágenes, entrenar un modelo ni mostrar predicciones.

## Límites que no se deben cambiar sin revisión

- El uso propuesto es un cribado para personas adultas, no un diagnóstico.
- La salida a evaluar es una banda probable o una abstención; no se inferirá ni
  se mostrará el peso absoluto a partir de una foto.
- No se mostrarán predicciones a usuarios hasta completar la evaluación y
  aprobar formalmente un GO.
- Una captura de baja calidad, una predicción incierta o una entrada fuera del
  alcance deben producir abstención, no una banda por defecto.

## Evidencia técnica inicial

- La [OMS define el IMC](https://www.who.int/news-room/fact-sheets/detail/obesity-and-overweight)
  usando peso medido en kilogramos y estatura medida en metros
  (`peso / estatura²`). Los umbrales de una banda clasifican ese IMC; no validan
  una estimación visual de peso, estatura o IMC.
- El paquete
  [`flutter_pose_detection`](https://pub.dev/packages/flutter_pose_detection)
  acepta imágenes JPEG/PNG y devuelve poses con 33 landmarks, coordenadas
  normalizadas, visibilidad y una puntuación de detección. Eso permite explorar
  detección de presencia y encuadre, pero no entrega segmentación de silueta,
  unidades físicas ni confianza calibrada de IMC.
- La puntuación de pose solo describe la detección de pose. No se debe mostrar
  como confianza de una banda de IMC. Los landmarks en píxeles tampoco son
  medidas en centímetros sin una escala validada.

**Conclusión preliminar:** es razonable probar localmente un control técnico de
pose/encuadre, sin generar resultado nutricional. Con lo revisado hasta ahora no
hay evidencia para calcular una banda de IMC desde la foto. Una predicción para
usuarios permanece bloqueada hasta contar con datos autorizados con referencias
medidas y una evaluación independiente; los umbrales publicados para clasificar
un IMC no sustituyen esa evaluación.

## Decisiones previas a recolectar datos

Completar cada fila y guardar la evidencia o referencia de la decisión. Los
umbrales y tamaños de muestra deben acordarse antes de examinar los resultados
del conjunto de prueba; esta plantilla no fija valores de aceptación.

| Tema | Decisión requerida | Responsable | Evidencia / estado |
|---|---|---|---|
| Uso previsto | Población, contexto y limitaciones informativas | Producto | Pendiente |
| Salida objetivo | Control técnico de pose, o banda probable y abstención | Producto + ML | Pendiente |
| Referencia | Método independiente para las etiquetas de referencia, si se estudia IMC visual | Datos | Pendiente |
| Datos y consentimiento | Procedencia, autorización específica para investigación, acceso, retención y borrado | Privacidad + datos | Pendiente |
| Protocolo de captura | Vistas, pose, distancia, encuadre, iluminación y dispositivos | Captura | Pendiente |
| Particiones | Separación por participante entre entrenamiento, validación y prueba | ML | Pendiente |
| Subgrupos | Grupos relevantes y suficiencia de muestra para evaluar el alcance | Datos + ML | Pendiente |
| Métricas | Para pose: detección/encuadre; para IMC: métricas por banda, calibración, incertidumbre y abstención | ML | Pendiente |
| Umbrales | Valores mínimos y reglas explícitas de NO-GO definidos antes de la prueba | Producto + ML | Pendiente |
| Revisión de privacidad | Tratamiento de fotos, identificadores, logs, backups y eliminación | Privacidad | Pendiente |

## Diseño mínimo de evaluación

1. Separar dos preguntas: si el plugin detecta pose/encuadre y si una imagen
   permite inferir una banda. Una respuesta positiva a la primera no demuestra
   la segunda.
2. Para una prueba de pose, documentar dispositivos, orientación, número de
   personas, visibilidad de landmarks, fallos y latencia; no llamar a esos
   resultados estimaciones nutricionales.
3. Antes de estudiar IMC visual, definir etiquetas de referencia, protocolo,
   métricas y umbrales antes de recolectar datos o inspeccionar la prueba.
4. Obtener y registrar autorización específica para cada conjunto de datos. No
   reutilizar fotos personales bajo el consentimiento general de uso de la app.
5. Separar los datos por participante y evaluar por banda y subgrupos acordados.
   Reportar incertidumbre, matriz de confusión, calibración, cobertura y tasa
   de abstención; la exactitud global no basta.
6. Mantener cualquier banda predicha fuera de la app hasta contar con datos
   autorizados, evaluación independiente y una decisión documentada.

## Registro de decisión

- Versión del protocolo:
- Fecha:
- Evidencia revisada:
- Limitaciones y riesgos pendientes:
- Decisión: **Pendiente / NO-GO / GO**
- Revisión de alcance (responsable y fecha):
- Revisión técnica (responsable y fecha):
- Revisión de privacidad (responsable y fecha):

Una decisión GO solo aplica al protocolo, población, datos y versión evaluados.
Cambios materiales requieren revisión y una decisión documentada nueva.
