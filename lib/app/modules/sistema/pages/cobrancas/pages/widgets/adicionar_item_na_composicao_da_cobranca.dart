import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../../../designSystem/components/selecionar_plano_de_contas_component.dart';
import '../../../../../../models/composicao_da_cobranca_model.dart';
import '../../../../../../models/plano_de_conta_model.dart';
import '../../cobranca_formulario_store.dart';

class AdicionarItemNaComposicaoDaCobranca extends StatefulWidget {
  final CobrancaFormularioStore cobrancaFormularioStore;

  const AdicionarItemNaComposicaoDaCobranca({
    super.key,
    required this.cobrancaFormularioStore,
  });

  @override
  State<AdicionarItemNaComposicaoDaCobranca> createState() =>
      _AdicionarItemNaComposicaoDaCobrancaState();
}

class _AdicionarItemNaComposicaoDaCobrancaState
    extends State<AdicionarItemNaComposicaoDaCobranca> {
  TextEditingController descricaoController = TextEditingController();

  TextEditingController valorController = TextEditingController();

  PlanoDeContaModel? planoDeContaSelecionado;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SelecionarPlanoDeContasComponent(onPressedSelect: (planoDeConta) {
              setState(() {
                planoDeContaSelecionado = planoDeConta;
              });
            }),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Descrição',
              ),
              controller: descricaoController,
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Valor',
                    ),
                    controller: valorController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      TextInputFormatter.withFunction(
                        (oldValue, newValue) {
                          // Verifica se o valor inserido está > 0
                          final value = double.tryParse(newValue.text);
                          if (value != null && value >= 0) {
                            return newValue;
                          }
                          return oldValue; // Retorna o valor antigo se estiver fora do limite
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextButton.icon(
              label: const Text('Adicionar'),
              icon: const Icon(Icons.add),
              onPressed: () {
                ItemComposicaoDaCobranca item = ItemComposicaoDaCobranca(
                  planoDeConta: planoDeContaSelecionado!,
                  descricao: descricaoController.text,
                  valor: valorController.text.isNotEmpty
                      ? double.parse(
                          valorController.text.replaceFirst('R\$ ', ''))
                      : 0,
                );

                // PODE ser Zero sim, caso seja um desconto de 100%
                /*
                if (item.valor == 0) {
                  SnackBarComponent().showError(
                      context, "O valor do item da cobrança não pode ser 0");
                  return;
                }
                */

                // PODE ser negativo sim, caso seja um desconto
                /*
                if (item.valor < 0) {
                  SnackBarComponent().showError(context,
                      "O valor do item da cobrança não pode ser negativo");
                  return;
                }
                */

                widget.cobrancaFormularioStore
                    .adicionarItemComposicaoDaCobranca(item);

                Modular.to.pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
