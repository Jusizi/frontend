import 'package:flutter/material.dart';

import '../../models/caixa_movimentacao_model.dart';

class CardCaixaMovimentacaoComponent extends StatelessWidget {
  final CaixaMovimentacaoModel caixaMovimentacaoModel;
  const CardCaixaMovimentacaoComponent({
    super.key,
    required this.caixaMovimentacaoModel,
  });

  @override
  Widget build(BuildContext context) {
    String title = caixaMovimentacaoModel.pagadorNomeCompleto.toString();
    if (title.isEmpty || title == '') {
      title = caixaMovimentacaoModel.planoDeContaNome;
    }
    String subtitle = caixaMovimentacaoModel.pagadorDocumento.toString();
    if (subtitle.isEmpty || subtitle == '') {
      subtitle = caixaMovimentacaoModel.planoDeContaNome.toString();
      if (subtitle == title) {
        subtitle = '';
      }
    }

    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListTile(
        shape: const Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 0.3,
          ),
        ),
        leading: CircleAvatar(
          foregroundColor: caixaMovimentacaoModel.valor < 0
              ? Colors.grey[500]
              : Colors.green,
          backgroundColor: caixaMovimentacaoModel.valor < 0
              ? Colors.grey[200]
              : Colors.green[100],
          child: const Icon(Icons.attach_money_outlined),
        ),
        title: Text(title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: subtitle.isNotEmpty,
              child: Text(subtitle),
            ),
            Text('R\$ ${caixaMovimentacaoModel.valor.toString()}'),
          ],
        ),
        trailing: Text(caixaMovimentacaoModel.dataMovimentacaoAt),
      ),
    );
  }
}
