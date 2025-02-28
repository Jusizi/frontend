import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:intl/intl.dart';

import '../../../../../designSystem/components/selecionar_cliente_component.dart';
import '../../../../../designSystem/components/selecionar_contabancaria_component.dart';
import '../../../../../designSystem/layout/drawermenuComponent.dart';
import '../../../../../designSystem/snackbar_component.dart';
import '../../../../../models/cliente_listagem_model.dart';
import '../../../../../models/conta_bancaria_model.dart';
import '../../../../../models/meio_de_pagamento.dart';
import '../../../../../repositories/cobrancas/cobrancas_repository.dart';
import '../../../../../shared/either.dart';
import '../cobranca_formulario_store.dart';
import '../cobrancas_store.dart';
import 'widgets/composicao_da_cobranca.dart';

class CobrancaNovaPage extends StatefulWidget {
  const CobrancaNovaPage({super.key});

  @override
  State<CobrancaNovaPage> createState() => _CobrancaNovaPageState();
}

class _CobrancaNovaPageState extends State<CobrancaNovaPage> {
  late CobrancaFormularioStore cobrancaFormularioStore;
  late CobrancasStore cobrancasStore;

  @override
  void initState() {
    super.initState();

    cobrancaFormularioStore =
        CobrancaFormularioStore(Modular.get<CobrancasRepository>());
    cobrancasStore = Modular.get<CobrancasStore>();

    /*if (isTest) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        cobrancaFormularioStore.descricaoController.text = 'Cobrança de teste';
        cobrancaFormularioStore.dataVencimentoController.text =
            DateFormat('yyyy-MM-dd')
                .format(DateTime.now().add(const Duration(days: 10)));

        ItemComposicaoDaCobranca item = ItemComposicaoDaCobranca(
          descricao: 'Item de teste',
          valor: 100,
          planoDeConta: Modular.get<PlanoDeContasStore>()
              .planodecontas
              .first
              .planosDeConta
              .first,
        );
        cobrancaFormularioStore.adicionarItemComposicaoDaCobranca(item);

        cobrancaFormularioStore
            .selecionarCliente(Modular.get<ClientesStore>().clientes.first);

        print(
            "O cliente selecionado foi: ${cobrancaFormularioStore.clienteSelecionado!.nomeCompleto}");

        cobrancaFormularioStore.selecionarContaBancaria(
          Modular.get<ContasBancariasStore>().contasbancarias.first,
        );

        cobrancaFormularioStore.valorTotalDaCobranca();
      });
    }*/
  }

  Widget _buildError(Exception state) {
    return Center(
      child: Column(
        children: [
          Text(state.toString()),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator.adaptive());
  }

  Widget _buildSuccess(state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SelecionarContaBancariaComponent(
          onPressedSelect: (ContaBancariaModel? contaBancaria) {
            cobrancaFormularioStore.selecionarContaBancaria(contaBancaria!);
          },
        ),
        const SizedBox(height: 20),
        SelecionarClienteComponent(
          onPressedSelect: (ClienteListagemModel? cliente) {
            cobrancaFormularioStore.selecionarCliente(cliente!);
          },
        ),
        const SizedBox(height: 20),
        TextField(
          controller: cobrancaFormularioStore.descricaoController,
          decoration: InputDecoration(
            labelText: 'Descrição',
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Colors.grey[200],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: cobrancaFormularioStore.dataVencimentoController,
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
                    currentDate: DateTime.now().add(const Duration(days: 10)),
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
                  cobrancaFormularioStore.selecionarMeioDePagamento(newValue);
                }
              },
              value: cobrancaFormularioStore.meioDePagamento,
              items: [
                for (MeioDePagamento meioDePagamento in MeioDePagamento.values)
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
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                        content:
                            const Text('Deseja realmente lançar a cobrança?'),
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
                              lancarACobranca();
                            },
                            label: const Text('Lançar'),
                            icon: const Icon(Icons.check_circle_outline),
                          ),
                        ],
                      );
                    });
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Lançar Cobrança'),
            ),
          ),
        ),
        Visibility(
          visible: cobrancaFormularioStore.aguardandoLancarCobranca,
          child: const CircularProgressIndicator.adaptive(),
        ),
      ],
    );
  }

  Future<void> lancarACobranca() async {
    if (cobrancaFormularioStore.valorTotalCobranca <= 0) {
      SnackBarComponent()
          .showError('Não é possível lançar uma cobrança de R\$ 0,00');
      return;
    }
    final Either<String, String> resposta =
        await cobrancaFormularioStore.vamosTentarLancarCobranca();
    resposta.fold(
      (erro) {
        SnackBarComponent().showError(erro);
      },
      (sucesso) {
        SnackBarComponent().showSuccess(sucesso);
        cobrancasStore.buscarTodasAsCobrancas();
        Modular.to.pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: GlobalKey(),
      appBar: AppBar(
        title: const Text('Lançando uma nova cobrança'),
      ),
      drawer: drawerORleading(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ScopedBuilder<CobrancaFormularioStore, int>(
            store: cobrancaFormularioStore,
            onError: (context, erro) => _buildError(erro!),
            onLoading: (context) => _buildLoading(),
            onState: (context, state) => _buildSuccess(state),
          ),
        ),
      ),
    );
  }
}
