import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../designSystem/components/card_processo_envolvido_component.dart';
import '../../../../../designSystem/components/card_processo_movimentacao_component.dart';
import '../../../../../designSystem/snackbar_component.dart';
import '../../../../../models/envolvido_model.dart';
import '../../../../../models/movimentacao_model.dart';
import '../../../../../models/processo_model.dart';
import '../../../../../shared/either.dart';
import '../processos_store.dart';

class ProcessoDetalhes extends StatefulWidget {
  final ProcessoModel processo;

  const ProcessoDetalhes({
    super.key,
    required this.processo,
  });

  @override
  State<ProcessoDetalhes> createState() => _ProcessoDetalhesState();
}

class _ProcessoDetalhesState extends State<ProcessoDetalhes> {
  late ProcessosStore processoStore;
  bool loadingConsultarMovimentacoes = false;
  bool loadingSolicitarAtualizacaoDoProcesso = false;
  bool loadingMonitorarProcesso = false;
  bool loadingSolicitarResumoIA = false;
  bool loadingDownloadResumoPDF = false;

  @override
  void initState() {
    super.initState();
    processoStore = Modular.get<ProcessosStore>();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("CNJ: ${widget.processo.numeroCNJ}"),
          Visibility(
            visible: widget.processo.demandante.isNotEmpty,
            child: Text("Demandante: ${widget.processo.demandante}"),
          ),
          Visibility(
            visible: widget.processo.demandado.isNotEmpty,
            child: Text("Demandado: ${widget.processo.demandado}"),
          ),
          Visibility(
            visible: widget.processo.resumo.isNotEmpty,
            replacement: Center(
              child: Visibility(
                visible: !loadingSolicitarResumoIA,
                replacement: Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
                child: TextButton.icon(
                  onPressed: () async {
                    setState(() {
                      loadingSolicitarResumoIA = true;
                    });

                    SnackBarComponent().showWarning(
                      "Aguarde, estamos solicitando o resumo do processo para IA (Inteligência Artificial).",
                    );

                    final resposta =
                        await processoStore.solicitarResumoProcessoParaIA(
                            widget.processo.numeroCNJ);

                    setState(() {
                      loadingSolicitarResumoIA = false;
                    });
                    resposta.fold(
                      (String erro) {
                        SnackBarComponent().showError(erro);
                      },
                      (String sucesso) {
                        Modular.to.pushReplacementNamed(
                            '/sistema/processos/detalhe/${widget.processo.codigo}');
                      },
                    );
                  },
                  label: Text(
                      'Solicitar Resumo do processo para IA (Inteligência Artificial)'),
                  icon: Icon(Icons.smart_toy_outlined),
                ),
              ),
            ),
            child: SelectionArea(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.4,
                    child: Divider(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Wrap(
                    spacing: 30,
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      Text(
                          'Última atualização: ${widget.processo.resumoDataAtualizacao.day}/${widget.processo.resumoDataAtualizacao.month}/${widget.processo.resumoDataAtualizacao.year} às ${widget.processo.resumoDataAtualizacao.hour}:${widget.processo.resumoDataAtualizacao.minute}'),
                      const Icon(Icons.lightbulb_outline),
                      Text(
                          "Resumo do processo por IA (Inteligência Artificial)"),
                      Visibility(
                        visible: !loadingDownloadResumoPDF,
                        replacement: const CircularProgressIndicator.adaptive(),
                        child: TextButton.icon(
                          onPressed: () async {
                            setState(() {
                              loadingDownloadResumoPDF = true;
                            });

                            final resposta = await processoStore
                                .getLinkDownloadResumoPDF(widget.processo);

                            resposta.fold((String mensagemErro) {
                              SnackBarComponent().showError(mensagemErro);
                            }, (String linkDownload) async {
                              setState(() {
                                loadingDownloadResumoPDF = false;
                              });
                              SnackBarComponent().showSuccess(
                                "Download do resumo em PDF iniciado com sucesso",
                              );

                              if (await canLaunchUrl(Uri.parse(linkDownload))) {
                                await launchUrl(
                                  Uri.parse(linkDownload),
                                  mode: LaunchMode.externalApplication,
                                );
                              }
                            });
                          },
                          label: Text("Download do resumo em PDF"),
                          icon: Icon(Icons.picture_as_pdf_outlined),
                        ),
                      ),
                    ],
                  ),
                  Text(widget.processo.resumo),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.4,
                    child: Divider(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: widget.processo.movimentacoes.isEmpty,
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
                            .consultarMovimentacoesProcesso(widget.processo);

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
                              '/sistema/processos/detalhe/${widget.processo.codigo}',
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
            visible: widget.processo.movimentacoes.isNotEmpty,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Movimentações"),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: widget.processo.movimentacoes.length > 2
                      ? 2
                      : widget.processo.movimentacoes.length,
                  itemBuilder: (context, index) {
                    MovimentacaoModel movimentacao =
                        widget.processo.movimentacoes[index];
                    return CardProcessoMovimentacaoComponent(
                      movimentacao: movimentacao,
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: widget.processo.movimentacoes.length > 2,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: TextButton.icon(
                          onPressed: () {
                            Modular.to.pushNamed(
                              '/sistema/processos/detalhe/${widget.processo.codigo}/movimentacoes',
                              arguments: widget.processo,
                            );
                          },
                          label: Text(
                              "Ver as ${widget.processo.movimentacoes.length} movimentações"),
                          icon: const Icon(Icons.list_rounded),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
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
            itemCount: widget.processo.envolvidos.length,
            itemBuilder: (context, index) {
              EnvolvidoModel envolvido = widget.processo.envolvidos[index];

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
                    .solicitarAtualizacaoDoProcesso(widget.processo);

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

                final Either<String, String> resposta = await processoStore
                    .monitorarProcesso(widget.processo.codigo);

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
        ],
      ),
    );
  }
}
