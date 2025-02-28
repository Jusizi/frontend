import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

import '../../models/cliente_listagem_model.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../modules/sistema/pages/clientes/clientes_store.dart';

class SelecionarClienteComponent extends StatefulWidget {
  final void Function(ClienteListagemModel clienteModel) onPressedSelect;
  const SelecionarClienteComponent({
    super.key,
    required this.onPressedSelect,
  });

  @override
  _SelecionarClienteComponentState createState() =>
      _SelecionarClienteComponentState();
}

class _SelecionarClienteComponentState
    extends State<SelecionarClienteComponent> {
  late ClientesStore clientesStore;

  final TextEditingController _controller = TextEditingController();
  List<ClienteListagemModel> _getFilterClientes(String query) {
    return clientesStore.clientes.where((ClienteListagemModel cliente) {
      return cliente.nomeCompleto.toLowerCase().contains(query.toLowerCase()) ||
          cliente.documento.toLowerCase().contains(query.toLowerCase()) ||
          cliente.whatsapp.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    clientesStore = Modular.get<ClientesStore>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      clientesStore.atualizarState();
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

  Widget _buildSuccess(state) {
    if (clientesStore.clientes.isEmpty) {
      return Center(
        child: TextButton.icon(
          onPressed: () {
            Modular.to.pushNamed('/sistema/clientes/cadastrar_por_cpf');
          },
          icon: const Icon(Icons.person_add),
          label: const Text('Cadastrar o primeiro cliente'),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Cliente', style: TextStyle(fontSize: 16)),
        TypeAheadField<ClienteListagemModel>(
          suggestionsCallback: (pattern) async {
            return _getFilterClientes(pattern);
          },
          controller: _controller,
          emptyBuilder: (context) {
            return ListTile(
              title: TextButton.icon(
                onPressed: () {
                  Modular.to.pushNamed('/sistema/clientes/cadastrar_por_cpf');
                },
                icon: Icon(Icons.person_add),
                label: Text('Cadastrar novo cliente'),
              ),
            );
          },
          onSelected: (ClienteListagemModel value) {
            setState(() {
              _controller.text = value.nomeCompleto;
            });
            widget.onPressedSelect(value);
          },
          itemBuilder: (context, ClienteListagemModel planoConta) {
            return ListTile(
              title: Text(planoConta.nomeCompleto),
              subtitle: Text(planoConta.documento),
              leading: const Icon(Icons.person),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedBuilder<ClientesStore, List<ClienteListagemModel>>(
      store: clientesStore,
      onError: (context, erro) => _buildError(erro!),
      onLoading: (context) => _buildLoading(),
      onState: (context, state) => _buildSuccess(state),
    );
  }
}
