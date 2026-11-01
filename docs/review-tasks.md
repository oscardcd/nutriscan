# Revisión del flujo — rama `feat/screen-result`

**Resumen.** El flujo real es `/welcome` (consentimiento) → `/capture` (shell con tabs Medir/Historial/Perfil); `/result` existe pero ninguna pantalla navega hacia él y pinta datos de ejemplo fijos. El consentimiento vive en `setState` sin persistencia ni guard de router: se pierde en cada arranque y `/capture` es alcanzable por deep link sin aceptar. La captura es un mock estático que muestra lecturas "en vivo" inventadas, y las notas de los índices del resultado son interpretaciones fijas que no dependen del valor (fuga del principio "nunca diagnóstico"). Historial y Perfil son placeholders.
**Verificación:** `flutter analyze` sin issues y `flutter test` 11/11 OK (corrido por Zoitx; el revisor no pudo ejecutar comandos). Los tests existentes usan superficies de 800×1600+, así que no detectarían desbordes en móvil.

---

## [P0] Consentimiento sin guard ni persistencia
- **Archivo:** lib/core/router/app_router.dart:13
- **Problema:** `GoRouter` no tiene `redirect`; `/capture`, `/history`, `/profile` y `/result` se abren por deep link sin consentimiento. Además el consentimiento vive en `_ConsentScreenState` (lib/features/consent/presentation/consent_screen.dart:18) y se pierde en cada arranque, así que el usuario lo repite siempre. Contradice el doc "Única puerta de entrada a la medición".
- **Fix:** guardar el consentimiento (`flutter_secure_storage`, ya instalado) detrás de un provider Riverpod. Añadir `redirect` en `GoRouter` (con `refreshListenable`) que mande a `/welcome` si no hay consentimiento y saque de `/welcome` si ya lo hay. Usar `initialLocation` solo como fallback.
- **Esfuerzo:** M

## [P0] Notas de índices fijas = interpretación clínica falsa
- **Archivo:** lib/features/result/presentation/result_screen.dart:104
- **Problema:** `whtrNote` ("Distribución abdominal moderada") y `briNote` ("Morfología dentro de parámetros esperados") son textos constantes. Con WHtR 0.65 o BRI 7 la app sigue diciendo "moderada/esperados": un juicio clínico inventado que viola el principio "nunca diagnóstico".
- **Fix:** sustituirlas por descripciones neutras de qué mide cada índice ("Relación cintura/estatura"), sin valoración. Si más adelante se quiere una lectura por rangos, debe derivarse del valor, tener tests y redactarse como "referencia de cribado".
- **Esfuerzo:** S

## [P0] `/result` inalcanzable y con datos ficticios
- **Archivo:** lib/core/router/app_router.dart:19
- **Problema:** ninguna pantalla navega a `/result`. Si se abre (por deep link o al conectarla), muestra un IMC 27.4 "Sobrepeso, confianza alta" que nadie midió. Si esto llega a una build, se presenta un resultado de salud falso.
- **Fix:** pasar `ScreeningResult` vía `state.extra` o provider. Si no hay resultado, hacer `redirect` a `/capture`. Mover el mock a la galería o a los tests. Como hoy la captura no produce resultados, no exponer la ruta hasta tener la pipeline.
- **Esfuerzo:** S

## [P1] CTA bajo el indicador de inicio en pantallas fuera del shell
- **Archivo:** lib/features/consent/presentation/consent_screen.dart:30 y lib/features/result/presentation/result_screen.dart:26
- **Problema:** `SafeArea(bottom: false)` en pantallas sin `NavigationBar`. En iPhone con home indicator o en Android con navegación por gestos, el botón "Comenzar evaluación"/"Volver a medir" queda pegado al borde o solapado por la barra de gestos.
- **Fix:** quitar `bottom: false` en estas dos pantallas, o envolver el padding del CTA en `SafeArea(top: false)`.
- **Esfuerzo:** S

## [P1] Back y close de Captura reinician el consentimiento; el back de sistema cierra la app
- **Archivo:** lib/features/capture/presentation/capture_screen.dart:24
- **Problema:** las dos acciones (flecha y X) hacen `context.go('/welcome')`, que reconstruye `ConsentScreen` con las casillas desmarcadas. Como se llegó con `go`, no queda pila: el back de Android en `/capture` sale de la app. Captura es raíz de un tab, así que dos botones de salida redundantes confunden.
- **Fix:** quitar la flecha back (es un tab raíz). Si se quiere "cerrar", que no vuelva a consentimiento una vez persistido (ver P0). Opcional: `PopScope` para confirmar la salida.
- **Esfuerzo:** S

