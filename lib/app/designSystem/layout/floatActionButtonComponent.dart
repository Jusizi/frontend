// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

import '../../shared/stores/app/app_store.dart';
import '../snackbar_component.dart';

class FloatActionButtonComponent extends StatefulWidget {
  const FloatActionButtonComponent({super.key});

  @override
  State<FloatActionButtonComponent> createState() =>
      _FloatActionButtonComponentState();
}

class _FloatActionButtonComponentState
    extends State<FloatActionButtonComponent> {
  late final _appStore = Modular.get<AppStore>();

  Widget _buildError(Exception erro) {
    return Center(
      child: Text(erro.toString()),
    );
  }

  Widget _buildSuccess() {
    return FloatingActionButton(
      onPressed: () {
        _appStore.toggleBrightness();
        SnackBarComponent().showSuccess('Tema alterado com sucesso!');
      },
      child: Icon(_appStore.brightness == Brightness.light
          ? Icons.dark_mode
          : Icons.light_mode),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedBuilder<AppStore, int>(
      store: _appStore,
      onError: (context, erro) => _buildError(erro!),
      onLoading: (context) => const CircularProgressIndicator(),
      onState: (context, index) => _buildSuccess(),
    );
  }
}
