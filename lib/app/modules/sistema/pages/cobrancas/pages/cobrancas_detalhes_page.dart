import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../../designSystem/components/card_boleto_component.dart';
import '../../../../../designSystem/components/card_cliente_component.dart';
import '../../../../../designSystem/components/card_conta_bancaria_component.dart';
import '../../../../../designSystem/layout/drawermenuComponent.dart';
import '../../../../../models/boleto_model.dart';
import '../../../../../models/cobranca_model.dart';
import '../../../../../models/composicao_da_cobranca_model.dart';
import '../../../../../shared/either.dart';
import '../cobrancas_store.dart';

class CobrancasDetalhesPage extends StatefulWidget {
  final String cobrancaCodigo;
  const CobrancasDetalhesPage({super.key, required this.cobrancaCodigo});

  @override
  State<CobrancasDetalhesPage> createState() => _CobrancasDetalhesPageState();
}

class _CobrancasDetalhesPageState extends State<CobrancasDetalhesPage> {
  late CobrancasStore cobrancasStore;
  String title = 'Detalhes da Cobrança';

  Future<void> buscarInformacoesDaCobrancaCodigo() async {
    Either<String, CobrancaModel> resultado =
        await cobrancasStore.buscarInformacoesDaCobranca(widget.cobrancaCodigo);

    resultado.fold((l) {
      title = 'Erro ao buscar detalhes da cobrança';
      cobrancaDetalhes = Center(
        child: Text(l),
      );
      setState(() {});
    }, (CobrancaModel cobrancaModel) {
      cobrancaDetalhes = SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Conta Bancária'),
              CardContaBancariaComponent(
                contaBancaria: cobrancaModel.contaBancaria,
                onTap: () => Modular.to.pushNamed(
                  '/sistema/contabancaria/detalhes/${cobrancaModel.contaBancaria.id}',
                ),
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Pagador'),
                  CardClienteComponent(cliente: cobrancaModel.pagador),
                  const SizedBox(height: 10),
                ],
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Vencimento da Cobrança'),
                              Text(cobrancaModel.dataVencimentoFormatada),
                            ],
                          ),
                          const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('Meio de Pagamento'),
                              Text(cobrancaModel.meioDePagamento.name),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Juros'),
                              Text('${cobrancaModel.juros}%'),
                            ],
                          ),
                          const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('Multa'),
                              Text('${cobrancaModel.multa}%'),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Parcela${cobrancaModel.parcelas > 1 ? 's' : ''}'),
                              Text(cobrancaModel.parcelas.toString()),
                            ],
                          ),
                          const Spacer(),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text('Descrição'),
                      Text(cobrancaModel.descricao),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: cobrancaModel.composicaoDaCobranca.isNotEmpty,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Composição da Cobrança'),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: cobrancaModel.composicaoDaCobranca.length,
                          itemBuilder: (_, index) {
                            final ItemComposicaoDaCobranca item =
                                cobrancaModel.composicaoDaCobranca[index];

                            return ListTile(
                              title: Text(item.planoDeConta.descricao),
                              subtitle: Text(item.descricao),
                              trailing: Text('R\$ ${item.valor}'),
                              dense: true,
                              contentPadding: const EdgeInsets.all(10),
                            );
                          },
                        ),
                        ListTile(
                          title: const Text('Total'),
                          trailing: Text(
                              'R\$ ${cobrancaModel.boletos.map((e) => e.valor).reduce((value, element) => value + element)}'),
                          dense: true,
                          contentPadding: const EdgeInsets.all(10),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: cobrancaModel.boletos.isNotEmpty,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Boletos ${cobrancaModel.boletos.length}'),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: cobrancaModel.boletos.length,
                      itemBuilder: (_, index) {
                        final BoletoModel boleto = cobrancaModel.boletos[index];

                        return CardBoletoComponent(boleto: boleto);
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    cobrancasStore = Modular.get<CobrancasStore>();
    buscarInformacoesDaCobrancaCodigo();
  }

  Widget cobrancaDetalhes = const Center(
    child: CircularProgressIndicator.adaptive(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: GlobalKey(),
      appBar: AppBar(
        title: Text(title),
        /*actions: [
          IconButton(
            tooltip: 'Histórico da cobrança',
            onPressed: () {
              Modular.to.pushNamed(
                '/sistema/cobranca/historico',
                arguments: widget.cobrancaCodigo,
              );
            },
            icon: const Icon(Icons.history_rounded),
          ),
        ],*/
      ),
      drawer: drawerORleading(),
      body: cobrancaDetalhes,
    );
  }
}
