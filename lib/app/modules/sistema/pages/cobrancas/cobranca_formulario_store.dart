import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

import '../../../../models/cliente_listagem_model.dart';
import '../../../../models/cobranca_model.dart';
import '../../../../models/composicao_da_cobranca_model.dart';
import '../../../../models/conta_bancaria_model.dart';
import '../../../../models/meio_de_pagamento.dart';
import '../../../../repositories/cobrancas/cobrancas_repository.dart';
import '../../../../shared/either.dart';
import '../clientes/clientes_store.dart';
import '../contasbancarias/contasbancarias_store.dart';
import 'cobrancas_store.dart';

class Parcela {
  final int numero;
  final double valor;
  late String valorFormatado;

  Parcela({required this.numero, required this.valor}) {
    valorFormatado = '${numero}x de R\$ ${valor.toStringAsFixed(2)}';
  }
}

class CobrancaFormularioStore extends Store<int> {
  late final CobrancasRepository _cobrancasRepository;

  CobrancaFormularioStore(this._cobrancasRepository) : super(0) {
    inicioDeUmaNovaCobranca();
  }

  ClienteListagemModel? clienteSelecionado;
  ContaBancariaModel? contaBancariaSelecionado;
  TextEditingController descricaoController = TextEditingController();
  TextEditingController dataVencimentoController = TextEditingController();
  TextEditingController jurosController = TextEditingController();
  TextEditingController multaController = TextEditingController();
  MeioDePagamento meioDePagamento = MeioDePagamento.BOLETO;
  List<ItemComposicaoDaCobranca> itensComposicaoDaCobranca = [];
  bool aguardandoLancarCobranca = false;

  int parcelasSelecionadas = 1;
  final int quantidadeMaximaDeParcelas = 21;
  List<Parcela> opcoesParcelas = [];
  late CobrancasStore cobrancasStore;
  late ContasBancariasStore contasBancariasStore;
  late ClientesStore clientesStore;

  double valorTotalCobranca = 0;
  double valorTotalDaCobranca() {
    valorTotalCobranca = itensComposicaoDaCobranca.fold(
        0, (previousValue, element) => previousValue + element.valor);
    return valorTotalCobranca;
  }

  void selecionarParcelas(int parcela) {
    parcelasSelecionadas = parcela;
    refresh();
  }

  // Função para calcular as opções de parcelamento
  void _calcularParcelas() {
    List<Parcela> novasOpcoes = [];
    for (int i = 1; i <= quantidadeMaximaDeParcelas; i++) {
      double parcela = valorTotalDaCobranca() / i;
      novasOpcoes.add(Parcela(numero: i, valor: parcela));
    }
    opcoesParcelas = novasOpcoes;
    refresh();
  }

  void inicioDeUmaNovaCobranca() {
    cobrancasStore = Modular.get<CobrancasStore>();
    contasBancariasStore = Modular.get<ContasBancariasStore>();
    clientesStore = Modular.get<ClientesStore>();

    jurosController.text = '1'; // 1% ao mês
    multaController.text = '2'; // 2% ao mês
  }

  disposer() {
    descricaoController.dispose();
    dataVencimentoController.dispose();
    jurosController.dispose();
    multaController.dispose();
  }

  void selecionarCliente(ClienteListagemModel cliente) {
    clienteSelecionado = cliente;
    refresh();
  }

  void selecionarMeioDePagamento(MeioDePagamento meioDePagamento) {
    this.meioDePagamento = meioDePagamento;
    refresh();
  }

  void selecionarContaBancaria(ContaBancariaModel contaBancaria) {
    contaBancariaSelecionado = contaBancaria;
    refresh();
  }

  void adicionarItemComposicaoDaCobranca(ItemComposicaoDaCobranca item) {
    itensComposicaoDaCobranca.add(item);
    _calcularParcelas();
  }

  void removerItemComposicaoDaCobranca(ItemComposicaoDaCobranca item) {
    itensComposicaoDaCobranca.remove(item);
    _calcularParcelas();
  }

  void refresh() {
    update((Random()).nextInt(99999));
    valorTotalDaCobranca();
  }

  Future<Either<String, String>> vamosTentarLancarCobranca() async {
    if (parcelasSelecionadas == 0 || parcelasSelecionadas < 0) {
      return Left('Selecione a quantidade de parcelas');
    }

    if (parcelasSelecionadas > quantidadeMaximaDeParcelas) {
      return Left(
          'Quantidade de parcelas não pode ser maior que $quantidadeMaximaDeParcelas');
    }

    if (clienteSelecionado == null) {
      return Left('Selecione um cliente');
    }

    if (contaBancariaSelecionado == null) {
      return Left('Selecione uma conta bancária');
    }

    if (itensComposicaoDaCobranca.isEmpty) {
      return Left('Adicione ao menos um item de cobrança');
    }

    if (descricaoController.text.isEmpty) {
      return Left('Informe a descrição da cobrança');
    }

    if (dataVencimentoController.text.isEmpty) {
      return Left('Informe a data de vencimento da cobrança');
    }

    aguardandoLancarCobranca = true;

    double juros = 0;
    double multa = 0;
    int parcelas = parcelasSelecionadas;

    try {
      juros = double.parse(jurosController.text);
    } catch (e) {
      return Left('Juros deve ser um número');
    }

    try {
      multa = double.parse(multaController.text);
    } catch (e) {
      return Left('Multa deve ser um número');
    }

    if (juros < 0) {
      juros = 0;
    }

    if (multa < 0) {
      multa = 0;
    }

    if (juros > 1) {
      return Left('Juros não pode ser maior que 1%');
    }

    if (multa > 10) {
      return Left('Multa não pode ser maior que 10%');
    }

    refresh();

    final composicaoDaCobranca = CobrancaModel(
      codigo: '',
      clienteCodigo: clienteSelecionado!.codigo,
      contaBancariaCodigo: contaBancariaSelecionado!.id,
      composicaoDaCobranca: itensComposicaoDaCobranca,
      //planoDeConta: planoDeContaSelecionado!,
      descricao: descricaoController.text,
      dataVencimento: DateTime.parse(dataVencimentoController.text),
      meioDePagamento: meioDePagamento,
      juros: juros,
      multa: multa,
      parcelas: parcelas,
      boletos: [],
      eventos: [],
    );

    final result =
        await _cobrancasRepository.lancarCobranca(composicaoDaCobranca);

    aguardandoLancarCobranca = false;
    refresh();

    return result;
  }
}
