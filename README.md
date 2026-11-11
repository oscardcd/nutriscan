# NutriScan

Aplicación Flutter de **prototipo educativo y académico** para explorar captura
guiada y análisis de imágenes. No está validada para uso médico y sus resultados
experimentales no deben usarse para diagnóstico, tratamiento ni decisiones
clínicas.

## Estado del proyecto

La app ofrece consentimiento, navegación, perfil, historial local, configuración
de idioma/tema, captura guiada con detección de pose en vivo y cálculo de IMC a
partir del peso y la estatura que ingresa la persona. Todo se procesa en el
dispositivo y se guarda localmente; las fotos no salen del teléfono.

## Tecnologías

- Flutter y Dart; Riverpod para estado y `go_router` para navegación.
- `camera` para la captura y `flutter_pose_detection` para la pose en vivo y
  sobre la foto. Segmentación y medidas físicas desde la imagen no están
  integradas.
- `flutter_secure_storage` para guardar peso y estatura en el dispositivo.
- Slang para traducciones en español e inglés.

## Requisitos

| Herramienta | Versión |
|---|---|
| Flutter SDK (incluye Dart) | **3.44.8** stable (Dart ^3.12.2) |
| **iOS** · macOS + Xcode | Xcode reciente con iOS SDK; deployment target **iOS 15.5+** |
| **iOS** · CocoaPods | `brew install cocoapods` o `sudo gem install cocoapods` |
| **Android** · Android Studio + SDK | Android SDK, platform-tools y cmdline-tools; el NDK lo baja Gradle |
| **Android** · JDK | **17** (el que trae Android Studio sirve) |
| **Android** · dispositivo | Android 11+ (**minSdk 30**) |

Gradle 9.1, AGP 9.0.1 y Kotlin 2.3.20 vienen fijados en el proyecto; el wrapper
`gradlew` los descarga solo.

> La cámara y la detección de pose necesitan **dispositivo físico**: el simulador
> de iOS no tiene cámara y el emulador de Android da resultados poco fiables.

Comprueba el entorno con:

```bash
flutter doctor
```

## Primeros pasos (común)

```bash
flutter pub get
```

Las traducciones (`lib/i18n/strings.g.dart`) ya están generadas. Si editas los
`*.i18n.json`, regenéralas con:

```bash
dart run slang
```

## Correr en iOS

1. Instala los pods:

   ```bash
   cd ios && pod install && cd ..
   ```

2. Abre `ios/Runner.xcworkspace` en Xcode (el `.xcworkspace`, no el
   `.xcodeproj`) → target **Runner** → *Signing & Capabilities* → elige tu
   *Team* y, si hace falta, cambia el *Bundle Identifier* por uno único.
3. Conecta el iPhone, acepta "Confiar en este ordenador" y activa el
   **Modo desarrollador** (Ajustes → Privacidad y seguridad).
4. Ejecuta:

   ```bash
   flutter devices
   flutter run -d <id-del-iphone>
   ```

5. La primera vez, en el iPhone: Ajustes → General → VPN y gestión de
   dispositivos → confía en tu certificado de desarrollador. Acepta el permiso
   de cámara al abrir la captura.

## Correr en Android

1. Instala con el SDK Manager de Android Studio: *Android SDK Platform* reciente,
   *Platform-Tools* y *Command-line Tools*. Acepta las licencias:

   ```bash
   flutter doctor --android-licenses
   ```

2. En el teléfono activa *Opciones de desarrollador* → **Depuración USB** y
   conéctalo (acepta la huella RSA).
3. Ejecuta:

   ```bash
   flutter devices
   flutter run -d <id-del-android>
   ```

   La primera compilación tarda varios minutos (Gradle descarga dependencias y
   el NDK). Acepta el permiso de cámara al abrir la captura.

APK para instalar a mano:

```bash
flutter build apk --release
```

Queda en `build/app/outputs/flutter-apk/app-release.apk` (firmado con la clave de
debug: sirve para pruebas, no para Play Store).

## Comprobar cambios

```bash
flutter analyze
flutter test
```

## Problemas comunes

- **iOS: errores de pods** → `cd ios && pod deintegrate && pod install --repo-update`.
- **iOS: "Untrusted Developer"** → ver paso 5 de iOS.
- **Android: versión de Java** → `flutter config --jdk-dir <ruta-al-JDK-17>`.
- **Cualquier plataforma tras cambiar dependencias** → `flutter clean && flutter pub get`.

## Privacidad y alcance

NutriScan es un prototipo **educativo**, no una herramienta médica. Los
resultados experimentales pueden ser inexactos y no deben usarse para decisiones
de salud. El consentimiento general de uso no autoriza guardar ni reutilizar
fotos para investigación o entrenamiento. El perfil permite borrar los datos
disponibles.

El alcance actual excluye a menores de 18 años.
