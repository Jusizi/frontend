import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../../../designSystem/layout/drawermenuComponent.dart';
import '../../../../../designSystem/snackbar_component.dart';
import '../../../../../models/processo_model.dart';
import '../processos_store.dart';
import 'processo_detalhes_widget.dart';

class ProcessoDetalhesPage extends StatefulWidget {
  late String processoCodigo;
  ProcessoDetalhesPage({
    super.key,
    required this.processoCodigo,
  });

  @override
  State<ProcessoDetalhesPage> createState() => _ProcessoDetalhesPageState();
}

class _ProcessoDetalhesPageState extends State<ProcessoDetalhesPage> {
  late ProcessosStore processoStore;
  bool loadingConsultarMovimentacoes = false;
  bool loadingSolicitarAtualizacaoDoProcesso = false;
  bool loadingMonitorarProcesso = false;
  ProcessoModel? processo;
  bool loadingSolicitarResumoIA = false;
  bool loadingDownloadResumoPDF = false;

  @override
  void initState() {
    super.initState();
    processoStore = Modular.get<ProcessosStore>();
    buscarInformacoesDoProcesso();
  }

  Future<void> buscarInformacoesDoProcesso() async {
    processoStore.getProcessoDetalhes(widget.processoCodigo).then((value) {
      value.fold(
        (l) {
          SnackBarComponent().showError(l);
        },
        (ProcessoModel processoModelTemp) {
          processo = processoModelTemp;

          setState(() {});
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: GlobalKey(),
      appBar: AppBar(
        title: const Text("Detalhes do Processo"),
      ),
      drawer: drawerORleading(),
      body: Visibility(
        visible: processo is ProcessoModel && processo != null,
        replacement: const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
        child: ProcessoDetalhes(processo: processo!),
      ),
    );
  }
}
