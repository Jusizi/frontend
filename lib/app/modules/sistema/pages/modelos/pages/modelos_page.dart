import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

import '../../../../../designSystem/layout/body_component.dart';
import '../../../../../designSystem/layout/drawermenuComponent.dart';
import '../../../../../designSystem/snackbar_component.dart';
import '../../../../../models/modelo_model.dart';
import '../../../../../shared/either.dart';
import '../modelos_store.dart';

class ModelosPage extends StatefulWidget {
  const ModelosPage({super.key});

  @override
  State<ModelosPage> createState() => _ModelosPageState();
}

class _ModelosPageState extends State<ModelosPage> {
  late final ModelosStore modelosStore;

  @override
  void initState() {
    super.initState();

    modelosStore = Modular.get<ModelosStore>();
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
    if (modelosStore.modelos.isEmpty) {
      return const Center(
        child: Text('Nenhum modelo foi encontrado.'),
      );
    }

    return ListView.builder(
      itemCount: modelosStore.modelos.length,
      itemBuilder: (context, indexContexto) {
        ModeloModel modelo = modelosStore.modelos[indexContexto];

        return ListTile(
          onTap: () {
            Modular.to.pushNamed('/sistema/modelo/detalhes/${modelo.codigo}');
          },
          title: Text(modelo.nome),
          trailing: Column(
            children: [
              Visibility(
                visible: modelo.loadingExcluir,
                child: const CircularProgressIndicator.adaptive(),
              ),
              Visibility(
                visible: !modelo.loadingExcluir,
                child: TextButton.icon(
                  onPressed: () async {
                    final Either<String, String> resposta =
                        await modelosStore.excluirModelo(modelo.codigo);

                    resposta.fold((String erro) {
                      SnackBarComponent().showError(erro);
                    }, (String sucesso) {
                      SnackBarComponent().showSuccess(sucesso);
                    });
                  },
                  label: const Text("Remover"),
                  icon: const Icon(Icons.delete_forever_outlined),
                ),
              ),
            ],
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
        title: const Text('Meus modelos de documentos'),
        actions: [
          IconButton(
            tooltip: 'Atualizar modelos',
            onPressed: modelosStore.getModelos,
            icon: const Icon(Icons.sync),
          ),
        ],
      ),
      drawer: drawerORleading(),
      body: Bodycomponent(
        bodyWidget: RefreshIndicator(
          onRefresh: modelosStore.getModelos,
          child: ScopedBuilder<ModelosStore, int>(
            store: modelosStore,
            onError: (context, erro) => _buildError(erro!),
            onLoading: (context) => _buildLoading(),
            onState: (context, state) => _buildSuccess(state),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Modular.to.pushNamed('/sistema/modelo/novo');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
