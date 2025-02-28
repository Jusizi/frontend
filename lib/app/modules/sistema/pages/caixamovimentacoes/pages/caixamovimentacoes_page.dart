import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

import '../../../../../designSystem/components/card_conta_bancaria_component.dart';
import '../../../../../designSystem/layout/drawermenuComponent.dart';
import '../../../../../models/conta_bancaria_model.dart';
import '../../contasbancarias/contasbancarias_store.dart';

class CaixaMovimentacoesPage extends StatefulWidget {
  const CaixaMovimentacoesPage({super.key});

  @override
  State<CaixaMovimentacoesPage> createState() => _CaixaMovimentacoesPageState();
}

class _CaixaMovimentacoesPageState extends State<CaixaMovimentacoesPage> {
  late final ContasBancariasStore contasBancariasStore;

  @override
  void initState() {
    super.initState();

    contasBancariasStore = Modular.get<ContasBancariasStore>();
    if (contasBancariasStore.contasbancarias.isEmpty) {
      contasBancariasStore.getContasBancarias();
    }
  }

  Widget _buildError(Exception state) {
    return Center(
      child: Text(state.toString()),
    );
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator.adaptive());
  }

  Widget _buildSuccess(state) {
    if (contasBancariasStore.contasbancarias.isEmpty) {
      return const Center(
          child: Text('Nenhuma conta bancaria foi encontrada.'));
    }
    if (contasBancariasStore.contasbancarias.length == 1) {
      Modular.to.pushReplacementNamed('/sistema/caixamovimentacoes/conta',
          arguments: contasBancariasStore.contasbancarias[0]);
    }
    return ListView.builder(
      itemCount: contasBancariasStore.contasbancarias.length,
      itemBuilder: (context, indexContexto) {
        ContaBancariaModel contabancaria =
            contasBancariasStore.contasbancarias[indexContexto];

        return CardContaBancariaComponent(
          contaBancaria: contabancaria,
          onTap: () => Modular.to.pushNamed(
            '/sistema/caixamovimentacoes/conta',
            arguments: contabancaria,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: GlobalKey(),
      appBar: AppBar(
        title: const Text('Contas Bancárias'),
        actions: [
          IconButton(
            tooltip: 'Atualizar as Contas Bancárias',
            onPressed: contasBancariasStore.getContasBancarias,
            icon: const Icon(Icons.sync),
          ),
        ],
      ),
      drawer: drawerORleading(),
      body: RefreshIndicator(
        onRefresh: contasBancariasStore.getContasBancarias,
        child: ScopedBuilder<ContasBancariasStore, int>(
          store: contasBancariasStore,
          onError: (context, erro) => _buildError(erro!),
          onLoading: (context) => _buildLoading(),
          onState: (context, state) => _buildSuccess(state),
        ),
      ),
    );
  }
}
