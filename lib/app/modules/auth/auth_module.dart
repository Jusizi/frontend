import 'package:flutter_modular/flutter_modular.dart';
import '../../app_module.dart';
import 'pages/create_page.dart';
import 'pages/email_verificado_page.dart';
import 'pages/login_page.dart';
import 'pages/sair_page.dart';
import 'pages/termos_de_uso_page.dart';

class AuthModule extends Module {
  @override
  List<Module> get imports => [
        AppModule(),
      ];

  @override
  void routes(r) {
    r.child('/', child: (context) => const LoginPage());
    r.child('/emailverificado',
        child: (context) => const EmailVerificadoPage());
    r.child('/sair', child: (context) => const SairPage());
    r.child('/create', child: (context) => const CreatePage());
    r.child('/termos', child: (context) => const TermosDeUsoPage());
  }
}
