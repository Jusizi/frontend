import 'dart:convert';

class ContratoModel {
  String codigo;
  String status;
  ContratoModel({
    required this.codigo,
    required this.status,
  });

  ContratoModel copyWith({
    String? codigo,
    String? status,
  }) {
    return ContratoModel(
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

  factory ContratoModel.fromMap(Map<String, dynamic> map) {
    return ContratoModel(
      codigo: map['codigo'] ?? '',
      status: map['status'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ContratoModel.fromJson(String source) =>
      ContratoModel.fromMap(json.decode(source));

  @override
  String toString() => 'ContratoModel(codigo: $codigo, status: $status)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ContratoModel &&
        other.codigo == codigo &&
        other.status == status;
  }

  @override
  int get hashCode => codigo.hashCode ^ status.hashCode;
}
