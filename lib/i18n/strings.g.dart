/// Generated file. Do not edit.
///
/// Original: lib/i18n
/// To regenerate, run: `dart run slang`
///
/// Locales: 2
/// Strings: 171 (85 per locale)
///
/// Built on 2026-11-01 at 19:29 UTC

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
	String get posture => 'Postura';
	String get postureOk => 'Alineada y nivelada';
	String get tilt => 'Inclinación';
	String get tiltOk => '0.2° · Óptima';
	String get sensor => 'Sensor';
	String get sensorOk => 'Listo';
	String get distance => 'Distancia detectada';
	String get distanceValue => '2.1 m';
	String get criteria => 'Criterios de escaneo';
	String get approved => '3 / 4 aprobados';
	String get fullBody => 'Cuerpo completo';
	String get twoMeters => 'A 2 metros';
	String get plainBackground => 'Fondo liso y uniforme';
	String get looseClothing => 'Evitar ropa holgada';
	String get sideView => 'Incluir vista lateral';
	String get sideViewHint => 'Recomendado para mayor precisión corporal';
	String get gallery => 'Galería';
	String get timer => '3 seg';
	String get shutter => 'Capturar';
	String get shutterPending => 'La captura se habilita cuando el modelo de visión esté integrado.';
	String get localNote => 'Las fotos se procesan y permanecen exclusivamente en este teléfono.';
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
	String get screening => 'Estimación de tamizaje. No es un diagnóstico. Consulte a un profesional de la salud para una evaluación.';
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
	String get heroTitle => 'Conoce tu rango, no un número';
	String get heroBody => 'Estimación de composición corporal y banda de IMC procesada 100% de manera local y privada en tu dispositivo.';
	String get deviceTitle => '100% en tu dispositivo';
	String get deviceBody => 'Las fotos nunca se suben ni salen de tu teléfono. El cálculo se ejecuta en tu dispositivo.';
	String get privacyTitle => 'Privacidad fotográfica estricta';
	String get privacyBody => 'Sin almacenamiento en la nube ni acceso a terceros.';
	String get screeningTitle => 'Herramienta de cribado preventivo';
	String get screeningBody => 'Orientación formativa de bienestar y hábitos saludables, no un diagnóstico clínico vinculante.';
	String get termsTitle => 'Términos de Consentimiento';
	String get required => 'Requerido';
	String get termsBody => 'Para garantizar un uso seguro y ético, confirma las siguientes dos premisas antes de continuar:';
	String get screeningPrefix => 'Entiendo que es una ';
	String get screeningHighlight => 'herramienta de cribado preliminar';
	String get screeningSuffix => ' y no constituye un diagnóstico médico clínico.';
	String get processingPrefix => 'Autorizo el ';
	String get processingHighlight => 'procesamiento visual biométrico';
	String get processingSuffix => ' en mi dispositivo para calcular mis bandas de IMC.';
	String get cta => 'Comenzar evaluación';
}

