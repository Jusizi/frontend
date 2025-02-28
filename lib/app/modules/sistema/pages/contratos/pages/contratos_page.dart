import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:searchable_listview/searchable_listview.dart';

import '../../../../../designSystem/components/card_contrato_component.dart';
import '../../../../../designSystem/layout/drawermenuComponent.dart';
import '../../../../../models/contrato_listagem_model.dart';
import '../contratos_store.dart';

class ContratosPage extends StatefulWidget {
  const ContratosPage({super.key});

  @override
  State<ContratosPage> createState() => _ContratosPageState();
}

class _ContratosPageState extends State<ContratosPage> {
  late ContratosStore contratosStore;

  @override
  void initState() {
    super.initState();

    contratosStore = Modular.get<ContratosStore>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (contratosStore.contratos.isEmpty) {
        contratosStore.getContratos();
      }
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

  Widget _buildSuccess(List<ContratoListagemModel> contratosListagem) {
    if (contratosListagem.isEmpty) {
      return const Center(
        child: Text('Nenhum contrato foi encontrado.'),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(10),
      child: SearchableList<ContratoListagemModel>(
        sortWidget: const Icon(Icons.sort),
        sortPredicate: (a, b) => a.status.compareTo(b.status),
        itemBuilder: (ContratoListagemModel contrato) {
          return CardContratoComponent(contratoListagem: contrato);
        },
        initialList: contratosListagem,
        filter: (p0) {
          return contratosListagem
              .where((element) =>
                  (element.status.toLowerCase().contains(p0.toLowerCase())))
              .toList();
        },
        inputDecoration: InputDecoration(
          labelText: "Pesquisar contrato",
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
      itemCount: contratosStore.processos.length,
      itemBuilder: (context, indexContexto) {
        ContratoListagemModel processo =
            contratosStore.processos[indexContexto];

        return CardProcessoComponent(processoListagem: processo);
      },
    );*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: GlobalKey(),
      appBar: AppBar(
        title: const Text("Contratos"),
        actions: [
          IconButton(
            onPressed: contratosStore.getContratos,
            icon: const Icon(Icons.sync_outlined),
          ),
        ],
      ),
      drawer: drawerORleading(),
      body: ScopedBuilder<ContratosStore, int>(
        store: contratosStore,
        onError: (context, erro) => _buildError(erro!),
        onLoading: (context) => _buildLoading(),
        onState: (context, state) => _buildSuccess(contratosStore.contratos),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Modular.to.pushNamed('/sistema/contrato/novo');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
