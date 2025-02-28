import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

import '../../../../../designSystem/layout/layout_component.dart';
import '../../../../../designSystem/switch_component.dart';
import '../../../../../shared/stores/app/app_store.dart';

class ConfiguracoesPage extends StatefulWidget {
  const ConfiguracoesPage({super.key});

  @override
  State<ConfiguracoesPage> createState() => _ConfiguracoesPageState();
}

class _ConfiguracoesPageState extends State<ConfiguracoesPage> {
  late final AppStore _appStore;

  @override
  void initState() {
    super.initState();

    _appStore = Modular.get<AppStore>();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutComponent(
      title: 'Configurações',
      body: Center(
        child: Column(
          children: [
            const Text('Configurações - Page'),
            ElevatedButton(
              onPressed: () {
                _appStore.toggleFullScreen();
              },
              child: const Text('Clique aqui - FullScreen'),
            ),
            const Text('Tela cheia'),
            ScopedBuilder<AppStore, int>(
              store: _appStore,
              onError: (context, erro) => Center(
                child: Text(erro.toString()),
              ),
              onLoading: (context) => const CircularProgressIndicator(),
              onState: (context, state) {
                return SwitchComponent(
                  value: _appStore.fullScreen,
                  onChanged: _appStore.toggleFullScreen,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