// Path: result
class _StringsResultEs {
	_StringsResultEs._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get subtitle => 'Resultado';
	String get screeningLabel => 'Resultado de cribado';
	String get bmiLabel => 'Índice de masa corporal estimado';
	String rangeCaption({required Object margin, required Object min, required Object max}) => '±${margin} · rango de estimación ${min} – ${max}';
	String get confidenceLow => 'Confianza baja';
	String get confidenceMedium => 'Confianza media';
	String get confidenceHigh => 'Confianza alta';
	String get scaleTitle => 'Escala OMS';
	String get indicesTitle => 'Índices antropométricos';
	String get whtr => 'Cintura-altura (WHtR)';
	String get whtrNote => 'Proporción entre cintura y estatura';
	String get bri => 'Redondez corporal (BRI)';
	String get briNote => 'Forma del cuerpo derivada de perímetros';
	String get rfm => 'Masa grasa relativa (RFM)';
	String get rfmNote => 'Estimación basada en proporciones corporales';
	String get meaningTitle => '¿Qué significa este resultado?';
	String get meaningBody => 'Tu silueta se sitúa en una banda de referencia. El IMC y las proyecciones visuales no distinguen masa muscular magra de tejido adiposo: es un punto de partida preventivo para tu seguimiento.';
	String get cta => 'Volver a medir';
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
	@override String get posture => 'Posture';
	@override String get postureOk => 'Aligned and level';
	@override String get tilt => 'Tilt';
	@override String get tiltOk => '0.2° · Optimal';
	@override String get sensor => 'Sensor';
	@override String get sensorOk => 'Ready';
	@override String get distance => 'Detected distance';
	@override String get distanceValue => '2.1 m';
	@override String get criteria => 'Scan criteria';
	@override String get approved => '3 / 4 passed';
	@override String get fullBody => 'Full body';
	@override String get twoMeters => 'At 2 meters';
	@override String get plainBackground => 'Plain, even background';
	@override String get looseClothing => 'Avoid loose clothing';
	@override String get sideView => 'Add a side view';
	@override String get sideViewHint => 'Recommended for better body accuracy';
	@override String get gallery => 'Gallery';
	@override String get timer => '3 sec';
	@override String get shutter => 'Capture';
	@override String get shutterPending => 'Capture unlocks once the vision model is integrated.';
	@override String get localNote => 'Photos are processed and stay exclusively on this phone.';
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
	@override String get screening => 'Screening estimate. Not a diagnosis. Consult a healthcare professional for evaluation.';
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
	@override String get heroTitle => 'Know your range, not a number';
	@override String get heroBody => 'Body composition estimate and BMI band processed 100% locally and privately on your device.';
	@override String get deviceTitle => '100% on your device';
	@override String get deviceBody => 'Photos are never uploaded or leave your phone. The calculation runs on your device.';
	@override String get privacyTitle => 'Strict photo privacy';
	@override String get privacyBody => 'No cloud storage and no third-party access.';
	@override String get screeningTitle => 'Preventive screening tool';
	@override String get screeningBody => 'Educational guidance on wellness and healthy habits, not a binding clinical diagnosis.';
	@override String get termsTitle => 'Consent Terms';
	@override String get termsBody => 'To ensure safe and ethical use, confirm the following two premises before continuing:';
	@override String get screeningPrefix => 'I understand this is a ';
	@override String get screeningHighlight => 'preliminary screening tool';
	@override String get screeningSuffix => ' and does not constitute a clinical medical diagnosis.';
	@override String get processingPrefix => 'I authorize ';
	@override String get processingHighlight => 'biometric visual processing';
	@override String get processingSuffix => ' on my device to calculate my BMI bands.';
	@override String get cta => 'Start assessment';
}

// Path: result
class _StringsResultEn extends _StringsResultEs {
	_StringsResultEn._(_StringsEn root) : this._root = root, super._(root);

	@override final _StringsEn _root; // ignore: unused_field

