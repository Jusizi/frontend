import 'package:flutter/material.dart';

import '../../models/movimentacao_model.dart';

class CardProcessoMovimentacaoComponent extends StatelessWidget {
  final MovimentacaoModel movimentacao;
  const CardProcessoMovimentacaoComponent({
    super.key,
    required this.movimentacao,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text("Data: ${movimentacao.data}"),
                const Spacer(),
                movimentacao.tipo.isEmpty
                    ? Container()
                    : Text("Tipo: ${movimentacao.tipo}"),
              ],
            ),
            Row(
              children: [
                movimentacao.tipoPublicacao.isEmpty
                    ? Container()
                    : Text("Tipo Publicação: ${movimentacao.tipoPublicacao}"),
              ],
            ),
            Visibility(
              visible: movimentacao.classificacaoPreditaHierarquia.isNotEmpty,
              child: Text(
                "Classificação: ${movimentacao.classificacaoPreditaHierarquia}",
              ),
            ),
            Row(children: [
              Expanded(
                child: Text(
                  "Conteúdo: ${movimentacao.conteudo}",
                  softWrap: true,
                ),
              ),
            ]),
            movimentacao.textoCategoria.isEmpty
                ? Container()
                : Text("Texto Categoria: ${movimentacao.textoCategoria}"),
            const Row(
              children: [
                Spacer(),
              ],
            ),
            Text(
              "Fonte: ${movimentacao.fonteTipo} - ${movimentacao.fonteSigla} - Grau ${movimentacao.fonteGrau}",
            ),
          ],
        ),
      ),
    );
  }
}
