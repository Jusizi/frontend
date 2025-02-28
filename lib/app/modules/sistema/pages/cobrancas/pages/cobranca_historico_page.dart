import 'package:flutter/material.dart';

import '../../../../../designSystem/layout/drawermenuComponent.dart';
import '../../../../../models/cobranca_model.dart';
import '../../../../../models/evento_model.dart';

class CobrancaHistoricoPage extends StatefulWidget {
  late CobrancaModel cobranca;

  CobrancaHistoricoPage({
    super.key,
    required this.cobranca,
  });

  @override
  State<CobrancaHistoricoPage> createState() => CobrancaHistoricoPageState();
}

class CobrancaHistoricoPageState extends State<CobrancaHistoricoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: GlobalKey(),
      appBar: AppBar(
        title: Text('Histórico de eventos de ${widget.cobranca.descricao}'),
      ),
      drawer: drawerORleading(),
      body: ListView.builder(
        itemCount: widget.cobranca.eventos.length,
        itemBuilder: (context, index) {
          Evento evento = widget.cobranca.eventos[index];

          return ListTile(
            title: Text(evento.descricao),
            subtitle: Text(evento.momento),
          );
        },
      ),
    );
  }
}
