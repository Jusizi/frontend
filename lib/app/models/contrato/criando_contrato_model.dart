import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:appjusizi/app/models/cobranca_model.dart';
import 'package:appjusizi/app/models/meio_de_pagamento.dart';

class CriandoContratoModel {
  String contaBancariaCodigo;
  String clienteCodigo;

  DateTime dataVencimento;
  double valorJuros;
  double valorMulta;

  MeioDePagamento meioDePagamento;

  List<CobrancaModel> cobrancas;
  CriandoContratoModel({
    required this.contaBancariaCodigo,
    required this.clienteCodigo,
    required this.dataVencimento,
    required this.valorJuros,
    required this.valorMulta,
    required this.meioDePagamento,
    required this.cobrancas,
  });

  CriandoContratoModel copyWith({
    String? contaBancariaCodigo,
    String? clienteCodigo,
    DateTime? dataVencimento,
    double? valorJuros,
    double? valorMulta,
    MeioDePagamento? meioDePagamento,
    List<CobrancaModel>? cobrancas,
  }) {
    return CriandoContratoModel(
      contaBancariaCodigo: contaBancariaCodigo ?? this.contaBancariaCodigo,
      clienteCodigo: clienteCodigo ?? this.clienteCodigo,
      dataVencimento: dataVencimento ?? this.dataVencimento,
      valorJuros: valorJuros ?? this.valorJuros,
      valorMulta: valorMulta ?? this.valorMulta,
      meioDePagamento: meioDePagamento ?? this.meioDePagamento,
      cobrancas: cobrancas ?? this.cobrancas,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "contaBancariaCodigo": contaBancariaCodigo,
      "clienteCodigo": clienteCodigo,
      "meioPagamento": meioDePagamento.name,
      "diaVencimento": dataVencimento.day,
      "diaEmissaoCobranca": dataVencimento.day - 5,
      "horarioEmissaoCobranca":
          '${dataVencimento.hour}:${dataVencimento.minute}',
      "parcela": 1,
      "tipoJuros": "PERCENTUAL",
      "tipoMulta": "PERCENTUAL",
      "tipoDescontoAntecipacao": "valor",
      "multa": valorMulta,
      "juros": valorJuros,
    };
  }

  factory CriandoContratoModel.fromMap(Map<String, dynamic> map) {
    return CriandoContratoModel(
      contaBancariaCodigo: map['contaBancariaCodigo'] ?? '',
      clienteCodigo: map['clienteCodigo'] ?? '',
      dataVencimento:
          DateTime.fromMillisecondsSinceEpoch(map['dataVencimento']),
      valorJuros: map['valorJuros']?.toDouble() ?? 0.0,
      valorMulta: map['valorMulta']?.toDouble() ?? 0.0,
      meioDePagamento: MeioDePagamento.values.firstWhere(
          (MeioDePagamento meioDePagamento) =>
              meioDePagamento.name == map['meioDePagamento'].toUpperCase()),
      cobrancas: List<CobrancaModel>.from(
          map['cobrancas']?.map((x) => CobrancaModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory CriandoContratoModel.fromJson(String source) =>
      CriandoContratoModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CriandoContratoModel(contaBancariaCodigo: $contaBancariaCodigo, clienteCodigo: $clienteCodigo, dataVencimento: $dataVencimento, valorJuros: $valorJuros, valorMulta: $valorMulta, meioDePagamento: $meioDePagamento, cobrancas: $cobrancas)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CriandoContratoModel &&
        other.contaBancariaCodigo == contaBancariaCodigo &&
        other.clienteCodigo == clienteCodigo &&
        other.dataVencimento == dataVencimento &&
        other.valorJuros == valorJuros &&
        other.valorMulta == valorMulta &&
        other.meioDePagamento == meioDePagamento &&
        listEquals(other.cobrancas, cobrancas);
  }

  @override
  int get hashCode {
    return contaBancariaCodigo.hashCode ^
        clienteCodigo.hashCode ^
        dataVencimento.hashCode ^
        valorJuros.hashCode ^
        valorMulta.hashCode ^
        meioDePagamento.hashCode ^
        cobrancas.hashCode;
  }
}
