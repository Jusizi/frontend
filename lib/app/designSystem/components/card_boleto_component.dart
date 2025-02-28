import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

import '../../models/boleto_model.dart';
import '../../models/cliente_model.dart';
import '../../modules/sistema/pages/cobrancas/cobrancas_store.dart';
import '../../shared/either.dart';
import '../snackbar_component.dart';

class CardBoletoComponent extends StatefulWidget {
  final BoletoModel boleto;
  const CardBoletoComponent({
    super.key,
    required this.boleto,
  });

  @override
  State<CardBoletoComponent> createState() => _CardBoletoComponentState();
}

class _CardBoletoComponentState extends State<CardBoletoComponent> {
  late CobrancasStore cobrancaStore;
  @override
  void initState() {
    super.initState();
    cobrancaStore = Modular.get<CobrancasStore>();
    //widget.boleto.tryGetPagador();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Widget titulo = Text(widget.boleto.mensagem);

    if (widget.boleto.pagador is ClienteModel) {
      titulo = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            children: [
              Text(widget.boleto.pagador!.nomeCompleto),
              widget.boleto.isLoading
                  ? const CircularProgressIndicator()
                  : widget.boleto.status == StatusBoleto.PENDENTE
                      ? TextButton.icon(
                          onPressed: () async {
                            widget.boleto.isLoading = true;
                            setState(() {});

                            final Either<String, String> resposta =
                                await cobrancaStore
                                    .consultarBoletoNoBanco(widget.boleto);

                            resposta.fold(
                              (String erro) {
                                SnackBarComponent().showError(erro);
                              },
                              (String mensagem) {
                                SnackBarComponent().showSuccess(mensagem);
                              },
                            );

                            widget.boleto.isLoading = false;
                            setState(() {});
                          },
                          label: const Text('Consultar no banco'),
                          icon: const Icon(Icons.search),
                        )
                      : Container(),
            ],
          ),
          Text(widget.boleto.pagador!.documento),
        ],
      );
    }

    Color colorStatus = Colors.white;
    if (widget.boleto.status == StatusBoleto.PENDENTE &&
        widget.boleto.vencimento.isBefore(DateTime.now())) {
      colorStatus = Colors.red[100]!;
    }

    if (widget.boleto.status == StatusBoleto.PAGO) {
      colorStatus = Colors.green[100]!;
    }

    return Card(
      color: colorStatus,
      child: ListTile(
        onTap: () => Modular.to.pushNamed(
          '/sistema/boleto/detalhes/${widget.boleto.boletoCodigo}',
        ),
        title: titulo,
        subtitle: Text("Nosso número: ${widget.boleto.nossoNumero}"),
        leading: Column(
          children: [
            Text('R\$ ${widget.boleto.valor}'),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Vencimento'),
            Text(DateFormat('dd/MM/yyyy').format(widget.boleto.vencimento)),
            Text(widget.boleto.status.name),
          ],
        ),
      ),
    );
  }
}
