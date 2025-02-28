import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../../designSystem/components/selecionar_plano_de_contas_component.dart';
import '../../../../../designSystem/layout/drawermenuComponent.dart';
import '../../../../../designSystem/snackbar_component.dart';
import '../../../../../models/caixa_movimentacao_nova_model.dart';
import '../../../../../models/conta_bancaria_model.dart';
import '../../../../../models/plano_de_conta_model.dart';
import '../../../../../shared/either.dart';
import '../caixamovimentacoes_store.dart';

class CaixaMovimentacoesContaNovaPage extends StatefulWidget {
  final ContaBancariaModel contaBancaria;
  const CaixaMovimentacoesContaNovaPage({
    super.key,
    required this.contaBancaria,
  });

  @override
  State<CaixaMovimentacoesContaNovaPage> createState() =>
      _CaixaMovimentacoesContaNovaPageState();
}

class _CaixaMovimentacoesContaNovaPageState
    extends State<CaixaMovimentacoesContaNovaPage> {
  late final CaixamovimentacoesStore caixamovimentacoesStore;

  final TextEditingController descricaoController = TextEditingController();
  final TextEditingController valorController = TextEditingController();
  final TextEditingController planoDeContasController = TextEditingController();
  bool aguardeSalvando = false;

  @override
  void initState() {
    super.initState();
    caixamovimentacoesStore = Modular.get<CaixamovimentacoesStore>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: GlobalKey(),
      appBar: AppBar(
        title: Text(
            'Lançar uma nova movimentação na conta ${widget.contaBancaria.nome}'),
      ),
      drawer: drawerORleading(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SelecionarPlanoDeContasComponent(
              onPressedSelect: (PlanoDeContaModel planoDeConta) {
                planoDeContasController.text = planoDeConta.codigo.toString();
              },
            ),
            TextField(
              controller: descricaoController,
              decoration: const InputDecoration(labelText: 'Descrição'),
            ),
            TextField(
              controller: valorController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: const [],
              decoration: const InputDecoration(
                labelText: 'Valor',
              ),
            ),
            Visibility(
              visible: aguardeSalvando,
              child: const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            ),
            Visibility(
              visible: !aguardeSalvando,
              child: ElevatedButton(
                onPressed: () async {
                  setState(() {
                    aguardeSalvando = true;
                  });

                  if (planoDeContasController.text.isEmpty) {
                    SnackBarComponent()
                        .showError('Selecione um plano de contas');
                    setState(() {
                      aguardeSalvando = false;
                    });
                    return;
                  }

                  if (descricaoController.text.isEmpty) {
                    SnackBarComponent().showError('Informe a descrição');
                    setState(() {
                      aguardeSalvando = false;
                    });
                    return;
                  }

                  if (valorController.text.isEmpty) {
                    SnackBarComponent().showError('Informe o valor');
                    setState(() {
                      aguardeSalvando = false;
                    });
                    return;
                  }

                  if (double.tryParse(valorController.text) == null) {
                    SnackBarComponent().showError('Valor inválido');
                    setState(() {
                      aguardeSalvando = false;
                    });
                    return;
                  }

                  final Either<String, bool> resposta =
                      await caixamovimentacoesStore.lancarMovimentacao(
                    CaixaMovimentacaoNovaModel(
                      planoDeContaCodigo:
                          int.parse(planoDeContasController.text),
                      contaBancariaCodigo: widget.contaBancaria.id,
                      dataMovimentacao: DateTime.now().toString(),
                      descricao: descricaoController.text,
                      valor: double.parse(valorController.text),
                    ),
                  );

                  setState(() {
                    aguardeSalvando = false;
                  });
                  resposta.fold((l) {
                    SnackBarComponent().showError(l);
                  }, (r) {
                    SnackBarComponent()
                        .showSuccess('Movimentação lançada com sucesso');
                    caixamovimentacoesStore.getMovimentacoesDaContaBancaria(
                        widget.contaBancaria.id);
                    Modular.to.pop();
                  });
                },
                child: const Text('Nova movimentação'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
