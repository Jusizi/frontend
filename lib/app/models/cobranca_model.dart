import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../modules/sistema/pages/clientes/clientes_store.dart';
import '../modules/sistema/pages/contasbancarias/contasbancarias_store.dart';
import '../shared/either.dart';
import 'boleto_model.dart';
import 'cliente_listagem_model.dart';
import 'composicao_da_cobranca_model.dart';
import 'conta_bancaria_model.dart';
import 'evento_model.dart';
import 'meio_de_pagamento.dart';

class CobrancaModel {
  final String codigo;
  final String contaBancariaCodigo;
  final String clienteCodigo;
  final String descricao;
  final DateTime dataVencimento;
  final MeioDePagamento meioDePagamento;
  final double juros;
  final double multa;
  final int parcelas;
  final List<BoletoModel> boletos;
  final List<Evento> eventos;
  String dataVencimentoFormatada = '';
  late ClienteListagemModel pagador;
  late ContaBancariaModel contaBancaria;

  final List<ItemComposicaoDaCobranca> composicaoDaCobranca;

  CobrancaModel({
    required this.codigo,
    required this.contaBancariaCodigo,
    required this.clienteCodigo,
    required this.descricao,
    required this.dataVencimento,
    required this.boletos,
    required this.meioDePagamento,
    required this.eventos,
    required this.juros,
    required this.multa,
    required this.parcelas,
    this.composicaoDaCobranca = const [],
  }) {
    // dataVencimento == 'YYYY-MM-DD'
    // dataVencimentoFormatada == 'DD/MM/YYYY'
    dataVencimentoFormatada =
        '${dataVencimento.day.toString().padLeft(2, '0')}/${dataVencimento.month.toString().padLeft(2, '0')}/${dataVencimento.year}';

    if (Modular.get<ClientesStore>().clientes.isNotEmpty) {
      pagador = Modular.get<ClientesStore>().clientes.firstWhere(
            (ClienteListagemModel cliente) => cliente.codigo == clienteCodigo,
          );
    } else {
      Modular.get<ClientesStore>()
          .getClientes()
          .then((List<ClienteListagemModel> clientesListagem) {
        pagador = clientesListagem.firstWhere(
          (ClienteListagemModel cliente) => cliente.codigo == clienteCodigo,
        );
      });
    }

    if (Modular.get<ContasBancariasStore>().contasbancarias.isNotEmpty) {
      contaBancaria =
          Modular.get<ContasBancariasStore>().contasbancarias.firstWhere(
                (ContaBancariaModel contaBancaria) =>
                    contaBancaria.id == contaBancariaCodigo,
              );
    } else {
      Modular.get<ContasBancariasStore>()
          .getContasBancarias()
          .then((Either<String, List<ContaBancariaModel>> contasBancarias) {
        contaBancaria = contasBancarias.fold((l) {
          throw Exception(l);
        }, (r) {
          return r.firstWhere(
            (ContaBancariaModel contaBancaria) =>
                contaBancaria.id == contaBancariaCodigo,
          );
        });
      });
    }
  }

  Future<ContaBancariaModel> tryGetContaBancaria() async {
    final ContasBancariasStore contaBancariaStore =
        Modular.get<ContasBancariasStore>();
    final Either<String, ContaBancariaModel> resposta = await contaBancariaStore
        .buscarInformacoesDaContaBancariaPorCodigo(contaBancariaCodigo);

    return resposta.fold((l) {
      throw Exception(l);
    }, (ContaBancariaModel contaBancaria) {
      return contaBancaria;
    });
  }

