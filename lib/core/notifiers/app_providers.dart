import 'package:pokhara_app/core/notifiers/providers/app_flavour.dart';
import 'package:pokhara_app/core/notifiers/providers/auth_state.dart';
import 'package:pokhara_app/core/notifiers/providers/language_state.dart';
import 'package:pokhara_app/core/notifiers/providers/taxi_state.dart';
import 'package:pokhara_app/core/services/map_service.dart';
import 'package:provider/single_child_widget.dart';
import 'package:provider/provider.dart';

List<SingleChildWidget> getproviders() {
  return [
    ChangeNotifierProvider(
      lazy: false,
      create: (context) => AuthState(),
    ),
    ChangeNotifierProvider(
      lazy: true,
      create: (context) => TaxiState(),
    ),
    ChangeNotifierProvider(
      lazy: true,
      create: (context) => AppFlavour(),
    ),
    ChangeNotifierProvider(
      lazy: false,
      create: (context) => LanguageState(),
    ),
    ChangeNotifierProvider(
      lazy: false,
      create: (context) => MapState(),
    )
  ];
}
