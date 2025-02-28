import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../models/conta_bancaria_model.dart';
import '../../modules/sistema/pages/contasbancarias/contasbancarias_store.dart';

class SelecionarContaBancariaComponent extends StatefulWidget {
  final void Function(ContaBancariaModel contaBancaria) onPressedSelect;
  const SelecionarContaBancariaComponent({
    super.key,
    required this.onPressedSelect,
  });

  @override
  _SelecionarContaBancariaComponentState createState() =>
      _SelecionarContaBancariaComponentState();
}

class _SelecionarContaBancariaComponentState
    extends State<SelecionarContaBancariaComponent> {
  late ContasBancariasStore contasBancariasStore;

  final TextEditingController _controller = TextEditingController();
  List<ContaBancariaModel> _getFilter(String query) {
    return contasBancariasStore.contasbancarias
        .where((ContaBancariaModel contaBancaria) {
      return contaBancaria.banco.toLowerCase().contains(query.toLowerCase()) ||
          contaBancaria.nome.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    contasBancariasStore = Modular.get<ContasBancariasStore>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _onSelected(contasBancariasStore.contasbancarias.first);
    });
  }

  Widget _buildError(Exception state) {
    return Center(
      child: Text(state.toString()),
    );
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator.adaptive());
  }

  void _onSelected(ContaBancariaModel contaBancaria) {
    setState(() {
      _controller.text = contaBancaria.nome;
    });
    widget.onPressedSelect(contaBancaria);
  }

  Widget _buildSuccess(state) {
    if (contasBancariasStore.contasbancarias.isEmpty) {
      return const Center(child: Text('Nenhuma conta bancaria disponível.'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Conta Bancária', style: TextStyle(fontSize: 16)),
        TypeAheadField<ContaBancariaModel>(
          suggestionsCallback: (pattern) async {
            return _getFilter(pattern);
          },
          controller: _controller,
          onSelected: _onSelected,
          itemBuilder: (context, ContaBancariaModel planoConta) {
            return ListTile(
              title: Text(planoConta.nome),
              subtitle: Text(planoConta.banco),
              leading: const Icon(Icons.money),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedBuilder<ContasBancariasStore, int>(
      store: contasBancariasStore,
      onError: (context, erro) => _buildError(erro!),
      onLoading: (context) => _buildLoading(),
      onState: (context, state) => _buildSuccess(state),
    );
  }
}
