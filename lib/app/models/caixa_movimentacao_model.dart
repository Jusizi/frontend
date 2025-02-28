import 'dart:convert';

import 'package:flutter/widgets.dart';

class CaixaMovimentacaoModel {
  String codigoMovimentacao;
  double valor;
  String descricao;
  String dataMovimentacao;
  int planoDeContaCodigo;
  String planoDeContaNome;
  String dataMovimentacaoAt;
  String? pagadorNomeCompleto;
  String? pagadorCodigo;
  String? pagadorDocumento;
  String? boletoCodigo;
  String? cobrancaCodigo;
  CaixaMovimentacaoModel({
    required this.codigoMovimentacao,
    required this.valor,
    required this.descricao,
    required this.dataMovimentacao,
    required this.planoDeContaCodigo,
    required this.planoDeContaNome,
    required this.dataMovimentacaoAt,
    this.pagadorNomeCompleto,
    this.pagadorCodigo,
    this.pagadorDocumento,
    this.boletoCodigo,
    this.cobrancaCodigo,
  });

  CaixaMovimentacaoModel copyWith({
    String? codigoMovimentacao,
    double? valor,
    String? descricao,
    String? dataMovimentacao,
    int? planoDeContaCodigo,
    String? planoDeContaNome,
    String? dataMovimentacaoAt,
    ValueGetter<String?>? pagadorNomeCompleto,
    ValueGetter<String?>? pagadorCodigo,
    ValueGetter<String?>? pagadorDocumento,
    ValueGetter<String?>? boletoCodigo,
    ValueGetter<String?>? cobrancaCodigo,
  }) {
    return CaixaMovimentacaoModel(
      codigoMovimentacao: codigoMovimentacao ?? this.codigoMovimentacao,
      valor: valor ?? this.valor,
      descricao: descricao ?? this.descricao,
      dataMovimentacao: dataMovimentacao ?? this.dataMovimentacao,
      planoDeContaCodigo: planoDeContaCodigo ?? this.planoDeContaCodigo,
      planoDeContaNome: planoDeContaNome ?? this.planoDeContaNome,
      dataMovimentacaoAt: dataMovimentacaoAt ?? this.dataMovimentacaoAt,
      pagadorNomeCompleto: pagadorNomeCompleto != null
          ? pagadorNomeCompleto()
          : this.pagadorNomeCompleto,
      pagadorCodigo:
          pagadorCodigo != null ? pagadorCodigo() : this.pagadorCodigo,
      pagadorDocumento:
          pagadorDocumento != null ? pagadorDocumento() : this.pagadorDocumento,
      boletoCodigo: boletoCodigo != null ? boletoCodigo() : this.boletoCodigo,
      cobrancaCodigo:
          cobrancaCodigo != null ? cobrancaCodigo() : this.cobrancaCodigo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'codigoMovimentacao': codigoMovimentacao,
      'valor': valor,
      'descricao': descricao,
      'dataMovimentacao': dataMovimentacao,
      'planoDeContaCodigo': planoDeContaCodigo,
      'planoDeContaNome': planoDeContaNome,
      'dataMovimentacaoAt': dataMovimentacaoAt,
      'pagadorNomeCompleto': pagadorNomeCompleto,
      'pagadorCodigo': pagadorCodigo,
      'pagadorDocumento': pagadorDocumento,
      'boletoCodigo': boletoCodigo,
      'cobrancaCodigo': cobrancaCodigo,
    };
  }

  factory CaixaMovimentacaoModel.fromMap(Map<String, dynamic> map) {
    return CaixaMovimentacaoModel(
      codigoMovimentacao: map['codigoMovimentacao'] ?? '',
      valor: map['valor']?.toDouble() ?? 0.0,
      descricao: map['descricao'] ?? '',
      dataMovimentacao: map['dataMovimentacao'] ?? '',
      planoDeContaCodigo: map['planoDeContaCodigo']?.toInt() ?? 0,
      planoDeContaNome: map['planoDeContaNome'] ?? '',
      dataMovimentacaoAt: map['dataMovimentacaoAt'] ?? '',
      pagadorNomeCompleto: map['pagadorNomeCompleto'],
      pagadorCodigo: map['pagadorCodigo'],
      pagadorDocumento: map['pagadorDocumento'],
      boletoCodigo: map['boletoCodigo'],
      cobrancaCodigo: map['cobrancaCodigo'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CaixaMovimentacaoModel.fromJson(String source) =>
      CaixaMovimentacaoModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CaixaMovimentacaoModel(codigoMovimentacao: $codigoMovimentacao, valor: $valor, descricao: $descricao, dataMovimentacao: $dataMovimentacao, planoDeContaCodigo: $planoDeContaCodigo, planoDeContaNome: $planoDeContaNome, dataMovimentacaoAt: $dataMovimentacaoAt, pagadorNomeCompleto: $pagadorNomeCompleto, pagadorCodigo: $pagadorCodigo, pagadorDocumento: $pagadorDocumento, boletoCodigo: $boletoCodigo, cobrancaCodigo: $cobrancaCodigo)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CaixaMovimentacaoModel &&
        other.codigoMovimentacao == codigoMovimentacao &&
        other.valor == valor &&
        other.descricao == descricao &&
        other.dataMovimentacao == dataMovimentacao &&
        other.planoDeContaCodigo == planoDeContaCodigo &&
        other.planoDeContaNome == planoDeContaNome &&
        other.dataMovimentacaoAt == dataMovimentacaoAt &&
        other.pagadorNomeCompleto == pagadorNomeCompleto &&
        other.pagadorCodigo == pagadorCodigo &&
        other.pagadorDocumento == pagadorDocumento &&
        other.boletoCodigo == boletoCodigo &&
        other.cobrancaCodigo == cobrancaCodigo;
  }

  @override
  int get hashCode {
    return codigoMovimentacao.hashCode ^
        valor.hashCode ^
        descricao.hashCode ^
        dataMovimentacao.hashCode ^
        planoDeContaCodigo.hashCode ^
        planoDeContaNome.hashCode ^
        dataMovimentacaoAt.hashCode ^
        pagadorNomeCompleto.hashCode ^
        pagadorCodigo.hashCode ^
        pagadorDocumento.hashCode ^
        boletoCodigo.hashCode ^
        cobrancaCodigo.hashCode;
  }
}
