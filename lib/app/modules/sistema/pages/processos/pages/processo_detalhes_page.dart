import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../../designSystem/components/card_processo_envolvido_component.dart';
import '../../../../../designSystem/components/card_processo_movimentacao_component.dart';
import '../../../../../designSystem/layout/drawermenuComponent.dart';
import '../../../../../designSystem/snackbar_component.dart';
import '../../../../../models/envolvido_model.dart';
import '../../../../../models/movimentacao_model.dart';
import '../../../../../models/processo_model.dart';
import '../../../../../shared/either.dart';
import '../processos_store.dart';

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
  late ProcessoModel processo;

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
          widgetPrincipal = Center(
            child: Column(
              children: [
                const Text('Erro ao buscar informações do processo'),
                Text(l),
              ],
            ),
          );

          setState(() {});
        },
        (ProcessoModel processoModelTemp) {
          processo = processoModelTemp;
          widgetPrincipal = SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("CNJ: ${processo.numeroCNJ}"),
                Visibility(
                  visible: processo.demandante.isNotEmpty,
                  child: Text("Demandante: ${processo.demandante}"),
                ),
                Visibility(
                  visible: processo.demandado.isNotEmpty,
                  child: Text("Demandado: ${processo.demandado}"),
                ),
                Visibility(
                  visible: processo.movimentacoes.isEmpty,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text("Movimentações"),
                      const Text(
                          "Nenhuma movimentação encontrada, clique no botão abaixo para consultar."),
                      Visibility(
                        visible: loadingConsultarMovimentacoes,
                        child: const CircularProgressIndicator.adaptive(),
                      ),
                      Visibility(
                        visible: !loadingConsultarMovimentacoes,
                        child: Align(
                          alignment: Alignment.center,
                          child: TextButton.icon(
                            onPressed: () async {
                              setState(() {
                                loadingConsultarMovimentacoes = true;
                              });

                              final retorno = await processoStore
                                  .consultarMovimentacoesProcesso(processo);

                              retorno.fold(
                                (l) {
                                  SnackBarComponent().showError(l);
                                },
                                (r) async {
                                  SnackBarComponent().showSuccess(
                                    "Movimentações consultadas com sucesso",
                                  );
                                  await processoStore.getProcessos();

                                  Modular.to.pop();

                                  Modular.to.pushNamed(
                                    '/sistema/processos/detalhe/${processo.codigo}',
                                  );
                                },
                              );

                              setState(() {
                                loadingConsultarMovimentacoes = false;
                              });
                            },
                            label: const Text("Consultar Movimentações"),
                            icon: const Icon(Icons.list_rounded),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: processo.movimentacoes.isNotEmpty,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Movimentações"),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: processo.movimentacoes.length > 2
                            ? 2
                            : processo.movimentacoes.length,
                        itemBuilder: (context, index) {
                          MovimentacaoModel movimentacao =
                              processo.movimentacoes[index];
                          return CardProcessoMovimentacaoComponent(
                            movimentacao: movimentacao,
                          );
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: TextButton.icon(
                          onPressed: () {
                            Modular.to.pushNamed(
                              '/sistema/processos/detalhe/${processo.codigo}/movimentacoes',
                              arguments: processo,
                            );
                          },
                          label: Text(
                              "Ver as ${processo.movimentacoes.length} movimentações"),
                          icon: const Icon(Icons.list_rounded),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text("Envolvidos"),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: processo.envolvidos.length,
                  itemBuilder: (context, index) {
                    EnvolvidoModel envolvido = processo.envolvidos[index];

                    return CardProcessoEnvolvidoComponent(envolvido: envolvido);
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: const Text("Documentos"),
                        subtitle: const Text(
                            "Visualize todos os documentos disponíveis neste processo"),
                        trailing: IconButton(
                          icon: const Icon(Icons.picture_as_pdf_outlined),
                          onPressed: () {
                            // Modular.to.pushNamed('/sistema/processos/processo/novo');
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Visibility(
                  visible: loadingSolicitarAtualizacaoDoProcesso,
                  child: const CircularProgressIndicator.adaptive(),
                ),
                Visibility(
                  visible: !loadingSolicitarAtualizacaoDoProcesso,
                  child: TextButton.icon(
                    onPressed: () async {
                      loadingSolicitarAtualizacaoDoProcesso = true;
                      setState(() {});

                      await processoStore
                          .solicitarAtualizacaoDoProcesso(processo);

                      loadingSolicitarAtualizacaoDoProcesso = false;
                      setState(() {});

                      SnackBarComponent().showSuccess(
                        "Solicitamos a atualização do processo, em breve você terá novas informações.",
                      );
                    },
                    label: const Text("Solicitar atualização do processo"),
                    icon: const Icon(
                      Icons.sync_outlined,
                    ),
                  ),
                ),
                Visibility(
                  visible: loadingMonitorarProcesso,
                  child: const CircularProgressIndicator.adaptive(),
                ),
                Visibility(
                  visible: !loadingMonitorarProcesso,
                  child: TextButton.icon(
                    onPressed: () async {
                      loadingMonitorarProcesso = true;
                      setState(() {});

                      final Either<String, String> resposta =
                          await processoStore
                              .monitorarProcesso(processo.codigo);

                      resposta.fold((String erro) {
                        SnackBarComponent().showError(erro);
                      }, (String sucesso) {
                        SnackBarComponent().showSuccess(sucesso);
                        // "Este processo agora está sendo monitorado, quando houver novas movimentações você será notificado."
                      });

                      loadingMonitorarProcesso = false;
                      setState(() {});
                    },
                    label: const Text("Monitorar este processo"),
                    icon: const Icon(
                      Icons.monitor,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    SnackBarComponent().showWarning(
                      "Esta funcionalidade está sendo implementada, em breve você terá novas informações.",
                    );
                  },
                  label: const Text(
                      "Solicitar resumo do processo a Inteligência Artificial"),
                  icon: const Icon(Icons.sentiment_very_satisfied_outlined),
                ),
              ],
            ),
          );

          setState(() {});
        },
      );
    });
  }

  Widget widgetPrincipal = const Center(
    child: CircularProgressIndicator.adaptive(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: GlobalKey(),
      appBar: AppBar(
        title: const Text("Detalhes do Processo"),
        actions: const [
          /*IconButton(
            onPressed: () {
              Modular.to.pushNamed(
                '/sistema/processo/historico',
                arguments: processo,
              );
            },
            icon: const Icon(Icons.history_rounded),
          ),*/
        ],
      ),
      drawer: drawerORleading(),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: widgetPrincipal,
      ),
    );
  }
}
