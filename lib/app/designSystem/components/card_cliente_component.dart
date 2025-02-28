import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../models/cliente_listagem_model.dart';

class CardClienteComponent extends StatelessWidget {
  final ClienteListagemModel cliente;
  const CardClienteComponent({
    super.key,
    required this.cliente,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.person_2),
            ),
            title: Text(cliente.nomeCompleto),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                cliente.documento.isEmpty
                    ? Container()
                    : Text(cliente.documento),
                cliente.whatsapp.isEmpty ? Container() : Text(cliente.whatsapp)
              ],
            ),
            onTap: () {
              Modular.to.pushNamed(
                '/sistema/clientes/detalhes/${cliente.codigo}',
              );
            },
          ),
        ],
      ),
    );
  }
}
