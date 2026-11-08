/// Generated file. Do not edit.
///
/// Original: lib/i18n
/// To regenerate, run: `dart run slang`
///
/// Locales: 2
/// Strings: 279 (139 per locale)
///
/// Built on 2026-11-08 at 19:49 UTC

// coverage:ignore-file
// ignore_for_file: type=lint

import 'package:flutter/widgets.dart';
import 'package:slang/builder/model/node.dart';
import 'package:slang_flutter/slang_flutter.dart';
export 'package:slang_flutter/slang_flutter.dart';

const AppLocale _baseLocale = AppLocale.es;

/// Supported locales, see extension methods below.
///
/// Usage:
/// - LocaleSettings.setLocale(AppLocale.es) // set locale
/// - Locale locale = AppLocale.es.flutterLocale // get flutter locale from enum
/// - if (LocaleSettings.currentLocale == AppLocale.es) // locale check
enum AppLocale with BaseAppLocale<AppLocale, Translations> {
	es(languageCode: 'es', build: Translations.build),
	en(languageCode: 'en', build: _StringsEn.build);

	const AppLocale({required this.languageCode, this.scriptCode, this.countryCode, required this.build}); // ignore: unused_element

	@override final String languageCode;
	@override final String? scriptCode;
	@override final String? countryCode;
	@override final TranslationBuilder<AppLocale, Translations> build;

	/// Gets current instance managed by [LocaleSettings].
	Translations get translations => LocaleSettings.instance.translationMap[this]!;
}

/// Method A: Simple
///
/// No rebuild after locale change.
/// Translation happens during initialization of the widget (call of t).
/// Configurable via 'translate_var'.
///
/// Usage:
/// String a = t.someKey.anotherKey;
/// String b = t['someKey.anotherKey']; // Only for edge cases!
Translations get t => LocaleSettings.instance.currentTranslations;

/// Method B: Advanced
///
/// All widgets using this method will trigger a rebuild when locale changes.
/// Use this if you have e.g. a settings page where the user can select the locale during runtime.
///
/// Step 1:
/// wrap your App with
/// TranslationProvider(
/// 	child: MyApp()
/// );
///
/// Step 2:
/// final t = Translations.of(context); // Get t variable.
/// String a = t.someKey.anotherKey; // Use t variable.
/// String b = t['someKey.anotherKey']; // Only for edge cases!
class TranslationProvider extends BaseTranslationProvider<AppLocale, Translations> {
	TranslationProvider({required super.child}) : super(settings: LocaleSettings.instance);

	static InheritedLocaleData<AppLocale, Translations> of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context);
}

/// Method B shorthand via [BuildContext] extension method.
/// Configurable via 'translate_var'.
///
/// Usage (e.g. in a widget's build method):
/// context.t.someKey.anotherKey
extension BuildContextTranslationsExtension on BuildContext {
	Translations get t => TranslationProvider.of(this).translations;
}

/// Manages all translation instances and the current locale
class LocaleSettings extends BaseFlutterLocaleSettings<AppLocale, Translations> {
	LocaleSettings._() : super(utils: AppLocaleUtils.instance);

	static final instance = LocaleSettings._();

	// static aliases (checkout base methods for documentation)
	static AppLocale get currentLocale => instance.currentLocale;
	static Stream<AppLocale> getLocaleStream() => instance.getLocaleStream();
	static AppLocale setLocale(AppLocale locale, {bool? listenToDeviceLocale = false}) => instance.setLocale(locale, listenToDeviceLocale: listenToDeviceLocale);
	static AppLocale setLocaleRaw(String rawLocale, {bool? listenToDeviceLocale = false}) => instance.setLocaleRaw(rawLocale, listenToDeviceLocale: listenToDeviceLocale);
	static AppLocale useDeviceLocale() => instance.useDeviceLocale();
	@Deprecated('Use [AppLocaleUtils.supportedLocales]') static List<Locale> get supportedLocales => instance.supportedLocales;
	@Deprecated('Use [AppLocaleUtils.supportedLocalesRaw]') static List<String> get supportedLocalesRaw => instance.supportedLocalesRaw;
	static void setPluralResolver({String? language, AppLocale? locale, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver}) => instance.setPluralResolver(
		language: language,
		locale: locale,
		cardinalResolver: cardinalResolver,
		ordinalResolver: ordinalResolver,
	);
}

/// Provides utility functions without any side effects.
class AppLocaleUtils extends BaseAppLocaleUtils<AppLocale, Translations> {
	AppLocaleUtils._() : super(baseLocale: _baseLocale, locales: AppLocale.values);

	static final instance = AppLocaleUtils._();

	// static aliases (checkout base methods for documentation)
	static AppLocale parse(String rawLocale) => instance.parse(rawLocale);
	static AppLocale parseLocaleParts({required String languageCode, String? scriptCode, String? countryCode}) => instance.parseLocaleParts(languageCode: languageCode, scriptCode: scriptCode, countryCode: countryCode);
	static AppLocale findDeviceLocale() => instance.findDeviceLocale();
	static List<Locale> get supportedLocales => instance.supportedLocales;
	static List<String> get supportedLocalesRaw => instance.supportedLocalesRaw;
}

// translations

// Path: <root>
class Translations implements BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.es,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <es>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	// Translations
	String get appTitle => 'NutriScan';
	late final _StringsNavEs nav = _StringsNavEs._(_root);
	late final _StringsCaptureEs capture = _StringsCaptureEs._(_root);
	late final _StringsHistoryEs history = _StringsHistoryEs._(_root);
	late final _StringsProfileEs profile = _StringsProfileEs._(_root);
	late final _StringsBandEs band = _StringsBandEs._(_root);
	late final _StringsDisclaimerEs disclaimer = _StringsDisclaimerEs._(_root);
	late final _StringsOnDeviceEs onDevice = _StringsOnDeviceEs._(_root);
	late final _StringsConsentEs consent = _StringsConsentEs._(_root);
	late final _StringsResultEs result = _StringsResultEs._(_root);
	late final _StringsSettingsEs settings = _StringsSettingsEs._(_root);
}

// Path: nav
class _StringsNavEs {
	_StringsNavEs._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get measure => 'Medir';
	String get history => 'Historial';
	String get profile => 'Perfil';
}

