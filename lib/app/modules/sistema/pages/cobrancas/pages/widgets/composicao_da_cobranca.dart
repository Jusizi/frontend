import 'package:flutter/material.dart';

import '../../../../../../designSystem/components/card_item_composicao_cobranca_component.dart';
import '../../../../../../models/composicao_da_cobranca_model.dart';
import '../../cobranca_formulario_store.dart';
import 'adicionar_item_na_composicao_da_cobranca.dart';

class ComposicaoDaCobranca extends StatefulWidget {
  final List<ItemComposicaoDaCobranca> itensComposicaoDaCobranca;
  final CobrancaFormularioStore cobrancaFormularioStore;
  const ComposicaoDaCobranca({
    super.key,
    required this.itensComposicaoDaCobranca,
    required this.cobrancaFormularioStore,
  });

  @override
  State<ComposicaoDaCobranca> createState() => _ComposicaoDaCobrancaState();
}

class _ComposicaoDaCobrancaState extends State<ComposicaoDaCobranca> {
  adicionarItem() {
    showDialog(
        context: context,
        useSafeArea: true,
        builder: (context) {
          return AlertDialog.adaptive(
            alignment: Alignment.center,
            scrollable: true,
            content: AdicionarItemNaComposicaoDaCobranca(
              cobrancaFormularioStore: widget.cobrancaFormularioStore,
            ),
            actions: [
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                label: const Text('Cancelar'),
                icon: const Icon(Icons.cancel_outlined),
              ),
            ],
          );
        });

    /*
    showModalBottomSheet(
      context: context,
      enableDrag: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: .9,
          maxChildSize: .9,
          minChildSize: .9,
          //expand: true,
          builder: (context, scrollController) {
            return AdicionarItemNaComposicaoDaCobranca(
              cobrancaFormularioStore: widget.cobrancaFormularioStore,
            );
          },
        );
      },
    );
    */
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Composição da Cobrança', style: TextStyle(fontSize: 20)),
        Visibility(
          visible: widget.itensComposicaoDaCobranca.isEmpty,
          child: Column(
            children: [
              TextButton.icon(
                onPressed: adicionarItem,
                icon: const Icon(Icons.add),
                label: const Text('Adicionar item'),
              ),
            ],
          ),
        ),
        Visibility(
          visible: widget.itensComposicaoDaCobranca.isNotEmpty,
          child: Column(
            children: [
              SizedBox(
                height:
                    100 * widget.itensComposicaoDaCobranca.length.toDouble(),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.itensComposicaoDaCobranca.length,
                  itemBuilder: (context, index) {
                    final ItemComposicaoDaCobranca item =
                        widget.itensComposicaoDaCobranca[index];

                    return CardItemComposicaoCobrancaComponent(
                      item: item,
                      cobrancaFormularioStore: widget.cobrancaFormularioStore,
                    );
                  },
                ),
              ),
              TextButton.icon(
                onPressed: adicionarItem,
                icon: const Icon(Icons.add),
                label: const Text('Adicionar item'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
