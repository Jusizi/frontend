import 'package:flutter_modular/flutter_modular.dart';

import '../../app_module.dart';
import 'pages/planos_page.dart';

class PlanosModule extends Module {
  @override
  List<Module> get imports => [
        AppModule(),
      ];

  @override
  void routes(r) {
    r.child('/', child: (context) => const PlanosPage());
  }
}