// Path: capture
class _StringsCaptureEs {
	_StringsCaptureEs._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Captura biométrica';
	String get onDevice => 'En el dispositivo';
	String get localBadge => 'Cómputo local';
	String get alignment => 'Alineación corporal';
	String get posture => 'Cuerpo completo, de frente';
	String get tilt => 'Teléfono recto y nivelado';
	String get sensor => 'Enciende la cámara antes de tomar la foto';
	String get distance => 'A 2 metros del teléfono';
	String get criteria => 'Criterios de escaneo';
	String get fullBody => 'Cuerpo completo';
	String get twoMeters => 'A 2 metros';
	String get plainBackground => 'Fondo liso y uniforme';
	String get looseClothing => 'Evitar ropa holgada';
	String get sideView => 'Incluir vista lateral';
	String get sideViewHint => 'Recomendado para mayor precisión corporal';
	String get gallery => 'Galería';
	String get timer => '3 seg';
	String get shutter => 'Capturar';
	String get cameraStart => 'Activar cámara';
	String get cameraStartHint => 'Toca para activar la cámara.';
	String get cameraPreparing => 'Preparando la cámara…';
	String get cameraPermission => 'Se necesita permiso para usar la cámara.';
	String get cameraPermissionSettings => 'El permiso está desactivado. Actívalo en los ajustes de la app.';
	String get cameraPermissionRestricted => 'El acceso a la cámara está restringido en este dispositivo.';
	String get cameraUnavailable => 'No se encontró una cámara disponible en este dispositivo.';
	String get cameraError => 'No se pudo iniciar o usar la cámara. Inténtalo de nuevo.';
	String get cameraRetry => 'Reintentar';
	String get cameraOpenSettings => 'Abrir ajustes';
	String get cameraCaptured => 'Foto guardada temporalmente en memoria. El análisis visual aún no está disponible.';
	String get cameraRetake => 'Tomar otra foto';
	String get localNote => 'Las fotos permanecen en este teléfono y no se envían a ningún servidor.';
	String get webUnavailableTitle => 'Captura no disponible en este navegador';
	String get webUnavailable => 'El análisis de imagen aún no está disponible en este navegador. NutriScan es un prototipo educativo, no una herramienta médica.';
	String get poseDebugTitle => 'Diagnóstico de pose (experimental)';
	String get poseDebugHint => 'Ejecuta el detector local sobre la foto capturada. Solo para pruebas en dispositivo.';
	String get poseDebugRun => 'Analizar pose';
	String get poseDebugFailed => 'Error de análisis';
	String get poseQualityUsable => 'Pose utilizable para verificación técnica';
	String get poseQualityNoPerson => 'No se detectó persona';
	String get poseQualityMultiple => 'Varias personas en la foto';
	String get poseQualityLowConfidence => 'Confianza baja de pose';
	String get poseQualityIncomplete => 'Cuerpo incompleto en el encuadre';
	String get alignmentSearching => 'Buscando tu cuerpo…';
	String get alignmentOk => 'Posición correcta';
	String get alignmentIncomplete => 'Cuerpo completo: de la cabeza a los pies';
	String get alignmentTooFar => 'Acércate: el cuerpo se ve pequeño';
	String get alignmentTooClose => 'Aléjate: el cuerpo no cabe en el encuadre';
	String get alignmentNotCentered => 'Céntrate en el encuadre';
	String get alignmentTilted => 'Ponte recto, hombros y caderas nivelados';
	String get alignmentNotFrontal => 'Ponte de frente a la cámara';
	String get alignmentArms => 'Separa los brazos del torso';
	String get alignmentPhotoWarning => 'La foto se guarda igual; puedes repetirla si quieres.';
	String get photoResultTitle => 'Revisión de la foto';
	String get photoResultKeep => 'Usar esta foto';
	String get bodyDataTitle => 'Tus datos';
	String get bodyHeight => 'Estatura (cm)';
	String get bodyWeight => 'Peso (kg)';
	String get bodyHeightError => 'Entre 80 y 250 cm';
	String get bodyWeightError => 'Entre 20 y 400 kg';
	String get bodyContinue => 'Calcular IMC';
	String get bodySkip => 'Ahora no';
}

// Path: history
class _StringsHistoryEs {
	_StringsHistoryEs._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Tu progreso';
	String get empty => 'Aún no hay mediciones';
}

// Path: profile
class _StringsProfileEs {
	_StringsProfileEs._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Perfil';
	String get height => 'Estatura';
	String get sex => 'Sexo';
	String get age => 'Edad';
	String get onDevice => 'Procesamiento on-device';
	String get onDeviceLocked => 'Activado y bloqueado';
	String get deleteAll => 'Borrar todos los datos';
	String get comingSoon => 'Próximamente';
	String get deleteConfirmTitle => '¿Borrar todos los datos?';
	String get deleteConfirmBody => 'Se eliminarán las mediciones guardadas y tu consentimiento de este dispositivo. No se puede deshacer.';
	String get cancel => 'Cancelar';
	String get delete => 'Borrar todo';
}

// Path: band
class _StringsBandEs {
	_StringsBandEs._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get underweight => 'Bajo peso';
	String get normal => 'Normal';
	String get overweight => 'Sobrepeso';
	String get obese => 'Obesidad';
}

// Path: disclaimer
class _StringsDisclaimerEs {
	_StringsDisclaimerEs._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get screening => 'Prototipo educativo. Los resultados son experimentales, pueden ser inexactos y no están validados para uso médico. No los uses para diagnóstico, tratamiento ni decisiones clínicas.';
}

// Path: onDevice
class _StringsOnDeviceEs {
	_StringsOnDeviceEs._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get pill => '100% On-Device';
}

