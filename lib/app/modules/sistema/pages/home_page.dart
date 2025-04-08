// ignore_for_file: unused_field
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

import '../../../designSystem/components/graficos/column_rounded_corner.dart';
import '../../../designSystem/components/graficos/line_default.dart';
import '../../../designSystem/components/graficos/pie_gradient.dart';
import '../../../designSystem/components/graficos/pie_tooltip.dart';
import '../../../designSystem/components/pie_sample_component.dart';
import '../../../designSystem/layout/body_component.dart';
import '../../../designSystem/layout/drawermenuComponent.dart';
import '../../../shared/stores/app/app_store.dart';
import '../../../shared/stores/auth/auth_store.dart';
import 'planodecontas/planodecontas_store.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final AppStore _appStore;
  late final AuthStore _authStore;
  late final PlanoDeContasStore _planoDeContasStore;

  bool carregarCardsGraficos = false;

  @override
  void initState() {
    super.initState();

    _appStore = Modular.get<AppStore>();
    _authStore = Modular.get<AuthStore>();
    _planoDeContasStore = Modular.get<PlanoDeContasStore>();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildSuccess(int state) {
    if (_authStore.user.name.isNotEmpty) {
      carregarCardsGraficos = true;
    }

    return Scaffold(
      key: GlobalKey(),
      appBar: AppBar(
        title: Text('Bem-vindo, ${_authStore.user.name}'),
        actions: const [],
      ),
      drawer: DrawerMenuComponent(),
      body: Bodycomponent(
        bodyWidget: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                      "O aplicativo está em desenvolvimento e não está pronto para uso. Os gráficos e cards estão apenas para fins de teste."),
                  const SizedBox(height: 20),
                  Wrap(
                    children: [
                      Visibility(
                        visible: carregarCardsGraficos,
                        replacement: const Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                        child: Card(
                          child: Container(
                            margin: const EdgeInsets.only(top: 10),
                            height: 350,
                            width: 350,
                            child: ColumnRoundedCorner(),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: carregarCardsGraficos,
                        replacement: const Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                        child: Card(
                          child: SizedBox(
                            height: 360,
                            width: 500,
                            child: PieTooltip(),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: carregarCardsGraficos,
                        replacement: const Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                        child: Card(
                          child: Container(
                            margin: const EdgeInsets.only(top: 10),
                            height: 350,
                            width: 500,
                            child: PieGradient(),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: carregarCardsGraficos,
                        replacement: const Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                        child: Card(
                          child: Container(
                            margin: const EdgeInsets.only(top: 10),
                            height: 350,
                            width: 350,
                            child: pieSampleComponent(),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: carregarCardsGraficos,
                        replacement: const Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                        child: Card(
                          child: SizedBox(
                            height: 350,
                            width: 600,
                            child: LineDefault(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedBuilder<AuthStore, int>(
      store: _authStore,
      onError: (context, erro) => _buildError(erro!),
      onLoading: (context) => _buildLoading(),
      onState: (context, state) => _buildSuccess(state),
    );
  }

  Widget _buildError(String erro) {
    return Scaffold(
      key: GlobalKey(),
      appBar: AppBar(
        title: Text('Bem-vindo, ${_authStore.user.name}'),
        actions: const [],
      ),
      drawer: DrawerMenuComponent(),
      body: const Bodycomponent(
        bodyWidget: Center(
          child: Text('Erro ao carregar informações do usuário'),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Scaffold(
      key: GlobalKey(),
      appBar: AppBar(
        title: Text('Bem-vindo, ${_authStore.user.name}'),
        actions: const [],
      ),
      drawer: DrawerMenuComponent(),
      body: const Bodycomponent(
        bodyWidget: Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      ),
    );
  }
}
