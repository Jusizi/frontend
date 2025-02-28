import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../models/cobranca_listagem_model.dart';
import '../../modules/sistema/pages/clientes/clientes_store.dart';

class CardCobrancaComponent extends StatefulWidget {
  final CobrancaListagemModel cobrancaListagem;
  const CardCobrancaComponent({
    super.key,
    required this.cobrancaListagem,
  });

  @override
  State<CardCobrancaComponent> createState() => _CardCobrancaComponentState();
}

class _CardCobrancaComponentState extends State<CardCobrancaComponent> {
  late final ClientesStore clientesStore;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      key: GlobalKey(),
      child: ListTile(
        title: Text(widget.cobrancaListagem.pagadorNomeCompleto),
        subtitle: Text(
            "${widget.cobrancaListagem.meioDePagamentoName} - ${widget.cobrancaListagem.descricao}"),
        trailing: Column(
          children: [
            Text(widget.cobrancaListagem.dataVencimento),
            Text(
                "R\$ ${widget.cobrancaListagem.valor.toStringAsFixed(2).replaceAll('.', ',')}"),
          ],
        ),
        onTap: () {
          Modular.to.pushNamed(
            '/sistema/cobranca/detalhes/${widget.cobrancaListagem.codigo}',
          );
        },
      ),
    );
  }
}
