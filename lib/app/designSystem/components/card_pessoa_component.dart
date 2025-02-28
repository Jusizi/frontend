import 'package:flutter/material.dart';

import 'botao_consultar_ou_visualizar_cliente_component.dart';

class CardPessoaComponent extends StatefulWidget {
  final String nomeCompleto;
  final String documento;
  final PAIS tipo;
  const CardPessoaComponent({
    super.key,
    required this.nomeCompleto,
    required this.documento,
    required this.tipo,
  });

  @override
  State<CardPessoaComponent> createState() => _CardPessoaComponentState();
}

class _CardPessoaComponentState extends State<CardPessoaComponent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            child: widget.tipo == PAIS.PAI
                ? const Icon(Icons.person_4_outlined)
                : const Icon(Icons.person_2_outlined),
          ),
          title: Text(widget.nomeCompleto),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.documento.isEmpty ? Container() : Text(widget.documento),
            ],
          ),
          trailing: BotaoConsultarOuVisualizarClienteComponent(
            documento: widget.documento,
          ),
        ),
      ],
    );
  }
}

enum PAIS { PAI, MAE }
