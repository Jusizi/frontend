import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

import '../../models/modelo_model.dart';
import '../../modules/sistema/pages/modelos/modelos_store.dart';

class SelecionarModeloComponent extends StatefulWidget {
  final String clienteCodigo;
  const SelecionarModeloComponent({super.key, required this.clienteCodigo});

  @override
  State<SelecionarModeloComponent> createState() =>
      _SelecionarModeloComponentState();
}

class _SelecionarModeloComponentState extends State<SelecionarModeloComponent> {
  late ModelosStore modelosStore;

  @override
  void initState() {
    super.initState();

    modelosStore = Modular.get<ModelosStore>();

    /*if (isTest) {
      Future.delayed(const Duration(seconds: 1), () {
        _selectedModelo = modelosStore.modelos.first;

        gerarDocumento();
      });
    }*/
  }

  Future<void> gerarDocumento(ModeloModel modelo) async {
    Modular.to.pushNamed(
      '/sistema/modelo/gerardocumentocliente/${modelo.codigo}/${widget.clienteCodigo}',
    );
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
      return Center(
        child: TextButton.icon(
          onPressed: () => Modular.to.pushNamed('/sistema/modelo/novo'),
          label: const Text('Adicionar modelo'),
          icon: const Icon(Icons.add),
        ),
      );
    }

    if (modelosStore.modelos.last.codigo != 'ultimo-modelo-flag') {
      modelosStore.modelos.add(ModeloModel(
        codigo: 'ultimo-modelo-flag',
        nome: '',
        nomeArquivo: '',
      ));
    }

    return DropdownButton<ModeloModel>(
      hint: const Text('Gerar documento apartir de modelos'),
      onChanged: (ModeloModel? newValue) {},
      items: modelosStore.modelos.map<DropdownMenuItem<ModeloModel>>(
        (ModeloModel modelo) {
          if (modelo.codigo == 'ultimo-modelo-flag') {
            return DropdownMenuItem<ModeloModel>(
              value: modelo,
              enabled: false,
              onTap: null,
              child: Row(
                children: [
                  TextButton.icon(
                    onPressed: () =>
                        Modular.to.pushNamed('/sistema/modelo/novo'),
                    label: const Text('Adicionar modelo'),
                    icon: const Icon(Icons.add),
                  ),
                  TextButton.icon(
                    onPressed: () => Modular.to.pushNamed('/sistema/modelos'),
                    label: const Text('Ver modelos'),
                    icon: const Icon(Icons.list),
                  ),
                ],
              ),
            );
          }

          return DropdownMenuItem<ModeloModel>(
            value: modelo,
            onTap: null,
            enabled: false,
            child: Row(
              children: [
                Text(modelo.nome.substring(
                    0, modelo.nome.length > 30 ? 30 : modelo.nome.length)),
                TextButton.icon(
                  onPressed: () => gerarDocumento(modelo),
                  label: const Text('Gerar'),
                  icon: const Icon(Icons.picture_as_pdf),
                ),
              ],
            ),
          );
        },
      ).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedBuilder<ModelosStore, int>(
      store: modelosStore,
      onError: (context, erro) => _buildError(erro!),
      onLoading: (context) => _buildLoading(),
      onState: (context, state) => _buildSuccess(state),
    );
  }
}