	// Translations
	@override String get subtitle => 'Result';
	@override String get screeningLabel => 'Screening result';
	@override String get bmiLabel => 'Estimated body mass index';
	@override String rangeCaption({required Object margin, required Object min, required Object max}) => '±${margin} · estimate range ${min} – ${max}';
	@override String get confidenceLow => 'Low confidence';
	@override String get confidenceMedium => 'Medium confidence';
	@override String get confidenceHigh => 'High confidence';
	@override String get scaleTitle => 'WHO scale';
	@override String get indicesTitle => 'Anthropometric indices';
	@override String get whtr => 'Waist-to-height (WHtR)';
	@override String get whtrNote => 'Ratio of waist to height';
	@override String get bri => 'Body roundness (BRI)';
	@override String get briNote => 'Body shape derived from circumferences';
	@override String get rfm => 'Relative fat mass (RFM)';
	@override String get rfmNote => 'Estimate based on body proportions';
	@override String get meaningTitle => 'What does this result mean?';
	@override String get meaningBody => 'Your silhouette falls in a reference band. BMI and visual projections do not distinguish lean muscle from fat tissue: it is a preventive starting point for your tracking.';
	@override String get cta => 'Measure again';
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
			case 'capture.posture': return 'Postura';
			case 'capture.postureOk': return 'Alineada y nivelada';
			case 'capture.tilt': return 'Inclinación';
			case 'capture.tiltOk': return '0.2° · Óptima';
			case 'capture.sensor': return 'Sensor';
			case 'capture.sensorOk': return 'Listo';
			case 'capture.distance': return 'Distancia detectada';
			case 'capture.distanceValue': return '2.1 m';
			case 'capture.criteria': return 'Criterios de escaneo';
			case 'capture.approved': return '3 / 4 aprobados';
			case 'capture.fullBody': return 'Cuerpo completo';
			case 'capture.twoMeters': return 'A 2 metros';
			case 'capture.plainBackground': return 'Fondo liso y uniforme';
			case 'capture.looseClothing': return 'Evitar ropa holgada';
			case 'capture.sideView': return 'Incluir vista lateral';
			case 'capture.sideViewHint': return 'Recomendado para mayor precisión corporal';
			case 'capture.gallery': return 'Galería';
			case 'capture.timer': return '3 seg';
			case 'capture.shutter': return 'Capturar';
			case 'capture.shutterPending': return 'La captura se habilita cuando el modelo de visión esté integrado.';
			case 'capture.localNote': return 'Las fotos se procesan y permanecen exclusivamente en este teléfono.';
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
			case 'disclaimer.screening': return 'Estimación de tamizaje. No es un diagnóstico. Consulte a un profesional de la salud para una evaluación.';
			case 'onDevice.pill': return '100% On-Device';
			case 'consent.subtitle': return 'Inicio';
			case 'consent.heroTitle': return 'Conoce tu rango, no un número';
			case 'consent.heroBody': return 'Estimación de composición corporal y banda de IMC procesada 100% de manera local y privada en tu dispositivo.';
			case 'consent.deviceTitle': return '100% en tu dispositivo';
			case 'consent.deviceBody': return 'Las fotos nunca se suben ni salen de tu teléfono. El cálculo se ejecuta en tu dispositivo.';
			case 'consent.privacyTitle': return 'Privacidad fotográfica estricta';
			case 'consent.privacyBody': return 'Sin almacenamiento en la nube ni acceso a terceros.';
			case 'consent.screeningTitle': return 'Herramienta de cribado preventivo';
			case 'consent.screeningBody': return 'Orientación formativa de bienestar y hábitos saludables, no un diagnóstico clínico vinculante.';
			case 'consent.termsTitle': return 'Términos de Consentimiento';
			case 'consent.required': return 'Requerido';
			case 'consent.termsBody': return 'Para garantizar un uso seguro y ético, confirma las siguientes dos premisas antes de continuar:';
			case 'consent.screeningPrefix': return 'Entiendo que es una ';
			case 'consent.screeningHighlight': return 'herramienta de cribado preliminar';
			case 'consent.screeningSuffix': return ' y no constituye un diagnóstico médico clínico.';
			case 'consent.processingPrefix': return 'Autorizo el ';
			case 'consent.processingHighlight': return 'procesamiento visual biométrico';
			case 'consent.processingSuffix': return ' en mi dispositivo para calcular mis bandas de IMC.';
			case 'consent.cta': return 'Comenzar evaluación';
			case 'result.subtitle': return 'Resultado';
			case 'result.screeningLabel': return 'Resultado de cribado';
			case 'result.bmiLabel': return 'Índice de masa corporal estimado';
			case 'result.rangeCaption': return ({required Object margin, required Object min, required Object max}) => '±${margin} · rango de estimación ${min} – ${max}';
			case 'result.confidenceLow': return 'Confianza baja';
			case 'result.confidenceMedium': return 'Confianza media';
			case 'result.confidenceHigh': return 'Confianza alta';
			case 'result.scaleTitle': return 'Escala OMS';
			case 'result.indicesTitle': return 'Índices antropométricos';
			case 'result.whtr': return 'Cintura-altura (WHtR)';
			case 'result.whtrNote': return 'Proporción entre cintura y estatura';
			case 'result.bri': return 'Redondez corporal (BRI)';
			case 'result.briNote': return 'Forma del cuerpo derivada de perímetros';
			case 'result.rfm': return 'Masa grasa relativa (RFM)';
			case 'result.rfmNote': return 'Estimación basada en proporciones corporales';
			case 'result.meaningTitle': return '¿Qué significa este resultado?';
			case 'result.meaningBody': return 'Tu silueta se sitúa en una banda de referencia. El IMC y las proyecciones visuales no distinguen masa muscular magra de tejido adiposo: es un punto de partida preventivo para tu seguimiento.';
			case 'result.cta': return 'Volver a medir';
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
			case 'capture.posture': return 'Posture';
			case 'capture.postureOk': return 'Aligned and level';
			case 'capture.tilt': return 'Tilt';
			case 'capture.tiltOk': return '0.2° · Optimal';
			case 'capture.sensor': return 'Sensor';
			case 'capture.sensorOk': return 'Ready';
			case 'capture.distance': return 'Detected distance';
			case 'capture.distanceValue': return '2.1 m';
			case 'capture.criteria': return 'Scan criteria';
			case 'capture.approved': return '3 / 4 passed';
			case 'capture.fullBody': return 'Full body';
			case 'capture.twoMeters': return 'At 2 meters';
			case 'capture.plainBackground': return 'Plain, even background';
			case 'capture.looseClothing': return 'Avoid loose clothing';
			case 'capture.sideView': return 'Add a side view';
			case 'capture.sideViewHint': return 'Recommended for better body accuracy';
			case 'capture.gallery': return 'Gallery';
			case 'capture.timer': return '3 sec';
			case 'capture.shutter': return 'Capture';
			case 'capture.shutterPending': return 'Capture unlocks once the vision model is integrated.';
			case 'capture.localNote': return 'Photos are processed and stay exclusively on this phone.';
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
			case 'disclaimer.screening': return 'Screening estimate. Not a diagnosis. Consult a healthcare professional for evaluation.';
			case 'onDevice.pill': return '100% On-Device';
			case 'consent.subtitle': return 'Home';
			case 'consent.heroTitle': return 'Know your range, not a number';
			case 'consent.heroBody': return 'Body composition estimate and BMI band processed 100% locally and privately on your device.';
			case 'consent.deviceTitle': return '100% on your device';
			case 'consent.deviceBody': return 'Photos are never uploaded or leave your phone. The calculation runs on your device.';
			case 'consent.privacyTitle': return 'Strict photo privacy';
			case 'consent.privacyBody': return 'No cloud storage and no third-party access.';
			case 'consent.screeningTitle': return 'Preventive screening tool';
			case 'consent.screeningBody': return 'Educational guidance on wellness and healthy habits, not a binding clinical diagnosis.';
			case 'consent.termsTitle': return 'Consent Terms';
			case 'consent.termsBody': return 'To ensure safe and ethical use, confirm the following two premises before continuing:';
			case 'consent.screeningPrefix': return 'I understand this is a ';
			case 'consent.screeningHighlight': return 'preliminary screening tool';
			case 'consent.screeningSuffix': return ' and does not constitute a clinical medical diagnosis.';
			case 'consent.processingPrefix': return 'I authorize ';
			case 'consent.processingHighlight': return 'biometric visual processing';
			case 'consent.processingSuffix': return ' on my device to calculate my BMI bands.';
			case 'consent.cta': return 'Start assessment';
			case 'result.subtitle': return 'Result';
			case 'result.screeningLabel': return 'Screening result';
			case 'result.bmiLabel': return 'Estimated body mass index';
			case 'result.rangeCaption': return ({required Object margin, required Object min, required Object max}) => '±${margin} · estimate range ${min} – ${max}';
			case 'result.confidenceLow': return 'Low confidence';
			case 'result.confidenceMedium': return 'Medium confidence';
			case 'result.confidenceHigh': return 'High confidence';
			case 'result.scaleTitle': return 'WHO scale';
			case 'result.indicesTitle': return 'Anthropometric indices';
			case 'result.whtr': return 'Waist-to-height (WHtR)';
			case 'result.whtrNote': return 'Ratio of waist to height';
			case 'result.bri': return 'Body roundness (BRI)';
			case 'result.briNote': return 'Body shape derived from circumferences';
			case 'result.rfm': return 'Relative fat mass (RFM)';
			case 'result.rfmNote': return 'Estimate based on body proportions';
			case 'result.meaningTitle': return 'What does this result mean?';
			case 'result.meaningBody': return 'Your silhouette falls in a reference band. BMI and visual projections do not distinguish lean muscle from fat tissue: it is a preventive starting point for your tracking.';
			case 'result.cta': return 'Measure again';
			default: return null;
		}
	}
}
