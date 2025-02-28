import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_triple/flutter_triple.dart';

import '../../../models/route_data.dart';
import '../../../models/sistema_drawer_routes.dart';

class AppStore extends Store<int> {
  // Mantenha uma referência estática para a única instância da classe.
  // Construtor privado para evitar a criação de instâncias fora da classe.
  AppStore() : super(0);
  final SistemaDrawerRoutes routeSistema = SistemaDrawerRoutes();
  int _selectedRouteSistema = 0;

  Brightness brightness = Brightness.light;
  bool fullScreen = false;

  RouteData get viewAtualSistema => routeSistema.props[_selectedRouteSistema];

  int get selectedRouteSistema => _selectedRouteSistema;

  set selectedRouteSistema(int value) {
    _selectedRouteSistema = value;
    update(Random().nextInt(1000));
  }

  void setTitleRoute(String title) {
    routeSistema.props[_selectedRouteSistema].title = title;
    update(Random().nextInt(1000));
  }

  void toggleFullScreen() {
    setLoading(true);
    fullScreen = !fullScreen;
    // Foi necessário colocar essa linha para que o ScopedBuilder reconheça a mudança de estado
    update(Random().nextInt(1000));
    setLoading(false);
  }

  void toggleBrightness() {
    setLoading(true);
    brightness =
        brightness == Brightness.light ? Brightness.dark : Brightness.light;

    // Foi necessário colocar essa linha para que o ScopedBuilder reconheça a mudança de estado
    update(Random().nextInt(1000));

    setLoading(false);
  }
}
