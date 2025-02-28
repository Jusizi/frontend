import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:searchable_listview/searchable_listview.dart';

import '../../../../../designSystem/components/card_processo_component.dart';
import '../../../../../designSystem/layout/drawermenuComponent.dart';
import '../../../../../models/processo_listagem_model.dart';
import '../processos_store.dart';

class ProcessosPage extends StatefulWidget {
  const ProcessosPage({super.key});

  @override
  State<ProcessosPage> createState() => _ProcessosPageState();
}

class _ProcessosPageState extends State<ProcessosPage> {
  late ProcessosStore processosStore;

  @override
  void initState() {
    super.initState();

    processosStore = Modular.get<ProcessosStore>();
    if (processosStore.processos.isEmpty) {
      processosStore.getProcessos();
    }
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

  Widget _buildSuccess(List<ProcessoListagemModel> processosListagem) {
    if (processosListagem.isEmpty) {
      return const Center(
        child: Text('Nenhum processo foi encontrado.'),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(10),
      child: SearchableList<ProcessoListagemModel>(
        sortWidget: const Icon(Icons.sort),
        sortPredicate: (a, b) =>
            a.dataUltimaMovimentacao.compareTo(b.dataUltimaMovimentacao),
        itemBuilder: (ProcessoListagemModel processo) {
          return CardProcessoComponent(processoListagem: processo);
        },
        initialList: processosListagem,
        filter: (p0) {
          return processosListagem
              .where((element) => (element.demandado
                      .toLowerCase()
                      .contains(p0.toLowerCase()) ||
                  element.demandante.toLowerCase().contains(p0.toLowerCase()) ||
                  element.numeroCNJ.toLowerCase().contains(p0.toLowerCase())))
              .toList();
        },
        inputDecoration: InputDecoration(
          labelText: "Pesquisar processo",
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        closeKeyboardWhenScrolling: true,
      ),
    );

    /*
    return ListView.builder(
      itemCount: processosStore.processos.length,
      itemBuilder: (context, indexContexto) {
        ProcessoListagemModel processo =
            processosStore.processos[indexContexto];

        return CardProcessoComponent(processoListagem: processo);
      },
    );*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: GlobalKey(),
      appBar: AppBar(
        title: const Text("Processos"),
        actions: [
          IconButton(
            onPressed: processosStore.getProcessos,
            icon: const Icon(Icons.sync_outlined),
          ),
        ],
      ),
      drawer: drawerORleading(),
      body: ScopedBuilder<ProcessosStore, int>(
        store: processosStore,
        onError: (context, erro) => _buildError(erro!),
        onLoading: (context) => _buildLoading(),
        onState: (context, state) => _buildSuccess(processosStore.processos),
      ),
    );
  }
}
