# Despliegue web en Vercel

NutriScan compila a Flutter web como sitio estático. Todo el procesado sigue siendo local en el navegador: sin backend, sin analytics, sin subida de fotos.

## Requisitos

- Flutter SDK 3.44.8 (`flutter --version`).
- Cuenta de Vercel.
- Opcional: Vercel CLI (`npm i -g vercel`).

## Build local

```bash
flutter pub get
flutter build web --release
```

La salida queda en `build/web`. No hace falta `--base-href`: el valor por defecto es `/` y en Vercel el sitio vive en la raíz del dominio. Solo cambia si lo sirves bajo un subpath (p. ej. `--base-href /nutriscan/`).

Para probarlo en local: `cd build/web && python3 -m http.server 8080` y abre <http://localhost:8080>. Usa `localhost` o HTTPS: el consentimiento se guarda con WebCrypto, que solo existe en contextos seguros.

## `vercel.json`

Está en la raíz del repo:

- `framework: null` → sitio estático, sin preset.
- `installCommand` → Vercel no trae Flutter: clona el SDK en `./flutter` (rama `FLUTTER_VERSION`, por defecto `3.44.8`) y corre `pub get`. La carpeta está en `.gitignore`.
- `buildCommand` → `flutter/bin/flutter build web --release` (es `flutter build web --release` con el SDK clonado).
- `outputDirectory` → `build/web`.
- Rewrite SPA `/(.*)` → `/index.html`, para que `go_router` resuelva deep links (`/result`, `/profile`…) sin 404. Los archivos que existen se sirven antes del rewrite.
- Cache: `assets/*` y `canvaskit/*` por 1 día con `stale-while-revalidate`; `main.dart.js`, `flutter_bootstrap.js`, `flutter_service_worker.js`, `index.html` y `version.json` siempre revalidan. Flutter no añade hash a estos nombres, así que no se marcan `immutable`.

## Deploy con CLI

```bash
vercel          # primera vez: vincula el proyecto (preview)
vercel --prod   # producción
```

El build corre en Vercel con lo definido en `vercel.json`.

## Deploy con Git

1. En Vercel: **Add New → Project** e importa el repo.
2. Framework Preset: **Other**. Deja Build/Output/Install vacíos: los toma de `vercel.json`.
3. Opcional: variable de entorno `FLUTTER_VERSION` para fijar otra versión del SDK.
4. Deploy. Cada push a `main` publica producción; cada PR, un preview.

## Verificación post-deploy

1. Abre la URL de producción: debe salir la pantalla de consentimiento.
2. Acepta y recarga: no debe volver a pedir consentimiento (queda persistido).
3. Navega por las tabs y abre Perfil; recarga estando en `/profile` (deep link) y no debe dar 404.
4. Entra a Captura: debe mostrar "Captura no disponible en este navegador", sin obturador.
5. DevTools → Console: sin errores rojos. DevTools → Network: `main.dart.js`, `canvaskit/*.wasm` y `assets/*` en 200/304, ninguno en 404.

## Limitaciones conocidas en web

- Cámara, detección de pose, segmentación y TFLite no existen en navegador: la captura muestra el estado "no disponible".
- Las mediciones usan un store en memoria: se pierden al recargar la pestaña.
- El consentimiento se guarda en `localStorage` cifrado con WebCrypto; borrar datos del sitio lo reinicia.
- NutriScan es un prototipo educativo, no una herramienta médica; sus resultados experimentales no deben usarse para decisiones de salud.

## Troubleshooting

- **404 en deep links**: falta el rewrite SPA en `vercel.json` o el proyecto no lo está leyendo (revisa que esté en la raíz).
- **Pantalla en blanco**: `--base-href` no coincide con la ruta donde se sirve, o `assets/`/`canvaskit/` dan 404 (revisa `outputDirectory: build/web`). Mira la consola.
- **Versión de Flutter en Vercel**: fija `FLUTTER_VERSION` en las env vars del proyecto; si el clon falla o tarda, usa una imagen de build con Flutter preinstalado y cambia `buildCommand` a `flutter build web --release`.
- **El consentimiento no persiste**: el sitio no está en HTTPS ni en `localhost` (WebCrypto no disponible).
