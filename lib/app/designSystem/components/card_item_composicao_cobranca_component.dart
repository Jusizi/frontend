import 'package:flutter/material.dart';

import '../../models/composicao_da_cobranca_model.dart';
import '../../modules/sistema/pages/cobrancas/cobranca_formulario_store.dart';

class CardItemComposicaoCobrancaComponent extends StatefulWidget {
  final CobrancaFormularioStore cobrancaFormularioStore;
  final ItemComposicaoDaCobranca item;

  const CardItemComposicaoCobrancaComponent({
    super.key,
    required this.item,
    required this.cobrancaFormularioStore,
  });

  @override
  State<CardItemComposicaoCobrancaComponent> createState() =>
      _CardItemComposicaoCobrancaComponentState();
}

class _CardItemComposicaoCobrancaComponentState
    extends State<CardItemComposicaoCobrancaComponent> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.item.planoDeConta.nome),
      subtitle: Text(widget.item.descricao),
      trailing: Wrap(
        spacing: 12, // space between two icons
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text("R\$ ${widget.item.valor.toString()}"),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => widget.cobrancaFormularioStore
                .removerItemComposicaoDaCobranca(widget.item),
          ),
        ],
      ),
    );
  }
}
