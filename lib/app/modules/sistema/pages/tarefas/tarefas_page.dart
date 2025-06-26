// ignore_for_file: unused_field

import 'package:appjusizi/app/designSystem/components/card_tarefa_component.dart';
import 'package:appjusizi/app/models/tarefa_listagem_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:searchable_listview/searchable_listview.dart';

import '../../../../designSystem/layout/drawermenuComponent.dart';
import '../../../../shared/stores/auth/auth_store.dart';
import 'tarefas_store.dart';

class TarefasPage extends StatefulWidget {
  const TarefasPage({super.key});

  @override
  State<TarefasPage> createState() => _TarefasPageState();
}

class _TarefasPageState extends State<TarefasPage> {
  late final TarefasStore tarefasStore;
  late AuthStore _authStore;

  @override
  void initState() {
    super.initState();

    _authStore = Modular.get<AuthStore>();

    tarefasStore = Modular.get<TarefasStore>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      tarefasStore.getTarefas();
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

  Widget _buildSuccess(List<TarefaListagemModel> tarefasListagem) {
    if (tarefasListagem.isEmpty) {
      return const Center(
        child: Text('Nenhuma tarefa foi encontrada.'),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(10),
      child: SearchableList<TarefaListagemModel>(
        sortWidget: const Icon(Icons.sort),
        sortPredicate: (a, b) => a.descricao.compareTo(b.descricao),
        itemBuilder: (TarefaListagemModel tarefa) {
          return CardTarefaComponent(tarefa: tarefa);
        },
        initialList: tarefasListagem,
        filter: (p0) {
          return tarefasListagem
              .where((element) => (element.descricao
                      .toLowerCase()
                      .contains(p0.toLowerCase()) ||
                  element.responsavel.toLowerCase().contains(p0.toLowerCase())))
              .toList();
        },
        inputDecoration: InputDecoration(
          labelText: "Pesquisar tarefa",
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
        title: const Text('Todas as Tarefas'),
        actions: [
          IconButton(
            tooltip: 'Atualizar tarefas',
            onPressed: tarefasStore.getTarefas,
            icon: const Icon(Icons.sync_outlined),
          ),
        ],
      ),
      drawer: DrawerMenuComponent(),
      body: RefreshIndicator(
        onRefresh: tarefasStore.getTarefas,
        child: ScopedBuilder<TarefasStore, List<TarefaListagemModel>>(
          store: tarefasStore,
          onError: (context, erro) => _buildError(erro!),
          onLoading: (context) => _buildLoading(),
          onState: (context, List<TarefaListagemModel> state) =>
              _buildSuccess(state),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Modular.to.pushNamed('/sistema/tarefas/cadastrar');
        },
        child: const Icon(Icons.task_alt_outlined),
      ),
    );
  }
}
