import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:searchable_listview/searchable_listview.dart';

import '../../../../../designSystem/components/card_cobranca_component.dart';
import '../../../../../designSystem/layout/drawermenuComponent.dart';
import '../../../../../models/cobranca_listagem_model.dart';
import '../cobrancas_store.dart';

class CobrancasPage extends StatefulWidget {
  const CobrancasPage({super.key});

  @override
  State<CobrancasPage> createState() => _CobrancasPageState();
}

class _CobrancasPageState extends State<CobrancasPage> {
  late CobrancasStore cobrancasStore;

  @override
  void initState() {
    super.initState();
    cobrancasStore = Modular.get<CobrancasStore>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: GlobalKey(),
      appBar: AppBar(
        title: const Text('Todas as Cobranças'),
        actions: [
          TextButton(
            onPressed: cobrancasStore.buscarTodasAsCobrancas,
            child: const Icon(Icons.refresh),
          ),
        ],
      ),
      drawer: drawerORleading(),
      body: ScopedBuilder(
        store: cobrancasStore,
        onLoading: (_) => const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
        onError: (context, error) => Center(
          child: Text(error.toString()),
        ),
        onState: (_, List<CobrancaListagemModel> listaCobrancas) {
          if (listaCobrancas.isEmpty) {
            return const Center(
              child: Text('Nenhuma cobrança encontrada'),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(10),
            child: SearchableList<CobrancaListagemModel>(
              sortWidget: const Icon(Icons.sort),
              sortPredicate: (a, b) =>
                  a.dataVencimento.compareTo(b.dataVencimento),
              itemBuilder: (CobrancaListagemModel cobrancaListagem) {
                return CardCobrancaComponent(
                    cobrancaListagem: cobrancaListagem);
              },
              initialList: listaCobrancas,
              filter: (p0) {
                return listaCobrancas
                    .where((element) => (element.dataVencimento
                            .toLowerCase()
                            .contains(p0.toLowerCase()) ||
                        element.descricao
                            .toLowerCase()
                            .contains(p0.toLowerCase()) ||
                        element.pagadorNomeCompleto
                            .toLowerCase()
                            .contains(p0.toLowerCase()) ||
                        element.valor
                            .toString()
                            .toLowerCase()
                            .contains(p0.toLowerCase())))
                    .toList();
              },
              inputDecoration: InputDecoration(
                labelText: "Pesquisar Cobrança",
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              closeKeyboardWhenScrolling: true,
            ),
          );

          /*
          return ListView.builder(
            key: GlobalKey(),
            itemCount: state.length,
            itemBuilder: (_, index) {
              final CobrancaListagemModel cobrancaListagem = state[index];
              return CardCobrancaComponent(cobrancaListagem: cobrancaListagem);
            },
          );
          */
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Modular.to.pushNamed('/sistema/cobranca/nova');
        },
        child: const FaIcon(FontAwesomeIcons.brazilianRealSign),
      ),
    );
  }
}
