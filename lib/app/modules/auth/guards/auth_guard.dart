import 'package:flutter_modular/flutter_modular.dart';

import '../../../shared/stores/auth/auth_store.dart';

class AuthGuard extends RouteGuard {
  AuthGuard() : super(redirectTo: '/sistema/');

  @override
  Future<bool> canActivate(String path, ModularRoute route) async {
    final AuthStore authStore = Modular.get<AuthStore>();

    return !authStore.isLoggedIn && authStore.accessToken.isEmpty;
  }
}
