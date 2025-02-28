import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../../../designSystem/layout/drawermenuComponent.dart';
import '../../../../../designSystem/snackbar_component.dart';
import '../../../../../models/modelo_model.dart';
import '../../clientes/clientes_store.dart';
import '../modelos_store.dart';

class ModeloGerarDocumentoClientePage extends StatefulWidget {
  final String modeloCodigo;
  final String clienteCodigo;
  const ModeloGerarDocumentoClientePage({
    super.key,
    required this.modeloCodigo,
    required this.clienteCodigo,
  });

  @override
  State<ModeloGerarDocumentoClientePage> createState() =>
      _ModeloGerarDocumentoClientePageState();
}

class _ModeloGerarDocumentoClientePageState
    extends State<ModeloGerarDocumentoClientePage> {
  late ModelosStore modelosStore;
  late ClientesStore clientesStore;
  String linkDownloadPDF = '';

  String titulo = 'Gerar documento';
  late ModeloModel modelo;

  Widget pdfViewer = const Center(
    child: CircularProgressIndicator.adaptive(),
  );

  @override
  void initState() {
    super.initState();

    modelosStore = Modular.get<ModelosStore>();
    clientesStore = Modular.get<ClientesStore>();

    modelo = modelosStore.identificarModeloPeloCodigo(widget.modeloCodigo);

    titulo = 'Gerar documento - ${modelo.nome}';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      modelosStore
          .gerarDocumentoApartirDoModeloParaOCliente(
        modeloCodigo: widget.modeloCodigo,
        clienteCodigo: widget.clienteCodigo,
      )
          .then((resposta) {
        resposta.fold(
          (l) {
            SnackBarComponent().showError(l);
            pdfViewer = Text('Erro ao carregar o arquivo - $l');
          },
          (respostaAPIlinkDownloadPDF) {
            linkDownloadPDF = respostaAPIlinkDownloadPDF;
            pdfViewer = SfPdfViewer.network(
              linkDownloadPDF,
            );
            setState(() {});
          },
        );
      });
    });
  }

  Future<void> fazerDownloadDoDocumentoPDF() async {
    if (linkDownloadPDF.isEmpty) {
      SnackBarComponent().showError('Documento não encontrado');
      return;
    }

    final resposta = await modelosStore.fazerDownloadDoDocumentoPDF(
      linkDownloadPDF,
    );

    resposta.fold(
      (l) => SnackBarComponent().showError(l),
      (r) => SnackBarComponent().showSuccess(r),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titulo),
      ),
      drawer: drawerORleading(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton.icon(
                  onPressed: () {
                    Modular.to.pushNamed(
                      '/sistema/clientes/detalhes/${widget.clienteCodigo}',
                    );
                  },
                  icon: const Icon(Icons.person),
                  label: const Text('Editar Cliente'),
                ),
                TextButton.icon(
                  onPressed: () {
                    Modular.to.pushNamed(
                      '/sistema/modelo/detalhes/${widget.modeloCodigo}',
                    );
                  },
                  icon: const Icon(Icons.picture_as_pdf_outlined),
                  label: const Text('Ver Modelo'),
                ),
                TextButton.icon(
                  onPressed: fazerDownloadDoDocumentoPDF,
                  label: const Text('Fazer Download do documento PDF'),
                  icon: const Icon(Icons.download),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(child: pdfViewer),
          ],
        ),
      ),
    );
  }
}
