import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../../designSystem/layout/drawermenuComponent.dart';
import '../../../../../designSystem/snackbar_component.dart';
import '../../../../../models/modelo_model.dart';
import '../../../../../shared/either.dart';
import '../modelos_store.dart';

class ModeloNovoPage extends StatefulWidget {
  const ModeloNovoPage({
    super.key,
  });

  @override
  State<ModeloNovoPage> createState() => _ModeloNovoPageState();
}

class _ModeloNovoPageState extends State<ModeloNovoPage> {
  bool aguardeSalvando = false;
  late ModelosStore modelosStore;
  PlatformFile? arquivo;

  final TextEditingController _nomeController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    modelosStore = Modular.get<ModelosStore>();
    Modular.get<ModelosStore>();
  }

  Future<void> openFiles() async {
    await FilePicker.platform.pickFiles(
      allowMultiple: false,
      allowedExtensions: ['docx'],
    ).then((e) {
      if (e != null) {
        FilePickerResult result = e;

        if (result.files.single.extension == 'docx') {
          SnackBarComponent().showSuccess(
            'O arquivo selecionado é um DOCX.',
          );
        } else {
          SnackBarComponent().showError(
            'O arquivo selecionado não é um DOCX.',
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: GlobalKey(),
      appBar: AppBar(
        title: TextField(
          controller: _nomeController,
          onChanged: (value) {},
        ),
      ),
      floatingActionButton: aguardeSalvando
          ? const CircularProgressIndicator.adaptive()
          : FloatingActionButton(
              onPressed: () async {
                aguardeSalvando = true;
                setState(() {});

                if (arquivo == null) {
                  SnackBarComponent().showError('Selecione um arquivo!');
                  aguardeSalvando = false;
                  setState(() {});
                  return;
                }

                Either<String, bool> retorno = await modelosStore.criarModelo(
                  modelo: ModeloModel(
                    codigo: '',
                    nome: _nomeController.text,
                    nomeArquivo: '',
                  ),
                  documento: arquivo!,
                );

                retorno.fold(
                  (l) {
                    SnackBarComponent().showError(l);
                  },
                  (r) {
                    SnackBarComponent()
                        .showSuccess('Modelo foi criado com sucesso!');
                  },
                );

                aguardeSalvando = false;
                setState(() {});
              },
              child: const Icon(Icons.save),
            ),
      drawer: drawerORleading(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: () async {
                  FilePickerResult? resultado =
                      await FilePicker.platform.pickFiles(
                    allowMultiple: false,
                    type: FileType.custom,
                    allowedExtensions: [
                      'docx',
                      'doc',
                      'pdf',
                    ],
                  );

                  if (resultado != null) {
                    arquivo = resultado.files.firstOrNull;
                  }
                },
                child: const Text('Selecionar arquivo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
