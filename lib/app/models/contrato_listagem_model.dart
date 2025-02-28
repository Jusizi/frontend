import 'dart:convert';

class ContratoListagemModel {
  String codigo;
  String status;
  ContratoListagemModel({
    required this.codigo,
    required this.status,
  });

  ContratoListagemModel copyWith({
    String? codigo,
    String? status,
  }) {
    return ContratoListagemModel(
      codigo: codigo ?? this.codigo,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'codigo': codigo,
      'status': status,
    };
  }

  factory ContratoListagemModel.fromMap(Map<String, dynamic> map) {
    return ContratoListagemModel(
      codigo: (map['codigo'] ?? '').toString(),
      status: (map['status'] ?? '').toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory ContratoListagemModel.fromJson(String source) =>
      ContratoListagemModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'ContratoListagemModel(codigo: $codigo, status: $status)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ContratoListagemModel &&
        other.codigo == codigo &&
        other.status == status;
  }

  @override
  int get hashCode => codigo.hashCode ^ status.hashCode;
}