## [P1] Obturador anunciado como botón activo que no hace nada
- **Archivo:** lib/features/capture/presentation/capture_screen.dart:348
- **Problema:** `Semantics(button: true, label: 'Capturar')` sobre un `Container` sin `onTap` ni `enabled: false`. TalkBack/VoiceOver lo anuncian como botón activo y el doble toque no hace nada.
- **Fix:** usar `IconButton.filled(onPressed: null, …)` con tamaño de 64, o añadir `enabled: false` al `Semantics`. Cuando haya cámara, conectar `onTap`.
- **Esfuerzo:** S

## [P1] Captura muestra lecturas "en vivo" inventadas y datos dentro de i18n
- **Archivo:** lib/features/capture/presentation/capture_screen.dart:199 · lib/i18n/strings_es.i18n.json:16-23
- **Problema:** "Alineada y nivelada", "0.2° · Óptima", "Sensor: Listo", "2.1 m" y "3 / 4 aprobados" aparecen como estado real sin que haya cámara. El usuario cree que el sistema ya lo detecta. Además los números están dentro de las traducciones, así que no se pueden alimentar con valores reales.
- **Fix:** mientras no exista `core/vision`, mostrar un estado neutro ("Esperando cámara") o el criterio sin valor. Parametrizar con slang (`approved: "{ok} / {total} aprobados"`, `distanceValue: "{m} m"`) y pasar los datos desde un modelo de estado de captura.
- **Esfuerzo:** M

## [P1] Casilla de consentimiento sin etiqueta accesible
- **Archivo:** lib/core/ui/components/consent_checkbox.dart:36
- **Problema:** el `Checkbox` y el `Text.rich` son nodos semánticos separados. El lector de pantalla anuncia "casilla, no marcada" sin texto y después el texto como no interactivo. En un consentimiento legal, el usuario ciego no sabe qué acepta.
- **Fix:** envolver la fila en `MergeSemantics`, o en `Semantics(checked: value, label: prefix+highlight+suffix)` con `ExcludeSemantics` en los hijos. Añadir un test con `tester.getSemantics`.
- **Esfuerzo:** S

## [P1] Avatar del header: muerto, sin etiqueta y < 48 dp
- **Archivo:** lib/core/ui/components/app_header.dart:61
- **Problema:** `InkResponse` con `onProfileTap` nulo en Consentimiento y Resultado (no se pasa). Se ve tocable pero no hace nada, no tiene label semántico y el área es de 32 dp, por debajo del mínimo de 48.
- **Fix:** si `onProfileTap == null`, no renderizar el avatar. Si se renderiza, usar `IconButton` (48 dp y tooltip) con un texto i18n como label. En Resultado, conectar con `context.go('/profile')`.
- **Esfuerzo:** S

## [P1] Desbordes en pantallas pequeñas o con texto grande
- **Archivo:** lib/features/capture/presentation/capture_screen.dart:241 y :338
- **Problema:** en `_AlignmentRow` el valor (`Text` sin `Flexible`) compite con un label `Expanded`. Con 320 dp y escala de texto 1.5–2.0, "Alineada y nivelada" desborda (franja amarilla). En `_CaptureBar`, dos `OutlinedButton.icon` de unos 100 dp con el círculo de 64 cortan "Galería" o "3 seg" con texto grande. `MetricTile` (lib/core/ui/components/metric_tile.dart:36) tampoco envuelve el valor.
- **Fix:** envolver el valor en `Flexible` con `textAlign: end`, o pasar a `Wrap`/columna cuando `MediaQuery.textScalerOf` sea mayor de 1.3. En la barra, iconos con tooltip en lugar de icono + label en anchos pequeños. Añadir tests a 320×640 con `textScaler: TextScaler.linear(2)`.
- **Esfuerzo:** M

