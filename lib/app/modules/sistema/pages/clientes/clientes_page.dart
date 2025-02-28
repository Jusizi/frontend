// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:searchable_listview/searchable_listview.dart';

import '../../../../designSystem/components/card_cliente_component.dart';
import '../../../../designSystem/layout/drawermenuComponent.dart';
import '../../../../models/cliente_listagem_model.dart';
import '../../../../shared/stores/auth/auth_store.dart';
import 'clientes_store.dart';

class ClientesPage extends StatefulWidget {
  const ClientesPage({super.key});

  @override
  State<ClientesPage> createState() => _ClientesPageState();
}

class _ClientesPageState extends State<ClientesPage> {
  late final ClientesStore clientesStore;
  late AuthStore _authStore;

  @override
  void initState() {
    super.initState();

    _authStore = Modular.get<AuthStore>();

    clientesStore = Modular.get<ClientesStore>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      clientesStore.getClientesListagem();
    });
  }

  Widget _buildError(Exception state) {
    return Center(
      child: Text(state.toString()),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator.adaptive(),
    );
  }

  Widget _buildSuccess(List<ClienteListagemModel> clientesListagem) {
    if (clientesListagem.isEmpty) {
      return const Center(
        child: Text('Nenhum cliente foi encontrado.'),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(10),
      child: SearchableList<ClienteListagemModel>(
        sortWidget: const Icon(Icons.sort),
        sortPredicate: (a, b) => a.nomeCompleto.compareTo(b.nomeCompleto),
        itemBuilder: (ClienteListagemModel cliente) {
          return CardClienteComponent(cliente: cliente);
        },
        initialList: clientesListagem,
        filter: (p0) {
          return clientesListagem
              .where((element) => (element.nomeCompleto
                      .toLowerCase()
                      .contains(p0.toLowerCase()) ||
                  element.documento.toLowerCase().contains(p0.toLowerCase())))
              .toList();
        },
        inputDecoration: InputDecoration(
          labelText: "Pesquisar cliente",
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        closeKeyboardWhenScrolling: true,
      ),
    );
    /*
    return ListView.builder(
      itemCount: state.length,
      itemBuilder: (context, indexContexto) {
        ClienteListagemModel cliente = state[indexContexto];

        return CardClienteComponent(cliente: cliente);
      },
    );
    */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: GlobalKey(),
      appBar: AppBar(
        title: const Text('Todos os clientes'),
        actions: [
          IconButton(
            tooltip: 'Atualizar clientes',
            onPressed: clientesStore.getClientesListagem,
            icon: const Icon(Icons.sync_outlined),
          ),
        ],
      ),
      drawer: DrawerMenuComponent(),
      body: RefreshIndicator(
        onRefresh: clientesStore.getClientesListagem,
        child: ScopedBuilder<ClientesStore, List<ClienteListagemModel>>(
          store: clientesStore,
          onError: (context, erro) => _buildError(erro!),
          onLoading: (context) => _buildLoading(),
          onState: (context, List<ClienteListagemModel> state) =>
              _buildSuccess(state),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Modular.to.pushNamed('/sistema/clientes/cadastrar_por_cpf');
        },
        child: const Icon(Icons.person_add_outlined),
      ),
    );
  }
}
