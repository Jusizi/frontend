import 'package:flutter/material.dart';

import '../../../../../designSystem/layout/drawermenuComponent.dart';
import '../../../../../models/conta_bancaria_model.dart';
import '../../../../../models/evento_model.dart';

class ContabancariaHistoricoPage extends StatefulWidget {
  final ContaBancariaModel contaBancaria;
  const ContabancariaHistoricoPage({
    super.key,
    required this.contaBancaria,
  });

  @override
  State<ContabancariaHistoricoPage> createState() =>
      _ContabancariaHistoricoPageState();
}

class _ContabancariaHistoricoPageState
    extends State<ContabancariaHistoricoPage> {
  int indiceInvertido = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: GlobalKey(),
      appBar: AppBar(
        title: Text(
            "Histórico de alterações da conta ${widget.contaBancaria.nome}"),
      ),
      drawer: drawerORleading(),
      body: ListView.builder(
        itemCount: widget.contaBancaria.eventos.length,
        itemBuilder: (context, index) {
          Evento evento = widget.contaBancaria.eventos[index];

          indiceInvertido =
              widget.contaBancaria.eventos.length - (index + 1) + 1;

          return ListTile(
            title: Text("$indiceInvertido ${evento.descricao}"),
            trailing: Text(evento.momento),
          );
        },
      ),
    );
  }
}
