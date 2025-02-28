// ignore_for_file: unused_field
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

import '../../../designSystem/components/bar_chart.dart';
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

  @override
  void initState() {
    super.initState();

    _appStore = Modular.get<AppStore>();
    _authStore = Modular.get<AuthStore>();
    _planoDeContasStore = Modular.get<PlanoDeContasStore>();

    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildSuccess(int state) {
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
                  const Text(
                    "ATENÇÃO!",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "A versão beta 0.0.3 do sistema está em fase de testes e pode apresentar instabilidades, incluindo possíveis bugs e perda de dados.",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Atualizações poderão ocorrer a qualquer momento sem aviso prévio.",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Durante este período, estamos experimentando e tudo pode acontecer até que cheguemos à primeira versão estável, que será nosso pré-lançamento.",
                    style: TextStyle(fontSize: 16),
                  ),
                  Visibility(
                    visible:
                        (kIsWeb || MediaQuery.of(context).size.width > 800),
                    child: const Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: BarChartSample3(),
                            ),
                            Expanded(
                              child: pieSampleComponent(),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        BarChartSample4(),
                      ],
                    ),
                  ),
                  const Visibility(
                    visible: !kIsWeb,
                    child: Column(
                      children: [
                        BarChartSample3(),
                        SizedBox(height: 20),
                        pieSampleComponent(),
                        SizedBox(height: 20),
                        BarChartSample4(),
                        SizedBox(height: 20),
                      ],
                    ),
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
