import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../designSystem/components/card_caixa_movimentacao_component.dart';
import '../../../../../designSystem/layout/drawermenuComponent.dart';
import '../../../../../models/caixa_movimentacao_model.dart';
import '../../../../../models/conta_bancaria_model.dart';
import '../caixamovimentacoes_store.dart';

class CaixaMovimentacoesContaPage extends StatefulWidget {
  final ContaBancariaModel contaBancaria;
  const CaixaMovimentacoesContaPage({
    super.key,
    required this.contaBancaria,
  });

  @override
  State<CaixaMovimentacoesContaPage> createState() =>
      _CaixaMovimentacoesContaPageState();
}

class _CaixaMovimentacoesContaPageState
    extends State<CaixaMovimentacoesContaPage> {
  late final CaixamovimentacoesStore caixamovimentacoesStore;

  @override
  void initState() {
    super.initState();
    caixamovimentacoesStore = Modular.get<CaixamovimentacoesStore>();

    if (caixamovimentacoesStore.state.isEmpty) {
      caixamovimentacoesStore
          .getMovimentacoesDaContaBancaria(widget.contaBancaria.id);
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
    if (state.isEmpty) {
      return const Center(
          child: Text('Nenhuma movimentação na conta foi encontrada.'));
    }
    return ListView.builder(
      itemCount: state.length,
      itemBuilder: (context, indexContexto) {
        CaixaMovimentacaoModel caixaMovimentacaoModel = state[indexContexto];

        return CardCaixaMovimentacaoComponent(
          caixaMovimentacaoModel: caixaMovimentacaoModel,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: GlobalKey(),
      appBar: AppBar(
        title: Text(
            'Movimentações da conta bancária ${widget.contaBancaria.nome}'),
        actions: [
          IconButton(
            tooltip: 'Atualizar as Contas Bancárias',
            onPressed: () => caixamovimentacoesStore
                .getMovimentacoesDaContaBancaria(widget.contaBancaria.id),
            icon: const Icon(Icons.sync),
          ),
        ],
      ),
      drawer: drawerORleading(),
      body: RefreshIndicator(
        onRefresh: () => caixamovimentacoesStore
            .getMovimentacoesDaContaBancaria(widget.contaBancaria.id),
        child: ScopedBuilder<CaixamovimentacoesStore,
            List<CaixaMovimentacaoModel>>(
          store: caixamovimentacoesStore,
          onError: (context, erro) => _buildError(erro!),
          onLoading: (context) => _buildLoading(),
          onState: (context, state) => _buildSuccess(state),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => Modular.to.pushNamed(
                '/sistema/caixamovimentacoes/nova',
                arguments: widget.contaBancaria,
              ),
          tooltip: 'Nova Movimentação',
          child: const FaIcon(FontAwesomeIcons.plusMinus)),
    );
  }
}