// Path: consent
class _StringsConsentEs {
	_StringsConsentEs._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get subtitle => 'Inicio';
	String get heroTitle => 'Prototipo educativo de análisis corporal';
	String get heroBody => 'Proyecto académico experimental. El análisis de imágenes y las estimaciones aún no están validados; los resultados pueden ser inexactos.';
	String get deviceTitle => '100% en tu dispositivo';
	String get deviceBody => 'Las fotos nunca se suben ni salen de tu teléfono. El cálculo se ejecuta en tu dispositivo.';
	String get privacyTitle => 'Privacidad fotográfica estricta';
	String get privacyBody => 'Sin almacenamiento en la nube ni acceso a terceros.';
	String get screeningTitle => 'Uso educativo, no médico';
	String get screeningBody => 'No está validado para uso médico ni debe usarse para diagnóstico, tratamiento o decisiones sobre tu salud. Este consentimiento no autoriza guardar ni reutilizar fotos para investigación o entrenamiento.';
	String get termsTitle => 'Términos de Consentimiento';
	String get required => 'Requerido';
	String get termsBody => 'Para garantizar un uso seguro y ético, confirma las siguientes dos premisas antes de continuar:';
	String get screeningPrefix => 'Entiendo que es una ';
	String get screeningHighlight => 'prototipo educativo experimental';
	String get screeningSuffix => ' y no es una herramienta médica ni debe usarse para diagnóstico, tratamiento o decisiones clínicas.';
	String get processingPrefix => 'Autorizo el ';
	String get processingHighlight => 'procesamiento local de imágenes';
	String get processingSuffix => ' para probar funciones experimentales de aprendizaje cuando estén disponibles.';
	String get cta => 'Comenzar evaluación';
}

// Path: result
class _StringsResultEs {
	_StringsResultEs._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get subtitle => 'Resultado';
	String get screeningLabel => 'Resultado experimental';
	String get bmiLabel => 'Índice de masa corporal estimado';
	String rangeCaption({required Object margin, required Object min, required Object max}) => '±${margin} · rango de estimación ${min} – ${max}';
	String get confidenceLow => 'Confianza baja';
	String get confidenceMedium => 'Confianza media';
	String get confidenceHigh => 'Confianza alta';
	String get scaleTitle => 'Escala OMS';
	String get indicesTitle => 'Índices antropométricos';
	String get whtr => 'Cintura-altura (WHtR)';
	String get whtrNote => 'Proporción entre cintura y estatura';
	String get whtrExperimental => 'Estimado a partir de las proporciones de tu foto';
	String get whtrWarning => 'Aproximado (±10 %): se calcula con puntos de la pose, no es una medición clínica.';
	String get bri => 'Redondez corporal (BRI)';
	String get briNote => 'Forma del cuerpo derivada de perímetros';
	String get rfm => 'Masa grasa relativa (RFM)';
	String get rfmNote => 'Estimación basada en proporciones corporales';
	String get meaningTitle => '¿Qué significa este resultado?';
	String get meaningBody => 'Tu silueta se sitúa en una banda de referencia. El IMC y las proyecciones visuales no distinguen masa muscular magra de tejido adiposo: es un punto de partida preventivo para tu seguimiento.';
	String get cta => 'Volver a medir';
	String get noEstimateLabel => 'Resultado experimental';
	String get abstainPoseTitle => 'No se pudo medir la pose';
	String get abstainPoseBody => 'La foto no permite medir el cuerpo completo. Repite la captura siguiendo la silueta.';
	String get abstainAlignmentTitle => 'La foto no cumple la guía';
	String get abstainAlignmentBody => 'La posición no coincide con la silueta de referencia. Repite la captura con el cuerpo completo, centrado y de frente.';
	String get abstainNoModelTitle => 'Todavía no hay estimación';
	String get abstainNoModelBody => 'El modelo de estimación no está integrado en esta versión. La captura quedó validada técnicamente, pero no se muestran cifras para no inventar un resultado.';
	String get bmiComputedCaption => 'Calculado con el peso y la estatura que ingresaste';
	String get abstainBodyTitle => 'Faltan tus datos';
	String get abstainBodyBody => 'Necesitamos tu peso y estatura para calcular el IMC. Repite la captura e ingrésalos.';
}

// Path: settings
class _StringsSettingsEs {
	_StringsSettingsEs._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Idioma y tema';
	String get language => 'IDIOMA';
	String get theme => 'TEMA';
	String get themeSystem => 'Sistema';
	String get themeLight => 'Claro';
	String get themeDark => 'Oscuro';
}

// Path: <root>
class _StringsEn extends Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	_StringsEn.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super.build(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		super.$meta.setFlatMapFunction($meta.getTranslation); // copy base translations to super.$meta
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

	@override late final _StringsEn _root = this; // ignore: unused_field

	// Translations
	@override String get appTitle => 'NutriScan';
	@override late final _StringsNavEn nav = _StringsNavEn._(_root);
	@override late final _StringsCaptureEn capture = _StringsCaptureEn._(_root);
	@override late final _StringsHistoryEn history = _StringsHistoryEn._(_root);
	@override late final _StringsProfileEn profile = _StringsProfileEn._(_root);
	@override late final _StringsBandEn band = _StringsBandEn._(_root);
	@override late final _StringsDisclaimerEn disclaimer = _StringsDisclaimerEn._(_root);
	@override late final _StringsOnDeviceEn onDevice = _StringsOnDeviceEn._(_root);
	@override late final _StringsConsentEn consent = _StringsConsentEn._(_root);
	@override late final _StringsResultEn result = _StringsResultEn._(_root);
	@override late final _StringsSettingsEn settings = _StringsSettingsEn._(_root);
}

// Path: nav
class _StringsNavEn extends _StringsNavEs {
	_StringsNavEn._(_StringsEn root) : this._root = root, super._(root);

	@override final _StringsEn _root; // ignore: unused_field

	// Translations
	@override String get measure => 'Measure';
	@override String get history => 'History';
	@override String get profile => 'Profile';
}

// Path: capture
class _StringsCaptureEn extends _StringsCaptureEs {
	_StringsCaptureEn._(_StringsEn root) : this._root = root, super._(root);