## [P1] Faltan tests de navegación y de layout realista
- **Archivo:** test/features/
- **Problema:** no hay ningún test del router: consentimiento → captura, guard, tabs que conservan estado, `/result` sin datos. Todos los widget tests usan superficies de 800×1600+, así que los desbordes de móvil y los textos largos en inglés pasan sin detectarse. `ScreeningResult` no valida entradas (margen negativo, NaN) y no hay tests de eso.
- **Fix:** `test/router_test.dart` con `MaterialApp.router(routerConfig: appRouter)` que cubra el guard y el flujo. Un helper de pump a 360×690 con locale `en` y `es`. Añadir `assert(margin >= 0 && bmi.isFinite)` en `ScreeningResult` con su test.
- **Esfuerzo:** M

## [P1] Gauge de IMC invisible para lectores y roto en modo oscuro
- **Archivo:** lib/core/theme/widgets/bmi_range_gauge.dart:43
- **Problema:** el widget no tiene `Semantics`, así que el lector salta el elemento visual principal. El marcador usa `AppColors.surface`/`AppColors.primary` fijos: en oscuro queda un círculo blanco con borde teal oscuro, de bajo contraste. Tampoco centra bien el marcador: el borde izquierdo está en `travel*position`, desplazado hasta 8 dp respecto al punto real de la escala.
- **Fix:** `Semantics(label: 'IMC 27.4, banda Sobrepeso')`, con el texto vía i18n, junto con `ExcludeSemantics` del dibujo. Tomar los colores de `Theme.of(context).colorScheme`. Usar `left: width*position - markerSize/2` con clamp.
- **Esfuerzo:** S

## [P2] Números y frases armadas por concatenación
- **Archivo:** lib/features/result/presentation/result_screen.dart:54
- **Problema:** el caption se arma como `'±' + margen + ' · ' + rangeLabel + …`, sin control del orden por idioma. `toStringAsFixed` usa punto decimal también en `es` (se espera "27,4").
- **Fix:** una clave slang con parámetros (`rangeCaption: "±{margin} · rango de estimación {min} – {max}"`) y `NumberFormat.decimalPattern(locale)` de `intl` (ya instalado).
- **Esfuerzo:** S

## [P2] Ruta `/gallery` de desarrollo expuesta en producción
- **Archivo:** lib/core/router/app_router.dart:17
- **Problema:** la galería del design system se registra siempre y es accesible por deep link en release.
- **Fix:** `if (kDebugMode) GoRoute(path: '/gallery', …)` dentro de la lista de rutas.
- **Esfuerzo:** S

## [P2] ConfidenceMeter: contraste en oscuro y doble lectura
- **Archivo:** lib/core/ui/components/confidence_meter.dart:37 y :60
- **Problema:** el label `Semantics` de los segmentos repite el texto visible, así que se lee dos veces. Con confianza alta el texto usa `bandNormalText` (#047857) fijo, con bajo contraste sobre la superficie oscura (#161E22).
- **Fix:** `ExcludeSemantics` en los segmentos, o `MergeSemantics` en el `Row`. Elegir el color del texto según `brightness`, como hace `BmiBandChip`.
- **Esfuerzo:** S

## [P2] Perfil con acciones muertas
- **Archivo:** lib/features/profile/presentation/profile_screen.dart:15 y :23
- **Problema:** "Estatura · Requerida", "Sexo", "Edad" y "Borrar todos los datos" son `ListTile` sin `onTap`. Parecen interactivos y no responden. Borrar datos es una promesa de privacidad visible.
- **Fix:** mientras no estén implementados, mostrarlos deshabilitados (`enabled: false`) con un subtítulo "Próximamente", o quitarlos. Al implementar el borrado, confirmar con diálogo y limpiar el storage (consentimiento incluido).
- **Esfuerzo:** S

## [P2] Lenguaje "diagnóstico" y promesas no verificables
- **Archivo:** lib/core/theme/widgets/bmi_band_chip.dart:7 · lib/core/theme/app_colors.dart:34 · lib/i18n/strings_es.i18n.json:67-69
- **Problema:** el código llama "Diagnostic bands" / "banda de diagnóstico" a las bandas de cribado, una deriva semántica que acaba filtrándose a la UI. El copy afirma "se ejecuta en el chip neural local" y "la captura se descarta inmediatamente", cosas que aún no existen y que no están garantizadas (TFLite puede correr en CPU).
- **Fix:** renombrar los comentarios a "bandas de cribado". Redactar "se ejecuta en tu dispositivo" y mantener la promesa de descarte solo cuando exista el código, con un test que la respalde.
- **Esfuerzo:** S
