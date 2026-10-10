import 'package:flutter_modular/flutter_modular.dart';
import 'modules/deputados/deputados_module.dart';

class AppModule extends Module {
  @override
  void binds(Injector i) {}

  @override
  void routes(RouteManager r) {
    r.module('/', module: DeputadosModule());
  }
}