	@override final _StringsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Biometric capture';
	@override String get onDevice => 'On device';
	@override String get localBadge => 'Local compute';
	@override String get alignment => 'Body alignment';
	@override String get posture => 'Full body, facing the camera';
	@override String get tilt => 'Phone upright and level';
	@override String get sensor => 'Turn on the camera before taking a photo';
	@override String get distance => '2 meters away from the phone';
	@override String get criteria => 'Scan criteria';
	@override String get fullBody => 'Full body';
	@override String get twoMeters => 'At 2 meters';
	@override String get plainBackground => 'Plain, even background';
	@override String get looseClothing => 'Avoid loose clothing';
	@override String get sideView => 'Add a side view';
	@override String get sideViewHint => 'Recommended for better body accuracy';
	@override String get gallery => 'Gallery';
	@override String get timer => '3 sec';
	@override String get shutter => 'Capture';
	@override String get cameraStart => 'Turn on camera';
	@override String get cameraStartHint => 'Tap to turn on the camera.';
	@override String get cameraPreparing => 'Preparing camera…';
	@override String get cameraPermission => 'Camera access is required.';
	@override String get cameraPermissionSettings => 'Camera access is turned off. Enable it in the app settings.';
	@override String get cameraPermissionRestricted => 'Camera access is restricted on this device.';
	@override String get cameraUnavailable => 'No camera is available on this device.';
	@override String get cameraError => 'The camera could not be started or used. Try again.';
	@override String get cameraRetry => 'Try again';
	@override String get cameraOpenSettings => 'Open settings';
	@override String get cameraCaptured => 'Photo temporarily held in memory. Image analysis is not available yet.';
	@override String get cameraRetake => 'Take another photo';
	@override String get localNote => 'Photos stay on this phone and are not sent to any server.';
	@override String get webUnavailableTitle => 'Capture not available in this browser';
	@override String get webUnavailable => 'Image analysis is not available in this browser yet. NutriScan is an educational prototype, not a medical tool.';
	@override String get poseDebugTitle => 'Pose diagnostics (experimental)';
	@override String get poseDebugHint => 'Runs the on-device detector over the captured photo. Device testing only.';
	@override String get poseDebugRun => 'Analyze pose';
	@override String get poseDebugFailed => 'Analysis error';
	@override String get poseQualityUsable => 'Pose usable for technical checks';
	@override String get poseQualityNoPerson => 'No person detected';
	@override String get poseQualityMultiple => 'Multiple people in the photo';
	@override String get poseQualityLowConfidence => 'Low pose confidence';
	@override String get poseQualityIncomplete => 'Body incomplete in frame';
	@override String get alignmentSearching => 'Looking for your body…';
	@override String get alignmentOk => 'Position looks good';
	@override String get alignmentIncomplete => 'Full body: head to feet';
	@override String get alignmentTooFar => 'Step closer: your body looks small';
	@override String get alignmentTooClose => 'Step back: your body doesn\'t fit the frame';
	@override String get alignmentNotCentered => 'Center yourself in the frame';
	@override String get alignmentTilted => 'Stand straight, level shoulders and hips';
	@override String get alignmentNotFrontal => 'Face the camera';
	@override String get alignmentArms => 'Keep your arms away from your torso';
	@override String get alignmentPhotoWarning => 'The photo is kept anyway; you can retake it if you want.';
	@override String get photoResultTitle => 'Photo check';
	@override String get photoResultKeep => 'Use this photo';
	@override String get bodyDataTitle => 'Your data';
	@override String get bodyHeight => 'Height (cm)';
	@override String get bodyWeight => 'Weight (kg)';
	@override String get bodyHeightError => 'Between 80 and 250 cm';
	@override String get bodyWeightError => 'Between 20 and 400 kg';
	@override String get bodyContinue => 'Calculate BMI';
	@override String get bodySkip => 'Not now';
}

// Path: history
class _StringsHistoryEn extends _StringsHistoryEs {
	_StringsHistoryEn._(_StringsEn root) : this._root = root, super._(root);

	@override final _StringsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Your progress';
	@override String get empty => 'No measurements yet';
}

// Path: profile
class _StringsProfileEn extends _StringsProfileEs {
	_StringsProfileEn._(_StringsEn root) : this._root = root, super._(root);

	@override final _StringsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Profile';
	@override String get height => 'Height';
	@override String get sex => 'Sex';
	@override String get age => 'Age';
	@override String get onDevice => 'On-device processing';
	@override String get onDeviceLocked => 'Enabled and locked';
	@override String get deleteAll => 'Delete all data';
	@override String get comingSoon => 'Coming soon';
	@override String get deleteConfirmTitle => 'Delete all data?';
	@override String get deleteConfirmBody => 'Saved measurements and your consent will be erased from this device. This cannot be undone.';
	@override String get cancel => 'Cancel';
	@override String get delete => 'Delete all';
}

// Path: band
class _StringsBandEn extends _StringsBandEs {
	_StringsBandEn._(_StringsEn root) : this._root = root, super._(root);

	@override final _StringsEn _root; // ignore: unused_field

	// Translations
	@override String get underweight => 'Underweight';
	@override String get normal => 'Normal';
	@override String get overweight => 'Overweight';
	@override String get obese => 'Obese';
}

// Path: disclaimer
class _StringsDisclaimerEn extends _StringsDisclaimerEs {
	_StringsDisclaimerEn._(_StringsEn root) : this._root = root, super._(root);

	@override final _StringsEn _root; // ignore: unused_field

	// Translations
	@override String get screening => 'Educational prototype. Results are experimental, may be inaccurate, and are not validated for medical use. Do not use them for diagnosis, treatment, or clinical decisions.';
}

// Path: onDevice
class _StringsOnDeviceEn extends _StringsOnDeviceEs {
	_StringsOnDeviceEn._(_StringsEn root) : this._root = root, super._(root);

	@override final _StringsEn _root; // ignore: unused_field

	// Translations
	@override String get pill => '100% On-Device';
}

// Path: consent
class _StringsConsentEn extends _StringsConsentEs {
	_StringsConsentEn._(_StringsEn root) : this._root = root, super._(root);

	@override final _StringsEn _root; // ignore: unused_field

