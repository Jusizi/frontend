import 'package:flutter/material.dart';

import '../../models/envolvido_model.dart';
import 'botao_consultar_ou_visualizar_cliente_component.dart';

class CardProcessoEnvolvidoComponent extends StatelessWidget {
  final EnvolvidoModel envolvido;
  const CardProcessoEnvolvidoComponent({
    super.key,
    required this.envolvido,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const CircleAvatar(
            child: Icon(Icons.person_2),
          ),
          title: Text(envolvido.nomeCompleto),
          subtitle: envolvido.documento.isEmpty
              ? null
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(envolvido.documento),
                    const SizedBox(width: 10),
                    BotaoConsultarOuVisualizarClienteComponent(
                      documento: envolvido.documento,
                    ),
                  ],
                ),
          trailing: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Tipo: ${envolvido.tipo}'),
              envolvido.oab.isNotEmpty ? Text(envolvido.oab) : const SizedBox(),
              envolvido.quantidadeDeProcessos > 0
                  ? Text('Processos: ${envolvido.quantidadeDeProcessos}')
                  : const SizedBox(),
            ],
          ),
        ),
      ],
    );
  }
}
