import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../models/contrato_listagem_model.dart';

class CardContratoComponent extends StatelessWidget {
  final ContratoListagemModel contratoListagem;
  const CardContratoComponent({
    super.key,
    required this.contratoListagem,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Row(
              children: [
                const Text('Status: '),
                Text(contratoListagem.status),
              ],
            ),
            onTap: () {
              Modular.to.pushNamed(
                '/sistema/contratos/detalhe/${contratoListagem.codigo}',
              );
            },
          ),
        ],
      ),
    );
  }
}
