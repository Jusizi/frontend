import 'dart:convert';

class CobrancaListagemModel {
  String codigo;
  String dataVencimento;
  String pagadorNomeCompleto;
  String descricao;
  String meioDePagamentoName;
  double valor;
  CobrancaListagemModel({
    required this.codigo,
    required this.dataVencimento,
    required this.pagadorNomeCompleto,
    required this.descricao,
    required this.meioDePagamentoName,
    required this.valor,
  });

  CobrancaListagemModel copyWith({
    String? codigo,
    String? dataVencimento,
    String? pagadorNomeCompleto,
    String? descricao,
    String? meioDePagamentoName,
    double? valor,
  }) {
    return CobrancaListagemModel(
      codigo: codigo ?? this.codigo,
      dataVencimento: dataVencimento ?? this.dataVencimento,
      pagadorNomeCompleto: pagadorNomeCompleto ?? this.pagadorNomeCompleto,
      descricao: descricao ?? this.descricao,
      meioDePagamentoName: meioDePagamentoName ?? this.meioDePagamentoName,
      valor: valor ?? this.valor,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'codigo': codigo,
      'dataVencimento': dataVencimento,
      'pagadorNomeCompleto': pagadorNomeCompleto,
      'descricao': descricao,
      'meioDePagamentoName': meioDePagamentoName,
      'valor': valor,
    };
  }

  factory CobrancaListagemModel.fromMap(Map<String, dynamic> map) {
    return CobrancaListagemModel(
      codigo: map['codigo'] ?? '',
      dataVencimento: map['dataVencimento'] ?? '',
      pagadorNomeCompleto: map['pagadorNomeCompleto'] ?? '',
      descricao: map['descricao'] ?? '',
      meioDePagamentoName: map['meioDePagamentoName'] ?? '',
      valor: map['valor']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory CobrancaListagemModel.fromJson(String source) =>
      CobrancaListagemModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CobrancaListagemModel(codigo: $codigo, dataVencimento: $dataVencimento, pagadorNomeCompleto: $pagadorNomeCompleto, descricao: $descricao, meioDePagamentoName: $meioDePagamentoName, valor: $valor)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CobrancaListagemModel &&
        other.codigo == codigo &&
        other.dataVencimento == dataVencimento &&
        other.pagadorNomeCompleto == pagadorNomeCompleto &&
        other.descricao == descricao &&
        other.meioDePagamentoName == meioDePagamentoName &&
        other.valor == valor;
  }

  @override
  int get hashCode {
    return codigo.hashCode ^
        dataVencimento.hashCode ^
        pagadorNomeCompleto.hashCode ^
        descricao.hashCode ^
        meioDePagamentoName.hashCode ^
        valor.hashCode;
  }
}
