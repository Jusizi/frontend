import 'package:flutter/material.dart';

import '../../../../designSystem/layout/drawermenuComponent.dart';
import '../../../../models/cliente_model.dart';
import '../../../../models/evento_model.dart';

class ClientesHistoricoPage extends StatefulWidget {
  late ClienteModel cliente;

  ClientesHistoricoPage({
    super.key,
    required this.cliente,
  });

  @override
  State<ClientesHistoricoPage> createState() => ClientesHistoricoPageState();
}

class ClientesHistoricoPageState extends State<ClientesHistoricoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: GlobalKey(),
      appBar: AppBar(
        title: Text('Histórico de eventos de ${widget.cliente.nomeCompleto}'),
      ),
      drawer: drawerORleading(),
      body: ListView.builder(
        itemCount: widget.cliente.eventos.length,
        itemBuilder: (context, index) {
          Evento evento = widget.cliente.eventos[index];

          return ListTile(
            title: Text(evento.descricao),
            subtitle: Text(evento.momento),
          );
        },
      ),
    );
  }
}
