import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../designSystem/components/confirm_component.dart';
import '../../../../designSystem/layout/drawermenuComponent.dart';
import '../../../../designSystem/snackbar_component.dart';
import '../../../../models/boleto_model.dart';
import '../../../../shared/either.dart';
import '../cobrancas/cobrancas_store.dart';
import 'boletos_store.dart';

class CobrancaBoletoDetalhesPage extends StatefulWidget {
  final String boletoCodigo;
  const CobrancaBoletoDetalhesPage({super.key, required this.boletoCodigo});

  @override
  State<CobrancaBoletoDetalhesPage> createState() =>
      _CobrancaBoletoDetalhesPageState();
}

class _CobrancaBoletoDetalhesPageState
    extends State<CobrancaBoletoDetalhesPage> {
  late BoletosStore boletosStore;
  late BoletoModel boleto;
  bool loadingConsultarBoleto = false;
  bool loadingCancelarBoleto = false;
  bool loadingLiquidarBoleto = false;

  @override
  void initState() {
    super.initState();
  }

  Future<Widget> informacoesBoletoDetalhes() async {
    boletosStore = Modular.get<BoletosStore>();

    final Either<String, BoletoModel> resposta =
        await boletosStore.buscarInformacoesDoBoleto(widget.boletoCodigo);

    return resposta.fold((l) {
      return Center(
        child: Text(l),
      );
    }, (BoletoModel boletoResposta) {
      boleto = boletoResposta;
      //boleto.tryGetPagador();

      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /*Visibility(
                visible: boleto.pagador != null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Pagador'),
                    CardClienteComponent(cliente: boleto.pagador!),
                    const SizedBox(height: 10),
                  ],
                ),
              ),*/
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Data de vencimento',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(boleto.dataVencimentoFormatada),
                ],
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Valor',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(boleto.valor.toString()),
                ],
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nosso número',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(boleto.nossoNumero),
                ],
              ),
              const SizedBox(height: 10),
              Visibility(
                visible: boleto.linhaDigitavel.isNotEmpty,
                child: TextButton.icon(
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(text: boleto.linhaDigitavel),
                    );

                    SnackBarComponent().showSuccess(
                      'Linha digitável copiado!',
                    );
                  },
                  label: Text("Linha digitável: ${boleto.linhaDigitavel}"),
                  icon: const Icon(Icons.copy),
                ),
              ),
              const SizedBox(height: 10),
              // Vamos ver o PDF>
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Link do boleto',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Visibility(
                    visible: boleto.link.isNotEmpty,
                    child: TextButton.icon(
                      onPressed: () async {
                        await launchUrl(Uri.parse(boleto.link));
                      },
                      label: const Text('Abrir PDF'),
                      icon: const Icon(Icons.picture_as_pdf),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Status',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(boleto.status.name),
                ],
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Descrição',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(boleto.mensagem),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
              Wrap(
                children: [
                  Visibility(
                    visible: loadingConsultarBoleto,
                    child: const CircularProgressIndicator.adaptive(),
                  ),
                  Visibility(
                    visible: !loadingConsultarBoleto &&
                        boleto.status == StatusBoleto.PENDENTE,
                    child: TextButton.icon(
                      onPressed: () async {
                        setState(() {
                          loadingConsultarBoleto = true;
                        });

                        final Either<String, String> resposta =
                            await boletosStore.consultarBoletoNoBanco(boleto);

                        resposta.fold((l) {
                          SnackBarComponent().showError(l);
                        }, (r) {
                          SnackBarComponent().showSuccess(r);
                        });

                        setState(() {
                          loadingConsultarBoleto = false;
                        });
                      },
                      label: const Text("Consultar situação na plataforma"),
                      icon: const Icon(Icons.search_outlined),
                    ),
                  ),
                  Visibility(
                    visible: loadingLiquidarBoleto &&
                        boleto.status == StatusBoleto.PENDENTE,
                    child: const CircularProgressIndicator.adaptive(),
                  ),
                  Visibility(
                    visible: !loadingLiquidarBoleto &&
                        boleto.status == StatusBoleto.PENDENTE,
                    child: TextButton.icon(
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return ConfirmComponent(
                              title: 'Liquidar boleto',
                              description:
                                  'Tem certeza que deseja liquidar o boleto?',
                              onCancel: () {},
                              onConfirm: liquidarBoleto,
                            );
                          },
                        );
                      },
                      label: const Text("Já recebi o pagamento"),
                      icon: const Icon(Icons.check_circle_outline),
                    ),
                  ),
                  Visibility(
                    visible: loadingCancelarBoleto &&
                        boleto.status == StatusBoleto.PENDENTE,
                    child: const CircularProgressIndicator.adaptive(),
                  ),
                  Visibility(
                    visible: !loadingCancelarBoleto &&
                        boleto.status == StatusBoleto.PENDENTE,
                    child: TextButton.icon(
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return ConfirmComponent(
                              title: 'Cancelar boleto',
                              description:
                                  'Tem certeza que deseja cancelar o boleto?',
                              onCancel: () {},
                              onConfirm: cancelarBoleto,
                            );
                          },
                        );
                      },
                      label: const Text("Cancelar boleto"),
                      icon: const Icon(Icons.cancel_outlined),
                    ),
                  ),
                ],
              ),

              /*Visibility(
                visible: widget.boleto.link.isNotEmpty,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 1.5,
                  child: SfPdfViewer.network(
                    widget.boleto.link,
                  ),
                ),
              ),*/

              const SizedBox(height: 30),
            ],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: GlobalKey(),
      appBar: AppBar(
        title: const Text('Detalhes do Boleto'),
      ),
      drawer: drawerORleading(),
      body: FutureBuilder<Widget>(
        future: informacoesBoletoDetalhes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          return snapshot.data!;
        },
      ),
    );
  }

  Future<void> liquidarBoleto() async {
    setState(() {
      loadingLiquidarBoleto = true;
    });

    final Either<String, String> resposta =
        await boletosStore.liquidarBoleto(boleto);

    resposta.fold((l) {
      SnackBarComponent().showError(l);
    }, (r) {
      SnackBarComponent().showSuccess(r);
      Modular.get<CobrancasStore>().buscarTodasAsCobrancas();
      /*if (widget.boleto.cobranca != null) {
        Modular.get<CaixamovimentacoesStore>().getMovimentacoesDaContaBancaria(
            widget.boleto.cobranca!.contaBancaria!.id);
      }*/

      Modular.to.pushNamed('/sistema/cobrancas');
      Modular.to.pushNamed(
        '/sistema/cobranca/detalhes/${boleto.cobrancaCodigo}',
      );
      /*Modular.to.pushNamed(
        '/sistema/boleto/detalhes',
        arguments: Modular.get<CobrancasStore>().cobrancas.firstWhere(
            (CobrancaModel cobranca) =>
                cobranca.codigo == widget.boleto.cobranca!.codigo &&
                cobranca.boletos.contains(widget.boleto)),
      );*/
    });

    setState(() {
      loadingLiquidarBoleto = false;
    });
  }

  Future<void> cancelarBoleto() async {
    setState(() {
      loadingCancelarBoleto = true;
    });

    final Either<String, String> resposta =
        await boletosStore.cancelarBoleto(boleto);

    resposta.fold((l) {
      SnackBarComponent().showError(l);
    }, (r) {
      SnackBarComponent().showSuccess(r);
    });

    setState(() {
      loadingCancelarBoleto = false;
    });
  }
}