	// Translations
	@override String get subtitle => 'Home';
	@override String get heroTitle => 'Educational body-analysis prototype';
	@override String get heroBody => 'Experimental academic project. Image analysis and estimates are not validated yet; results may be inaccurate.';
	@override String get deviceTitle => '100% on your device';
	@override String get deviceBody => 'Photos are never uploaded or leave your phone. The calculation runs on your device.';
	@override String get privacyTitle => 'Strict photo privacy';
	@override String get privacyBody => 'No cloud storage and no third-party access.';
	@override String get screeningTitle => 'Educational use, not medical use';
	@override String get screeningBody => 'Not validated for medical use and must not be used for diagnosis, treatment, or health decisions. This consent does not authorize storing or reusing photos for research or training.';
	@override String get termsTitle => 'Consent Terms';
	@override String get termsBody => 'To ensure safe and ethical use, confirm the following two premises before continuing:';
	@override String get screeningPrefix => 'I understand this is a ';
	@override String get screeningHighlight => 'experimental educational prototype';
	@override String get screeningSuffix => ' and is not a medical tool or for diagnosis, treatment, or clinical decisions.';
	@override String get processingPrefix => 'I authorize ';
	@override String get processingHighlight => 'on-device image processing';
	@override String get processingSuffix => ' to try experimental learning features when available.';
	@override String get cta => 'Start assessment';
}

// Path: result
class _StringsResultEn extends _StringsResultEs {
	_StringsResultEn._(_StringsEn root) : this._root = root, super._(root);

	@override final _StringsEn _root; // ignore: unused_field

	// Translations
	@override String get subtitle => 'Result';
	@override String get screeningLabel => 'Experimental result';
	@override String get bmiLabel => 'Estimated body mass index';
	@override String rangeCaption({required Object margin, required Object min, required Object max}) => '±${margin} · estimate range ${min} – ${max}';
	@override String get confidenceLow => 'Low confidence';
	@override String get confidenceMedium => 'Medium confidence';
	@override String get confidenceHigh => 'High confidence';
	@override String get scaleTitle => 'WHO scale';
	@override String get indicesTitle => 'Anthropometric indices';
	@override String get whtr => 'Waist-to-height (WHtR)';
	@override String get whtrNote => 'Ratio of waist to height';
	@override String get whtrExperimental => 'Estimated from the proportions in your photo';
	@override String get whtrWarning => 'Approximate (±10%): computed from pose landmarks, not a clinical measurement.';
	@override String get bri => 'Body roundness (BRI)';
	@override String get briNote => 'Body shape derived from circumferences';
	@override String get rfm => 'Relative fat mass (RFM)';
	@override String get rfmNote => 'Estimate based on body proportions';
	@override String get meaningTitle => 'What does this result mean?';
	@override String get meaningBody => 'Your silhouette falls in a reference band. BMI and visual projections do not distinguish lean muscle from fat tissue: it is a preventive starting point for your tracking.';
	@override String get cta => 'Measure again';
	@override String get noEstimateLabel => 'Experimental result';
	@override String get abstainPoseTitle => 'The pose could not be measured';
	@override String get abstainPoseBody => 'This photo does not allow measuring the full body. Retake it following the silhouette.';
	@override String get abstainAlignmentTitle => 'The photo does not follow the guide';
	@override String get abstainAlignmentBody => 'Your position does not match the reference silhouette. Retake it with your full body, centered and facing the camera.';
	@override String get abstainNoModelTitle => 'No estimate yet';
	@override String get abstainNoModelBody => 'The estimation model is not integrated in this version. The capture passed the technical checks, but no figures are shown so we do not invent a result.';
	@override String get bmiComputedCaption => 'Calculated from the weight and height you entered';
	@override String get abstainBodyTitle => 'Your data is missing';
	@override String get abstainBodyBody => 'We need your weight and height to calculate BMI. Retake the capture and enter them.';
}

// Path: settings
class _StringsSettingsEn extends _StringsSettingsEs {
	_StringsSettingsEn._(_StringsEn root) : this._root = root, super._(root);

