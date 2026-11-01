# NutriScan

Aplicación Flutter de **cribado del estado nutricional** para adultos (≥18), con
estimación de banda de IMC a partir de captura guiada. No es una herramienta de
diagnóstico médico; las pantallas de resultado incluyen una advertencia y una
recomendación de evaluación profesional.

## Estado del proyecto

La app ofrece consentimiento, navegación, perfil, historial local, configuración
de idioma/tema y pantallas de captura y resultados. La captura, los modelos de
visión y la medición automática todavía no están integrados: el obturador está
deshabilitado y no se generan mediciones reales desde una foto.

La versión web permite explorar las pantallas compatibles, pero no captura
imágenes ni ejecuta los modelos de visión. Su historial vive solo en memoria y
se pierde al recargar la página. La app móvil usa almacenamiento local.

## Tecnologías

- Flutter y Dart; Riverpod para estado y `go_router` para navegación.
- `camera`, ML Kit y TFLite están previstos para la captura y el procesamiento
  móvil; la integración de visión aún está pendiente.
- Slang para traducciones en español e inglés.
- Vercel para compilar y publicar la versión web estática.

## Requisitos

- Flutter SDK **3.44.8** (la versión usada para despliegue web).
- Dart incluido con Flutter.
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

La app es una herramienta de **cribado**, no de diagnóstico. La versión web no
sube fotos ni ejecuta análisis de imágenes; la captura y los modelos de visión
están pendientes y no se debe interpretar el sitio como una medición clínica.
En web, el consentimiento se guarda localmente y las mediciones de demostración
no persisten al recargar. El perfil permite borrar los datos disponibles.

El alcance actual excluye a menores de 18 años. Consulta
[docs/planning.md](./docs/planning.md) para las decisiones de producto y el
roadmap.
