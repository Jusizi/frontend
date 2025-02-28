import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:searchable_listview/searchable_listview.dart';

import '../../../../../designSystem/components/card_processo_movimentacao_component.dart';
import '../../../../../designSystem/layout/drawermenuComponent.dart';
import '../../../../../models/movimentacao_model.dart';
import '../../../../../models/processo_model.dart';
import '../processos_store.dart';

class ProcessoMovimentacoesPage extends StatefulWidget {
  late ProcessoModel processo;
  ProcessoMovimentacoesPage({
    super.key,
    required this.processo,
  });

  @override
  State<ProcessoMovimentacoesPage> createState() =>
      _ProcessoMovimentacoesPageState();
}

class _ProcessoMovimentacoesPageState extends State<ProcessoMovimentacoesPage> {
  late ProcessosStore processoStore;

  @override
  void initState() {
    super.initState();
    processoStore = Modular.get<ProcessosStore>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: GlobalKey(),
      appBar: AppBar(
        title: Text("Movimentações do Processo - ${widget.processo.numeroCNJ}"),
      ),
      drawer: drawerORleading(),
      body: Column(
        children: [
          Visibility(
            visible: widget.processo.movimentacoes.isEmpty,
            child: const Center(
              child: Text("Nenhuma movimentação encontrada!"),
            ),
          ),
          Visibility(
              visible: widget.processo.movimentacoes.isNotEmpty,
              child: Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SearchableList<MovimentacaoModel>(
                    sortWidget: const Icon(Icons.sort),
                    sortPredicate: (a, b) => a.data.compareTo(b.data),
                    itemBuilder: (MovimentacaoModel movimentacao) {
                      return CardProcessoMovimentacaoComponent(
                          movimentacao: movimentacao);
                    },
                    initialList: widget.processo.movimentacoes,
                    filter: (p0) {
                      return widget.processo.movimentacoes
                          .where((element) => (element
                                  .classificacaoPreditaDescricao
                                  .contains(p0) ||
                              element.classificacaoPreditaHierarquia
                                  .contains(p0) ||
                              element.data.contains(p0) ||
                              element.conteudo.contains(p0) ||
                              element.fonteGrauFormatado.contains(p0) ||
                              element.processoCNJ.contains(p0)))
                          .toList();
                    },
                    inputDecoration: InputDecoration(
                      labelText: "Pesquisar Movimentação",
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    closeKeyboardWhenScrolling: true,
                  ),
                ),
              )
              /*ListView.builder(
              itemCount: widget.processo.movimentacoes.length,
              itemBuilder: (context, index) {
                MovimentacaoModel movimentacao =
                    widget.processo.movimentacoes[index];
                return CardProcessoMovimentacaoComponent(
                  movimentacao: movimentacao,
                );
              },
            ),
            */
              ),
        ],
      ),
    );
  }
}
