import 'dart:async';

import 'package:flutter_modular/flutter_modular.dart';

class SistemaGuard extends RouteGuard {
  SistemaGuard() : super(redirectTo: '/auth/');

  @override
  FutureOr<bool> canActivate(String path, ParallelRoute route) {
    return true;
  }
}
