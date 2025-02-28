import 'dart:convert';

class CaixaMovimentacaoNovaModel {
  int planoDeContaCodigo;
  String contaBancariaCodigo;
  double valor;
  String descricao;
  String dataMovimentacao;
  CaixaMovimentacaoNovaModel({
    required this.planoDeContaCodigo,
    required this.contaBancariaCodigo,
    required this.valor,
    required this.descricao,
    required this.dataMovimentacao,
  });

  CaixaMovimentacaoNovaModel copyWith({
    int? planoDeContaCodigo,
    String? contaBancariaCodigo,
    double? valor,
    String? descricao,
    String? dataMovimentacao,
  }) {
    return CaixaMovimentacaoNovaModel(
      planoDeContaCodigo: planoDeContaCodigo ?? this.planoDeContaCodigo,
      contaBancariaCodigo: contaBancariaCodigo ?? this.contaBancariaCodigo,
      valor: valor ?? this.valor,
      descricao: descricao ?? this.descricao,
      dataMovimentacao: dataMovimentacao ?? this.dataMovimentacao,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'planoDeContaCodigo': planoDeContaCodigo,
      'contaBancariaCodigo': contaBancariaCodigo,
      'valor': valor,
      'descricao': descricao,
      'dataMovimentacao': dataMovimentacao,
    };
  }

  factory CaixaMovimentacaoNovaModel.fromMap(Map<String, dynamic> map) {
    return CaixaMovimentacaoNovaModel(
      planoDeContaCodigo: map['planoDeContaCodigo']?.toInt() ?? 0,
      contaBancariaCodigo: map['contaBancariaCodigo'] ?? '',
      valor: map['valor']?.toDouble() ?? 0.0,
      descricao: map['descricao'] ?? '',
      dataMovimentacao: map['dataMovimentacao'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CaixaMovimentacaoNovaModel.fromJson(String source) =>
      CaixaMovimentacaoNovaModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CaixaMovimentacaoNovaModel(planoDeContaCodigo: $planoDeContaCodigo, contaBancariaCodigo: $contaBancariaCodigo, valor: $valor, descricao: $descricao, dataMovimentacao: $dataMovimentacao)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CaixaMovimentacaoNovaModel &&
        other.planoDeContaCodigo == planoDeContaCodigo &&
        other.contaBancariaCodigo == contaBancariaCodigo &&
        other.valor == valor &&
        other.descricao == descricao &&
        other.dataMovimentacao == dataMovimentacao;
  }

  @override
  int get hashCode {
    return planoDeContaCodigo.hashCode ^
        contaBancariaCodigo.hashCode ^
        valor.hashCode ^
        descricao.hashCode ^
        dataMovimentacao.hashCode;
  }
}
