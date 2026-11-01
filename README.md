# NutriScan

Screening de estado nutricional por imágenes, **100% on-device**. App Flutter para adultos (≥18) que estima la banda de IMC (bajo peso / normal / sobrepeso / obesidad) a partir de fotos guiadas.

> Herramienta de **tamizaje**, no diagnóstico médico. Toda salida incluye disclaimer.

## Estado

Infraestructura (F0→F1). La captura, segmentación y el modelo TFLite están pendientes; las pantallas actuales son placeholders navegables.

## Stack

| Área | Paquete |
|---|---|
| Estado | `flutter_riverpod` |
| Navegación | `go_router` (shell con bottom nav) |
| Cámara | `camera` + `permission_handler` |
| Visión | `google_mlkit_pose_detection`, `google_mlkit_selfie_segmentation` |
| ML | `tflite_flutter` |
| Datos sensibles | `flutter_secure_storage` |
| Modelos | `freezed` + `json_serializable` (build_runner) |

## Estructura (feature-first + MVVM)

```
lib/
  app.dart                  # MaterialApp.router
  main.dart                 # ProviderScope
  core/
    router/                 # go_router + shell
    theme/                  # paleta y temas
    vision/                 # (vacío) pipeline compartido
  features/
    capture/                # cámara, overlay de encuadre
    measurement/            # silueta + pose + índices
    classify/               # IMC -> banda + confianza
    history/                # tracking longitudinal
    profile/                # estatura, sexo, edad, privacidad
  data/
    ml/                     # modelos TFLite
    local/                  # repos cifrados
docs/
  planning.md               # alcance y decisiones
  stitch-prompt-ui.md       # prompt de UI (10 pantallas)
```

## Empezar

```bash
flutter pub get
flutter run
```

Permisos requeridos: cámara. iOS ya declara `NSCameraUsageDescription` en `Info.plist`; Android usa `permission_handler` en runtime.

## Verificación

```bash
flutter analyze
flutter test
```

## Privacidad

Las fotos corporales son dato sensible: no se suben, no se almacenan crudas y el usuario puede borrar todo desde Perfil.

## Roadmap

Ver `docs/planning.md` §9: F0 spike → F1 MVP (foto frontal + índices) → F2 (lateral + CNN) → F3 (clínico).
