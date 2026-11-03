# NutriScan

Aplicación Flutter de **prototipo educativo y académico** para explorar captura
guiada y análisis de imágenes. No está validada para uso médico y sus resultados
experimentales no deben usarse para diagnóstico, tratamiento ni decisiones
clínicas.

## Estado del proyecto

La app ofrece consentimiento, navegación, perfil, historial local, configuración
de idioma/tema y pantallas de captura y resultados de demostración. En móvil se
puede activar la cámara y guardar una foto temporalmente en memoria, pero todavía
no se analiza ni se generan mediciones reales a partir de ella.

La versión web permite explorar las pantallas compatibles, pero no captura
imágenes ni ejecuta los modelos de visión. Su historial vive solo en memoria y
se pierde al recargar la página. La app móvil usa almacenamiento local.

## Tecnologías

- Flutter y Dart; Riverpod para estado y `go_router` para navegación.
- `camera` está integrado para capturar fotos en móvil. `flutter_pose_detection`
  está declarado, pero el pipeline de visión, TFLite y la segmentación todavía
  no están integrados.
- Slang para traducciones en español e inglés.
- Vercel para compilar y publicar la versión web estática.

## Requisitos

- Flutter SDK **3.44.8** (la versión usada para despliegue web).
- Dart incluido con Flutter.
- Android API 31+ para el plugin de pose; el deployment target del proyecto es
  iOS 15.5+.
- Para despliegue manual, una cuenta de Vercel y Vercel CLI son opcionales.

## Desarrollo local

```bash
flutter pub get
flutter run
```

Para comprobar los cambios:

```bash
flutter analyze
flutter test
```

## Web y despliegue

Compila una versión estática para navegador:

```bash
flutter build web --release
```

Los archivos se generan en `build/web`. Para probarlos localmente:

```bash
cd build/web
python3 -m http.server 8080
```

Abre <http://localhost:8080>. Usa `localhost` o HTTPS para que el consentimiento
pueda persistir con WebCrypto.

El repositorio incluye [vercel.json](./vercel.json), con los comandos de build y
la reescritura SPA para rutas de `go_router`. Para instrucciones de despliegue,
versionado de Flutter, verificación y solución de problemas, consulta la
[guía de Vercel](./docs/deploy-vercel.md).

## Privacidad y alcance

NutriScan es un prototipo **educativo**, no una herramienta médica. Los
resultados experimentales pueden ser inexactos y no deben usarse para decisiones
de salud. La versión web no sube fotos ni ejecuta análisis de imágenes; la
captura y los modelos de visión están pendientes. El consentimiento general de
uso no autoriza guardar ni reutilizar fotos para investigación o entrenamiento.
En web, el consentimiento se guarda localmente y las mediciones de demostración
no persisten al recargar. El perfil permite borrar los datos disponibles.

El alcance actual excluye a menores de 18 años. Consulta
[docs/planning.md](./docs/planning.md) para las decisiones de producto y el
roadmap.