  CobrancaModel copyWith({
    String? codigo,
    String? contaBancariaCodigo,
    String? clienteCodigo,
    String? descricao,
    DateTime? dataVencimento,
    double? juros,
    double? multa,
    int? parcelas,
    MeioDePagamento? meioDePagamento,
    List<BoletoModel>? boletos,
    List<Evento>? eventos,
    List<ItemComposicaoDaCobranca>? composicaoDaCobranca,
  }) {
    return CobrancaModel(
      codigo: codigo ?? this.codigo,
      contaBancariaCodigo: contaBancariaCodigo ?? this.contaBancariaCodigo,
      clienteCodigo: clienteCodigo ?? this.clienteCodigo,
      descricao: descricao ?? this.descricao,
      dataVencimento: dataVencimento ?? this.dataVencimento,
      juros: juros ?? this.juros,
      multa: multa ?? this.multa,
      parcelas: parcelas ?? this.parcelas,
      boletos: boletos ?? this.boletos,
      meioDePagamento: meioDePagamento ?? this.meioDePagamento,
      eventos: eventos ?? this.eventos,
      composicaoDaCobranca: composicaoDaCobranca ?? this.composicaoDaCobranca,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'codigo': codigo,
      'contaBancariaCodigo': contaBancariaCodigo,
      'clienteCodigo': clienteCodigo,
      'descricao': descricao,
      'juros': juros,
      'multa': multa,
      'parcelas': parcelas,
      'dataVencimento': dataVencimento,
      'boletos': boletos.map((x) => x.toMap()).toList(),
      'meioDePagamento': meioDePagamento.name,
      'eventos': eventos.map((x) => x.toMap()).toList(),
      'composicaoDaCobranca': composicaoDaCobranca.map((itemCobranca) {
        return ItemComposicaoDaCobranca(
          planoDeConta: itemCobranca.planoDeConta,
          descricao: itemCobranca.descricao,
          valor: itemCobranca.valor,
        );
      }).toList(),
    };
  }

  factory CobrancaModel.fromMap(Map<String, dynamic> map) {
    return CobrancaModel(
      codigo: map['codigo'] ?? '',
      contaBancariaCodigo: map['contaBancariaCodigo'] ?? '',
      clienteCodigo: map['clienteCodigo'] ?? '',
      descricao: map['mensagem'] ?? '',
      juros: double.parse((map['juros'] ?? '0').toString()),
      multa: double.parse((map['multa'] ?? '0').toString()),
      parcelas: int.parse((map['parcelas'] ?? '1').toString()),
      dataVencimento: DateTime.parse(map['dataVencimento'] ?? ''),
      meioDePagamento: MeioDePagamento.values.firstWhere(
          (MeioDePagamento meioDePagamento) =>
              meioDePagamento.name == map['meioDePagamento'].toUpperCase()),
      eventos: List<Evento>.from(
          map['eventos']?.map((x) => Evento.fromMap(x)) ?? []),
      boletos: List<BoletoModel>.from(
          map['boletos']?.map((x) => BoletoModel.fromMap(x))),
      composicaoDaCobranca: List<ItemComposicaoDaCobranca>.from(
          map['composicaoDaCobranca']
              ?.map((x) => ItemComposicaoDaCobranca.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory CobrancaModel.fromJson(String source) =>
      CobrancaModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CobrancaModel(codigo: $codigo, contaBancariaCodigo: $contaBancariaCodigo, clienteCodigo: $clienteCodigo, descricao: $descricao, boletos: $boletos)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CobrancaModel &&
        other.codigo == codigo &&
        other.contaBancariaCodigo == contaBancariaCodigo &&
        other.clienteCodigo == clienteCodigo &&
        other.descricao == descricao &&
        other.dataVencimento == dataVencimento &&
        other.eventos == eventos &&
        other.juros == juros &&
        other.multa == multa &&
        other.parcelas == parcelas &&
        other.meioDePagamento == meioDePagamento &&
        other.boletos == boletos &&
        other.composicaoDaCobranca == composicaoDaCobranca &&
        listEquals(other.boletos, boletos);
  }

  @override
  int get hashCode {
    return codigo.hashCode ^
        contaBancariaCodigo.hashCode ^
        clienteCodigo.hashCode ^
        descricao.hashCode ^
        eventos.hashCode ^
        dataVencimento.hashCode ^
        juros.hashCode ^
        multa.hashCode ^
        parcelas.hashCode ^
        meioDePagamento.hashCode ^
        composicaoDaCobranca.hashCode ^
        boletos.hashCode;
  }
}
