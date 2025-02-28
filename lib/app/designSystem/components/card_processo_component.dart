import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../models/processo_listagem_model.dart';

class CardProcessoComponent extends StatelessWidget {
  final ProcessoListagemModel processoListagem;
  const CardProcessoComponent({
    super.key,
    required this.processoListagem,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Row(
              children: [
                const Text('CNJ: '),
                Text(processoListagem.numeroCNJ),
              ],
            ),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible:
                      processoListagem.ultimaMovimentacaoDescricao.isNotEmpty,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        'Última movimentação: ${processoListagem.ultimaMovimentacaoDescricao}',
                      ),
                      Text(
                        'Data: ${processoListagem.ultimaMovimentacaoData}',
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: processoListagem.demandante.isNotEmpty,
                  child: Text('Ativo: ${processoListagem.demandante}'),
                ),
                Visibility(
                  visible: processoListagem.demandado.isNotEmpty,
                  child: Text(
                    'Passivo: ${processoListagem.demandado}',
                  ),
                ),
                Visibility(
                  visible: processoListagem.ultimaMovimentacaoDescricao.isEmpty,
                  child: Row(
                    children: [
                      const Text('Última movimentação: '),
                      Text(processoListagem.dataUltimaMovimentacao),
                    ],
                  ),
                ),
              ],
            ),
            onTap: () {
              Modular.to.pushNamed(
                '/sistema/processos/detalhe/${processoListagem.codigo}',
              );
            },
          ),
        ],
      ),
    );
  }
}
