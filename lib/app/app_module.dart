import 'package:flutter_modular/flutter_modular.dart';

import 'app_splash_page.dart';
import 'modules/auth/auth_module.dart';
import 'modules/auth/guards/auth_guard.dart';
import 'modules/planos/planos_module.dart';
import 'modules/sistema/sistema_module.dart';
import 'repositories/auth/auth_repository_implementation.dart';
import 'repositories/auth/auth_repository_interface.dart';
import 'repositories/minhasinformacoes/minhasinformacoes_repository.dart';
import 'repositories/minhasinformacoes/minhasinformacoes_repository_implementation.dart';
import 'shared/stores/app/app_store.dart';
import 'shared/stores/auth/auth_store.dart';

class AppModule extends Module {
  @override
  void binds(Injector i) {
    i.addSingleton<MinhasinformacoesRepository>(
        MinhasinformacoesRepositoryImplementation.new);
    i.addSingleton<AppStore>(AppStore.new);
    i.addSingleton<IAuthRepositoryInterface>(AuthRepositoryImplementation.new);
    i.addSingleton<AuthStore>(AuthStore.new);
  }

  @override
  void routes(r) {
    r.child('/', child: (context) => const AppSplashPage());
    r.module('/auth/', module: AuthModule(), guards: [
      AuthGuard(),
    ]);
    r.module('/planos/', module: PlanosModule());
    r.module(
      '/sistema/',
      module: SistemaModule(),
      transition: TransitionType.fadeIn,
    );
    //  r.module('/configuracoes', module: ConfiguracoesModule());
    //r.module('/contasbancarias', module: ContasBancariasModule());
  }
}