	@override final _StringsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Language and theme';
	@override String get language => 'LANGUAGE';
	@override String get theme => 'THEME';
	@override String get themeSystem => 'System';
	@override String get themeLight => 'Light';
	@override String get themeDark => 'Dark';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.

extension on Translations {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'appTitle': return 'NutriScan';
			case 'nav.measure': return 'Medir';
			case 'nav.history': return 'Historial';
			case 'nav.profile': return 'Perfil';
			case 'capture.title': return 'Captura biométrica';
			case 'capture.onDevice': return 'En el dispositivo';
			case 'capture.localBadge': return 'Cómputo local';
			case 'capture.alignment': return 'Alineación corporal';
			case 'capture.posture': return 'Cuerpo completo, de frente';
			case 'capture.tilt': return 'Teléfono recto y nivelado';
			case 'capture.sensor': return 'Enciende la cámara antes de tomar la foto';
			case 'capture.distance': return 'A 2 metros del teléfono';
			case 'capture.criteria': return 'Criterios de escaneo';
			case 'capture.fullBody': return 'Cuerpo completo';
			case 'capture.twoMeters': return 'A 2 metros';
			case 'capture.plainBackground': return 'Fondo liso y uniforme';
			case 'capture.looseClothing': return 'Evitar ropa holgada';
			case 'capture.sideView': return 'Incluir vista lateral';
			case 'capture.sideViewHint': return 'Recomendado para mayor precisión corporal';
			case 'capture.gallery': return 'Galería';
			case 'capture.timer': return '3 seg';
			case 'capture.shutter': return 'Capturar';
			case 'capture.cameraStart': return 'Activar cámara';
			case 'capture.cameraStartHint': return 'Toca para activar la cámara.';
			case 'capture.cameraPreparing': return 'Preparando la cámara…';
			case 'capture.cameraPermission': return 'Se necesita permiso para usar la cámara.';
			case 'capture.cameraPermissionSettings': return 'El permiso está desactivado. Actívalo en los ajustes de la app.';
			case 'capture.cameraPermissionRestricted': return 'El acceso a la cámara está restringido en este dispositivo.';
			case 'capture.cameraUnavailable': return 'No se encontró una cámara disponible en este dispositivo.';
			case 'capture.cameraError': return 'No se pudo iniciar o usar la cámara. Inténtalo de nuevo.';
			case 'capture.cameraRetry': return 'Reintentar';
			case 'capture.cameraOpenSettings': return 'Abrir ajustes';
			case 'capture.cameraCaptured': return 'Foto guardada temporalmente en memoria. El análisis visual aún no está disponible.';
			case 'capture.cameraRetake': return 'Tomar otra foto';
			case 'capture.localNote': return 'Las fotos permanecen en este teléfono y no se envían a ningún servidor.';
			case 'capture.webUnavailableTitle': return 'Captura no disponible en este navegador';
			case 'capture.webUnavailable': return 'El análisis de imagen aún no está disponible en este navegador. NutriScan es un prototipo educativo, no una herramienta médica.';
			case 'capture.poseDebugTitle': return 'Diagnóstico de pose (experimental)';
			case 'capture.poseDebugHint': return 'Ejecuta el detector local sobre la foto capturada. Solo para pruebas en dispositivo.';
			case 'capture.poseDebugRun': return 'Analizar pose';
			case 'capture.poseDebugFailed': return 'Error de análisis';
			case 'capture.poseQualityUsable': return 'Pose utilizable para verificación técnica';
			case 'capture.poseQualityNoPerson': return 'No se detectó persona';
			case 'capture.poseQualityMultiple': return 'Varias personas en la foto';
			case 'capture.poseQualityLowConfidence': return 'Confianza baja de pose';
			case 'capture.poseQualityIncomplete': return 'Cuerpo incompleto en el encuadre';
			case 'capture.alignmentSearching': return 'Buscando tu cuerpo…';
			case 'capture.alignmentOk': return 'Posición correcta';
			case 'capture.alignmentIncomplete': return 'Cuerpo completo: de la cabeza a los pies';
			case 'capture.alignmentTooFar': return 'Acércate: el cuerpo se ve pequeño';
			case 'capture.alignmentTooClose': return 'Aléjate: el cuerpo no cabe en el encuadre';
			case 'capture.alignmentNotCentered': return 'Céntrate en el encuadre';
			case 'capture.alignmentTilted': return 'Ponte recto, hombros y caderas nivelados';
			case 'capture.alignmentNotFrontal': return 'Ponte de frente a la cámara';
			case 'capture.alignmentArms': return 'Separa los brazos del torso';
			case 'capture.alignmentPhotoWarning': return 'La foto se guarda igual; puedes repetirla si quieres.';
			case 'capture.photoResultTitle': return 'Revisión de la foto';
			case 'capture.photoResultKeep': return 'Usar esta foto';
			case 'capture.bodyDataTitle': return 'Tus datos';
			case 'capture.bodyHeight': return 'Estatura (cm)';
			case 'capture.bodyWeight': return 'Peso (kg)';
			case 'capture.bodyHeightError': return 'Entre 80 y 250 cm';
			case 'capture.bodyWeightError': return 'Entre 20 y 400 kg';
			case 'capture.bodyContinue': return 'Calcular IMC';
			case 'capture.bodySkip': return 'Ahora no';
			case 'history.title': return 'Tu progreso';
			case 'history.empty': return 'Aún no hay mediciones';
			case 'profile.title': return 'Perfil';
			case 'profile.height': return 'Estatura';
			case 'profile.sex': return 'Sexo';
			case 'profile.age': return 'Edad';
			case 'profile.onDevice': return 'Procesamiento on-device';
			case 'profile.onDeviceLocked': return 'Activado y bloqueado';
			case 'profile.deleteAll': return 'Borrar todos los datos';
			case 'profile.comingSoon': return 'Próximamente';
			case 'profile.deleteConfirmTitle': return '¿Borrar todos los datos?';
			case 'profile.deleteConfirmBody': return 'Se eliminarán las mediciones guardadas y tu consentimiento de este dispositivo. No se puede deshacer.';
			case 'profile.cancel': return 'Cancelar';
			case 'profile.delete': return 'Borrar todo';
			case 'band.underweight': return 'Bajo peso';
			case 'band.normal': return 'Normal';
			case 'band.overweight': return 'Sobrepeso';
			case 'band.obese': return 'Obesidad';
			case 'disclaimer.screening': return 'Prototipo educativo. Los resultados son experimentales, pueden ser inexactos y no están validados para uso médico. No los uses para diagnóstico, tratamiento ni decisiones clínicas.';
			case 'onDevice.pill': return '100% On-Device';
			case 'consent.subtitle': return 'Inicio';
			case 'consent.heroTitle': return 'Prototipo educativo de análisis corporal';
			case 'consent.heroBody': return 'Proyecto académico experimental. El análisis de imágenes y las estimaciones aún no están validados; los resultados pueden ser inexactos.';
			case 'consent.deviceTitle': return '100% en tu dispositivo';
			case 'consent.deviceBody': return 'Las fotos nunca se suben ni salen de tu teléfono. El cálculo se ejecuta en tu dispositivo.';
			case 'consent.privacyTitle': return 'Privacidad fotográfica estricta';
			case 'consent.privacyBody': return 'Sin almacenamiento en la nube ni acceso a terceros.';
			case 'consent.screeningTitle': return 'Uso educativo, no médico';
			case 'consent.screeningBody': return 'No está validado para uso médico ni debe usarse para diagnóstico, tratamiento o decisiones sobre tu salud. Este consentimiento no autoriza guardar ni reutilizar fotos para investigación o entrenamiento.';
			case 'consent.termsTitle': return 'Términos de Consentimiento';
			case 'consent.required': return 'Requerido';
			case 'consent.termsBody': return 'Para garantizar un uso seguro y ético, confirma las siguientes dos premisas antes de continuar:';
			case 'consent.screeningPrefix': return 'Entiendo que es una ';
			case 'consent.screeningHighlight': return 'prototipo educativo experimental';
			case 'consent.screeningSuffix': return ' y no es una herramienta médica ni debe usarse para diagnóstico, tratamiento o decisiones clínicas.';
			case 'consent.processingPrefix': return 'Autorizo el ';
			case 'consent.processingHighlight': return 'procesamiento local de imágenes';
			case 'consent.processingSuffix': return ' para probar funciones experimentales de aprendizaje cuando estén disponibles.';
			case 'consent.cta': return 'Comenzar evaluación';
			case 'result.subtitle': return 'Resultado';
			case 'result.screeningLabel': return 'Resultado experimental';
			case 'result.bmiLabel': return 'Índice de masa corporal estimado';
			case 'result.rangeCaption': return ({required Object margin, required Object min, required Object max}) => '±${margin} · rango de estimación ${min} – ${max}';
			case 'result.confidenceLow': return 'Confianza baja';
			case 'result.confidenceMedium': return 'Confianza media';
			case 'result.confidenceHigh': return 'Confianza alta';
			case 'result.scaleTitle': return 'Escala OMS';
			case 'result.indicesTitle': return 'Índices antropométricos';
			case 'result.whtr': return 'Cintura-altura (WHtR)';
			case 'result.whtrNote': return 'Proporción entre cintura y estatura';
			case 'result.whtrExperimental': return 'Estimado a partir de las proporciones de tu foto';
			case 'result.whtrWarning': return 'Aproximado (±10 %): se calcula con puntos de la pose, no es una medición clínica.';
			case 'result.bri': return 'Redondez corporal (BRI)';
			case 'result.briNote': return 'Forma del cuerpo derivada de perímetros';
			case 'result.rfm': return 'Masa grasa relativa (RFM)';
			case 'result.rfmNote': return 'Estimación basada en proporciones corporales';
			case 'result.meaningTitle': return '¿Qué significa este resultado?';
			case 'result.meaningBody': return 'Tu silueta se sitúa en una banda de referencia. El IMC y las proyecciones visuales no distinguen masa muscular magra de tejido adiposo: es un punto de partida preventivo para tu seguimiento.';
			case 'result.cta': return 'Volver a medir';
			case 'result.noEstimateLabel': return 'Resultado experimental';
			case 'result.abstainPoseTitle': return 'No se pudo medir la pose';
			case 'result.abstainPoseBody': return 'La foto no permite medir el cuerpo completo. Repite la captura siguiendo la silueta.';
			case 'result.abstainAlignmentTitle': return 'La foto no cumple la guía';
			case 'result.abstainAlignmentBody': return 'La posición no coincide con la silueta de referencia. Repite la captura con el cuerpo completo, centrado y de frente.';
			case 'result.abstainNoModelTitle': return 'Todavía no hay estimación';
			case 'result.abstainNoModelBody': return 'El modelo de estimación no está integrado en esta versión. La captura quedó validada técnicamente, pero no se muestran cifras para no inventar un resultado.';
			case 'result.bmiComputedCaption': return 'Calculado con el peso y la estatura que ingresaste';
			case 'result.abstainBodyTitle': return 'Faltan tus datos';
			case 'result.abstainBodyBody': return 'Necesitamos tu peso y estatura para calcular el IMC. Repite la captura e ingrésalos.';
			case 'settings.title': return 'Idioma y tema';
			case 'settings.language': return 'IDIOMA';
			case 'settings.theme': return 'TEMA';
			case 'settings.themeSystem': return 'Sistema';
			case 'settings.themeLight': return 'Claro';
			case 'settings.themeDark': return 'Oscuro';
			default: return null;
		}
	}
}

