// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get homeTitle => 'Inicio';

  @override
  String get welcomeMessage => '¡Bienvenido a Mi App!';

  @override
  String count(String value) {
    return 'Contador: $value';
  }

  @override
  String get increment => 'Incrementar';
}
