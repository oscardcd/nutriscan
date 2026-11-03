# Protocolo F0: viabilidad de estimación visual

## Estado

**Pendiente de revisión; no existe decisión GO/NO-GO.** Esta plantilla no
autoriza recolectar imágenes, entrenar un modelo ni mostrar predicciones. Se
deben acordar y registrar los campos pendientes con responsables técnicos,
clínicos y de privacidad antes de iniciar el estudio.

## Límites que no se deben cambiar sin revisión

- El uso propuesto es un cribado para personas adultas, no un diagnóstico.
- La salida a evaluar es una banda probable o una abstención; no se inferirá ni
  se mostrará el peso absoluto a partir de una foto.
- No se mostrarán predicciones a usuarios hasta completar la evaluación y
  aprobar formalmente un GO.
- Una captura de baja calidad, una predicción incierta o una entrada fuera del
  alcance deben producir abstención, no una banda por defecto.

## Decisiones previas a recolectar datos

Completar cada fila y guardar la evidencia o referencia de la decisión. Los
umbrales y tamaños de muestra deben acordarse antes de examinar los resultados
del conjunto de prueba; esta plantilla no fija valores clínicos.

| Tema | Decisión requerida | Responsable | Evidencia / estado |
|---|---|---|---|
| Uso previsto | Población, contexto y limitaciones del cribado | Clínico + producto | Pendiente |
| Salida objetivo | Banda probable, estados de abstención y significado para el usuario | Clínico + ML | Pendiente |
| Referencia | Método independiente para obtener las etiquetas de referencia | Clínico | Pendiente |
| Datos y consentimiento | Procedencia legítima, consentimiento explícito, acceso, retención y borrado | Privacidad + datos | Pendiente |
| Protocolo de captura | Vistas necesarias, pose, distancia, encuadre, iluminación y dispositivos | Captura + clínico | Pendiente |
| Particiones | Separación por participante entre entrenamiento, validación y prueba | ML | Pendiente |
| Subgrupos | Grupos relevantes para la población prevista y suficiencia de muestra por grupo | Clínico + ML | Pendiente |
| Métricas | Métricas por banda, calibración, incertidumbre, cobertura y tasa de abstención | Clínico + ML | Pendiente |
| Umbrales | Valores mínimos, incertidumbre aceptable y reglas explícitas de NO-GO | Clínico + ML | Pendiente |
| Revisión de privacidad | Tratamiento de fotos, identificadores, logs, backups y eliminación | Privacidad | Pendiente |

## Diseño mínimo de evaluación

1. Definir el protocolo, las etiquetas de referencia, las métricas y sus
   umbrales antes de recolectar datos o inspeccionar el conjunto de prueba.
2. Obtener consentimiento y registrar la procedencia y el uso autorizado de
   cada conjunto de datos. No reutilizar fotos personales sin autorización
   adecuada.
3. Separar los datos por participante, no por imagen, para evitar que imágenes
   de la misma persona aparezcan en particiones distintas.
4. Evaluar por banda y por los subgrupos previamente acordados. Reportar
   incertidumbre e intervalos, además de la matriz de confusión, calibración,
   cobertura y tasa de abstención. La exactitud global no basta para decidir.
5. Documentar fallos de captura y criterios de abstención. No reemplazar
   entradas inválidas o predicciones inciertas con valores plausibles.
6. Mantener el modelo fuera de producción hasta que las revisiones y los
   criterios predefinidos estén completos y la decisión sea GO.

## Registro de decisión

- Versión del protocolo:
- Fecha:
- Evidencia revisada:
- Limitaciones y riesgos pendientes:
- Decisión: **Pendiente / NO-GO / GO**
- Revisión clínica (responsable y fecha):
- Revisión técnica (responsable y fecha):
- Revisión de privacidad (responsable y fecha):

Una decisión GO solo aplica al protocolo, población, datos y versión evaluados.
Cambios materiales requieren revisión y una decisión documentada nueva.
