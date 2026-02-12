import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'di_injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
void configureDependenciesInjection() => getIt.init();
