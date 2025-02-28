import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

import '../../models/plano_de_conta_agrupado_model.dart';
import '../../models/plano_de_conta_model.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../modules/sistema/pages/planodecontas/planodecontas_store.dart';

class SelecionarPlanoDeContasComponent extends StatefulWidget {
  final void Function(PlanoDeContaModel planoDeConta) onPressedSelect;
  const SelecionarPlanoDeContasComponent({
    super.key,
    required this.onPressedSelect,
  });

  @override
  _SelecionarPlanoDeContasComponentState createState() =>
      _SelecionarPlanoDeContasComponentState();
}

class _SelecionarPlanoDeContasComponentState
    extends State<SelecionarPlanoDeContasComponent> {
  late List<PlanoDeContaAgrupadoModel> planosAgrupados;
  late PlanoDeContasStore _planoDeContasStore;

  final TextEditingController _controller = TextEditingController();
  List<PlanoDeContaModel> _getFilteredPlanos(String query) {
    final planos =
        planosAgrupados.expand((grupo) => grupo.planosDeConta).toList();
    return planos.where((plano) {
      return plano.nome.toLowerCase().contains(query.toLowerCase()) ||
          plano.descricao.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _planoDeContasStore = Modular.get<PlanoDeContasStore>();
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
    planosAgrupados = state;

    final planos =
        planosAgrupados.expand((grupo) => grupo.planosDeConta).toList();

    if (planos.isEmpty || planos.every((plano) => plano.nome.isEmpty)) {
      return const Center(
        child: Text('Nenhum plano de conta disponível.'),
      );
    }
    if (planosAgrupados.isEmpty) {
      return const Center(child: Text('Nenhum plano de conta encontrado.'));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Plano de Conta', style: TextStyle(fontSize: 16)),
        TypeAheadField<PlanoDeContaModel>(
          suggestionsCallback: (pattern) async {
            return _getFilteredPlanos(pattern);
          },
          controller: _controller,
          onSelected: (PlanoDeContaModel value) {
            setState(() {
              _controller.text = value.nome;
            });

            widget.onPressedSelect(value);
          },
          itemBuilder: (context, PlanoDeContaModel planoConta) {
            return ListTile(
              title: Text(planoConta.nome),
              subtitle: Text(planoConta.descricao),
              leading: const Icon(Icons.account_balance_wallet),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedBuilder<PlanoDeContasStore, List<PlanoDeContaAgrupadoModel>>(
      store: _planoDeContasStore,
      onError: (context, erro) => _buildError(erro!),
      onLoading: (context) => _buildLoading(),
      onState: (context, state) => _buildSuccess(state),
    );
  }
}
