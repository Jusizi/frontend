import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../../../designSystem/layout/drawermenuComponent.dart';
import '../../../../../designSystem/snackbar_component.dart';
import '../../../../../models/modelo_model.dart';
import '../../../../../models/variaveis_substituicao_model.dart';
import '../../../../../shared/either.dart';
import '../modelos_store.dart';

class ModeloDetalhesPage extends StatefulWidget {
  final String modeloCodigo;
  const ModeloDetalhesPage({
    super.key,
    required this.modeloCodigo,
  });

  @override
  State<ModeloDetalhesPage> createState() => _ModeloDetalhesPageState();
}

class _ModeloDetalhesPageState extends State<ModeloDetalhesPage> {
  bool aguardeSalvando = false;
  late ModelosStore modelosStore;
  PlatformFile? arquivo;
  late ModeloModel modelo;

  Widget pdfPreview = const Center(
    child: CircularProgressIndicator.adaptive(),
  );

  final TextEditingController _nomeController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    modelosStore = Modular.get<ModelosStore>();

    modelo = modelosStore.identificarModeloPeloCodigo(widget.modeloCodigo);

    _nomeController.text = modelo.nome;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      modelosStore.obterPreviewModelo(modelo).then((resposta) {
        resposta.fold(
          (l) {
            SnackBarComponent().showError(l);
            pdfPreview = Text('Erro ao carregar o arquivo - $l');
          },
          (linkDownloadPDF) {
            pdfPreview = SfPdfViewer.network(
              linkDownloadPDF,
            );
            setState(() {});
          },
        );
      });
    });
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
        ),
      ),
      floatingActionButton: aguardeSalvando
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : FloatingActionButton(
              onPressed: () async {
                aguardeSalvando = true;
                setState(() {});

                modelo.nome = _nomeController.text;

                Either<String, bool> retorno = await modelosStore.editarModelo(
                  modelo: modelo,
                  documento: arquivo,
                );

                retorno.fold(
                  (l) {
                    SnackBarComponent().showError(l);
                  },
                  (r) {
                    if (r) {
                      SnackBarComponent()
                          .showSuccess('Modelo foi atualizado com sucesso!');
                    } else {
                      SnackBarComponent()
                          .showError('Erro ao atualizar o modelo!');
                    }
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
              /*TextButton(
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
              ),*/
              TextButton.icon(
                onPressed: () {},
                label: const Text('Baixar Modelo DOCX'),
                icon: const Icon(Icons.download),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: Row(
                  children: [
                    // Expanded(
                    //   child: FutureBuilder<Either<String, String>>(
                    //     initialData: null,
                    //     future: modelosStore.obterPreviewModelo(modelo),
                    //     builder: (context, snapshot) {
                    //       if (!snapshot.hasData ||
                    //           snapshot.connectionState ==
                    //               ConnectionState.waiting ||
                    //           snapshot.data == null) {
                    //         return const Center(
                    //           child: SizedBox(
                    //             height: 100,
                    //             width: 100,
                    //             child: CircularProgressIndicator(),
                    //           ),
                    //         );
                    //       }
                    //       return snapshot.data!.fold(
                    //         (l) => Text(l),
                    //         (r) => SizedBox(
                    //           height: 600,
                    //           child: SfPdfViewer.network(r),
                    //         ),
                    //       );
                    //       //
                    //     },
                    //   ),
                    // ),
                    Expanded(child: pdfPreview),

                    const VerticalDivider(),

                    Expanded(
                      child: ListView.builder(
                        itemCount: modelosStore.variaveisSubstituicao.length,
                        itemBuilder: (context, index) {
                          VariaveisSubstituicaoModel variaveisSubstituicao =
                              modelosStore.variaveisSubstituicao[index];

                          return Column(
                            children: [
                              Text(
                                variaveisSubstituicao.grupo,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: variaveisSubstituicao
                                    .variaveisSubstituicao.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(variaveisSubstituicao
                                        .variaveisSubstituicao[index].nome),
                                    subtitle: Text(
                                      variaveisSubstituicao
                                          .variaveisSubstituicao[index]
                                          .descricao,
                                    ),
                                    onTap: () {
                                      Clipboard.setData(
                                        ClipboardData(
                                            text: variaveisSubstituicao
                                                .variaveisSubstituicao[index]
                                                .nome),
                                      );

                                      SnackBarComponent().showSuccess(
                                        'Variável ${variaveisSubstituicao.variaveisSubstituicao[index].nome} copiada para a área de transferência.',
                                      );
                                    },
                                  );
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              )
                            ],
                          );
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
