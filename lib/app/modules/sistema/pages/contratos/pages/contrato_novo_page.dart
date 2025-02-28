import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

import '../../../../../designSystem/components/selecionar_cliente_component.dart';
import '../../../../../designSystem/components/selecionar_contabancaria_component.dart';
import '../../../../../designSystem/layout/drawermenuComponent.dart';
import '../../../../../models/cliente_listagem_model.dart';
import '../../../../../models/conta_bancaria_model.dart';
import '../../../../../models/meio_de_pagamento.dart';
import '../../../../../repositories/cobrancas/cobrancas_repository.dart';
import '../../cobrancas/cobranca_formulario_store.dart';
import '../../cobrancas/pages/widgets/composicao_da_cobranca.dart';
import '../contratos_store.dart';

class ContratoNovoPage extends StatefulWidget {
  const ContratoNovoPage({super.key});

  @override
  State<ContratoNovoPage> createState() => _ContratoNovoPageState();
}

class _ContratoNovoPageState extends State<ContratoNovoPage> {
  late ContratosStore contratosStore;

  ContaBancariaModel? contaBancariaSelecionada;
  MeioDePagamento? meioDePagamentoSelecionado;
  ClienteListagemModel? clienteSelecionado;

  late CobrancaFormularioStore cobrancaFormularioStore;

  @override
  void initState() {
    super.initState();

    cobrancaFormularioStore = CobrancaFormularioStore(
      Modular.get<CobrancasRepository>(),
    );

    contratosStore = Modular.get<ContratosStore>();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: GlobalKey(),
      appBar: AppBar(
        title: const Text("Criando um novo contrato"),
        actions: [
          IconButton(
            onPressed: contratosStore.getContratos,
            icon: const Icon(Icons.sync_outlined),
          ),
        ],
      ),
      drawer: drawerORleading(),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SelecionarContaBancariaComponent(
              onPressedSelect: (ContaBancariaModel? contaBancaria) {
                contaBancariaSelecionada = contaBancaria;
              },
            ),
            const SizedBox(height: 20),
            SelecionarClienteComponent(
              onPressedSelect: (ClienteListagemModel? cliente) {
                clienteSelecionado = cliente;
              },
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller:
                        cobrancaFormularioStore.dataVencimentoController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Vencimento da cobrança',
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                        firstDate: DateTime.now(),
                        initialDate: DateTime.now(),
                        currentDate:
                            DateTime.now().add(const Duration(days: 10)),
                        locale: const Locale('pt', 'BR'),
                      );

                      if (pickedDate == null) return;
                      cobrancaFormularioStore.dataVencimentoController.text =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                    },
                    keyboardType: TextInputType.datetime,
                  ),
                ),
                const SizedBox(width: 20),
                DropdownButton<MeioDePagamento>(
                  hint: const Text('Meio de Pagamento'),
                  disabledHint: const Text('BOLETO'),
                  onChanged: (MeioDePagamento? newValue) {
                    if (newValue != null) {
                      meioDePagamentoSelecionado = newValue;
                    }
                  },
                  value: meioDePagamentoSelecionado,
                  items: [
                    for (MeioDePagamento meioDePagamento
                        in MeioDePagamento.values)
                      DropdownMenuItem(
                        value: meioDePagamento,
                        child: Text(meioDePagamento.name),
                      )
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: cobrancaFormularioStore.jurosController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d{0,1}(\.\d{0,1})?$')),
                      TextInputFormatter.withFunction(
                        (oldValue, newValue) {
                          // Verifica se o valor inserido está no intervalo 0 - 1
                          final value = double.tryParse(newValue.text);
                          if (value != null && value <= 1) {
                            return newValue;
                          }
                          return oldValue; // Retorna o valor antigo se estiver fora do limite
                        },
                      ),
                    ],
                    decoration: InputDecoration(
                      labelText: 'Juros %',
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: TextField(
                    controller: cobrancaFormularioStore.multaController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d{0,10}(\.\d{0,10})?$')),
                      TextInputFormatter.withFunction(
                        (oldValue, newValue) {
                          // Verifica se o valor inserido está no intervalo 0 - 10
                          final value = double.tryParse(newValue.text);
                          if (value != null && value <= 10) {
                            return newValue;
                          }
                          return oldValue; // Retorna o valor antigo se estiver fora do limite
                        },
                      ),
                    ],
                    decoration: InputDecoration(
                      labelText: 'Multa %',
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            ComposicaoDaCobranca(
              cobrancaFormularioStore: cobrancaFormularioStore,
              itensComposicaoDaCobranca:
                  cobrancaFormularioStore.itensComposicaoDaCobranca,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Valor total da cobrança: R\$ ${cobrancaFormularioStore.valorTotalCobranca}",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: DropdownButton<int>(
                    value: cobrancaFormularioStore.parcelasSelecionadas,
                    menuMaxHeight: 300,
                    icon: const Icon(Icons.arrow_drop_down),
                    items: cobrancaFormularioStore.opcoesParcelas
                        .map((Parcela parcela) {
                      return DropdownMenuItem<int>(
                        value: parcela.numero,
                        child: Text(
                          parcela.valorFormatado,
                          style: const TextStyle(fontSize: 16),
                        ),
                      );
                    }).toList(),
                    onChanged: (int? novoValor) =>
                        cobrancaFormularioStore.selecionarParcelas(novoValor!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Visibility(
              visible: !cobrancaFormularioStore.aguardandoLancarCobranca &&
                  cobrancaFormularioStore.valorTotalCobranca > 0,
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog.adaptive(
                            title: const Text('Confirmação'),
                            content: const Text(
                                'Deseja realmente criar este contrato?'),
                            actions: [
                              TextButton.icon(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                label: const Text('Cancelar'),
                                icon: const Icon(Icons.cancel_outlined),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  Modular.to.pop();
                                  // lancarACobranca();
                                },
                                label: const Text('Criar'),
                                icon: const Icon(Icons.check_circle_outline),
                              ),
                            ],
                          );
                        });
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text('Criar Contrato'),
                ),
              ),
            ),
            Visibility(
              visible: cobrancaFormularioStore.aguardandoLancarCobranca,
              child: const CircularProgressIndicator.adaptive(),
            ),
          ],
        ),
      ),
    );
  }
}
