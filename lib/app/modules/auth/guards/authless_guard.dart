import 'package:flutter_modular/flutter_modular.dart';

import '../../../shared/stores/auth/auth_store.dart';

class AuthLessGuard extends RouteGuard {
  AuthLessGuard() : super(redirectTo: '/auth/');

  @override
  Future<bool> canActivate(String path, ModularRoute route) async {
    final AuthStore authStore = Modular.get<AuthStore>();

    return authStore.isLoggedIn && authStore.accessToken.isNotEmpty;
  }
}