extension on _StringsEn {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'appTitle': return 'NutriScan';
			case 'nav.measure': return 'Measure';
			case 'nav.history': return 'History';
			case 'nav.profile': return 'Profile';
			case 'capture.title': return 'Biometric capture';
			case 'capture.onDevice': return 'On device';
			case 'capture.localBadge': return 'Local compute';
			case 'capture.alignment': return 'Body alignment';
			case 'capture.posture': return 'Full body, facing the camera';
			case 'capture.tilt': return 'Phone upright and level';
			case 'capture.sensor': return 'Turn on the camera before taking a photo';
			case 'capture.distance': return '2 meters away from the phone';
			case 'capture.criteria': return 'Scan criteria';
			case 'capture.fullBody': return 'Full body';
			case 'capture.twoMeters': return 'At 2 meters';
			case 'capture.plainBackground': return 'Plain, even background';
			case 'capture.looseClothing': return 'Avoid loose clothing';
			case 'capture.sideView': return 'Add a side view';
			case 'capture.sideViewHint': return 'Recommended for better body accuracy';
			case 'capture.gallery': return 'Gallery';
			case 'capture.timer': return '3 sec';
			case 'capture.shutter': return 'Capture';
			case 'capture.cameraStart': return 'Turn on camera';
			case 'capture.cameraStartHint': return 'Tap to turn on the camera.';
			case 'capture.cameraPreparing': return 'Preparing camera…';
			case 'capture.cameraPermission': return 'Camera access is required.';
			case 'capture.cameraPermissionSettings': return 'Camera access is turned off. Enable it in the app settings.';
			case 'capture.cameraPermissionRestricted': return 'Camera access is restricted on this device.';
			case 'capture.cameraUnavailable': return 'No camera is available on this device.';
			case 'capture.cameraError': return 'The camera could not be started or used. Try again.';
			case 'capture.cameraRetry': return 'Try again';
			case 'capture.cameraOpenSettings': return 'Open settings';
			case 'capture.cameraCaptured': return 'Photo temporarily held in memory. Image analysis is not available yet.';
			case 'capture.cameraRetake': return 'Take another photo';
			case 'capture.localNote': return 'Photos stay on this phone and are not sent to any server.';
			case 'capture.webUnavailableTitle': return 'Capture not available in this browser';
			case 'capture.webUnavailable': return 'Image analysis is not available in this browser yet. NutriScan is an educational prototype, not a medical tool.';
			case 'capture.poseDebugTitle': return 'Pose diagnostics (experimental)';
			case 'capture.poseDebugHint': return 'Runs the on-device detector over the captured photo. Device testing only.';
			case 'capture.poseDebugRun': return 'Analyze pose';
			case 'capture.poseDebugFailed': return 'Analysis error';
			case 'capture.poseQualityUsable': return 'Pose usable for technical checks';
			case 'capture.poseQualityNoPerson': return 'No person detected';
			case 'capture.poseQualityMultiple': return 'Multiple people in the photo';
			case 'capture.poseQualityLowConfidence': return 'Low pose confidence';
			case 'capture.poseQualityIncomplete': return 'Body incomplete in frame';
			case 'capture.alignmentSearching': return 'Looking for your body…';
			case 'capture.alignmentOk': return 'Position looks good';
			case 'capture.alignmentIncomplete': return 'Full body: head to feet';
			case 'capture.alignmentTooFar': return 'Step closer: your body looks small';
			case 'capture.alignmentTooClose': return 'Step back: your body doesn\'t fit the frame';
			case 'capture.alignmentNotCentered': return 'Center yourself in the frame';
			case 'capture.alignmentTilted': return 'Stand straight, level shoulders and hips';
			case 'capture.alignmentNotFrontal': return 'Face the camera';
			case 'capture.alignmentArms': return 'Keep your arms away from your torso';
			case 'capture.alignmentPhotoWarning': return 'The photo is kept anyway; you can retake it if you want.';
			case 'capture.photoResultTitle': return 'Photo check';
			case 'capture.photoResultKeep': return 'Use this photo';
			case 'capture.bodyDataTitle': return 'Your data';
			case 'capture.bodyHeight': return 'Height (cm)';
			case 'capture.bodyWeight': return 'Weight (kg)';
			case 'capture.bodyHeightError': return 'Between 80 and 250 cm';
			case 'capture.bodyWeightError': return 'Between 20 and 400 kg';
			case 'capture.bodyContinue': return 'Calculate BMI';
			case 'capture.bodySkip': return 'Not now';
			case 'history.title': return 'Your progress';
			case 'history.empty': return 'No measurements yet';
			case 'profile.title': return 'Profile';
			case 'profile.height': return 'Height';
			case 'profile.sex': return 'Sex';
			case 'profile.age': return 'Age';
			case 'profile.onDevice': return 'On-device processing';
			case 'profile.onDeviceLocked': return 'Enabled and locked';
			case 'profile.deleteAll': return 'Delete all data';
			case 'profile.comingSoon': return 'Coming soon';
			case 'profile.deleteConfirmTitle': return 'Delete all data?';
			case 'profile.deleteConfirmBody': return 'Saved measurements and your consent will be erased from this device. This cannot be undone.';
			case 'profile.cancel': return 'Cancel';
			case 'profile.delete': return 'Delete all';
			case 'band.underweight': return 'Underweight';
			case 'band.normal': return 'Normal';
			case 'band.overweight': return 'Overweight';
			case 'band.obese': return 'Obese';
			case 'disclaimer.screening': return 'Educational prototype. Results are experimental, may be inaccurate, and are not validated for medical use. Do not use them for diagnosis, treatment, or clinical decisions.';
			case 'onDevice.pill': return '100% On-Device';
			case 'consent.subtitle': return 'Home';
			case 'consent.heroTitle': return 'Educational body-analysis prototype';
			case 'consent.heroBody': return 'Experimental academic project. Image analysis and estimates are not validated yet; results may be inaccurate.';
			case 'consent.deviceTitle': return '100% on your device';
			case 'consent.deviceBody': return 'Photos are never uploaded or leave your phone. The calculation runs on your device.';
			case 'consent.privacyTitle': return 'Strict photo privacy';
			case 'consent.privacyBody': return 'No cloud storage and no third-party access.';
			case 'consent.screeningTitle': return 'Educational use, not medical use';
			case 'consent.screeningBody': return 'Not validated for medical use and must not be used for diagnosis, treatment, or health decisions. This consent does not authorize storing or reusing photos for research or training.';
			case 'consent.termsTitle': return 'Consent Terms';
			case 'consent.termsBody': return 'To ensure safe and ethical use, confirm the following two premises before continuing:';
			case 'consent.screeningPrefix': return 'I understand this is a ';
			case 'consent.screeningHighlight': return 'experimental educational prototype';
			case 'consent.screeningSuffix': return ' and is not a medical tool or for diagnosis, treatment, or clinical decisions.';
			case 'consent.processingPrefix': return 'I authorize ';
			case 'consent.processingHighlight': return 'on-device image processing';
			case 'consent.processingSuffix': return ' to try experimental learning features when available.';
			case 'consent.cta': return 'Start assessment';
			case 'result.subtitle': return 'Result';
			case 'result.screeningLabel': return 'Experimental result';
			case 'result.bmiLabel': return 'Estimated body mass index';
			case 'result.rangeCaption': return ({required Object margin, required Object min, required Object max}) => '±${margin} · estimate range ${min} – ${max}';
			case 'result.confidenceLow': return 'Low confidence';
			case 'result.confidenceMedium': return 'Medium confidence';
			case 'result.confidenceHigh': return 'High confidence';
			case 'result.scaleTitle': return 'WHO scale';
			case 'result.indicesTitle': return 'Anthropometric indices';
			case 'result.whtr': return 'Waist-to-height (WHtR)';
			case 'result.whtrNote': return 'Ratio of waist to height';
			case 'result.whtrExperimental': return 'Estimated from the proportions in your photo';
			case 'result.whtrWarning': return 'Approximate (±10%): computed from pose landmarks, not a clinical measurement.';
			case 'result.bri': return 'Body roundness (BRI)';
			case 'result.briNote': return 'Body shape derived from circumferences';
			case 'result.rfm': return 'Relative fat mass (RFM)';
			case 'result.rfmNote': return 'Estimate based on body proportions';
			case 'result.meaningTitle': return 'What does this result mean?';
			case 'result.meaningBody': return 'Your silhouette falls in a reference band. BMI and visual projections do not distinguish lean muscle from fat tissue: it is a preventive starting point for your tracking.';
			case 'result.cta': return 'Measure again';
			case 'result.noEstimateLabel': return 'Experimental result';
			case 'result.abstainPoseTitle': return 'The pose could not be measured';
			case 'result.abstainPoseBody': return 'This photo does not allow measuring the full body. Retake it following the silhouette.';
			case 'result.abstainAlignmentTitle': return 'The photo does not follow the guide';
			case 'result.abstainAlignmentBody': return 'Your position does not match the reference silhouette. Retake it with your full body, centered and facing the camera.';
			case 'result.abstainNoModelTitle': return 'No estimate yet';
			case 'result.abstainNoModelBody': return 'The estimation model is not integrated in this version. The capture passed the technical checks, but no figures are shown so we do not invent a result.';
			case 'result.bmiComputedCaption': return 'Calculated from the weight and height you entered';
			case 'result.abstainBodyTitle': return 'Your data is missing';
			case 'result.abstainBodyBody': return 'We need your weight and height to calculate BMI. Retake the capture and enter them.';
			case 'settings.title': return 'Language and theme';
			case 'settings.language': return 'LANGUAGE';
			case 'settings.theme': return 'THEME';
			case 'settings.themeSystem': return 'System';
			case 'settings.themeLight': return 'Light';
			case 'settings.themeDark': return 'Dark';
			default: return null;
		}
	}
}
