import 'dart:convert';

class ClienteListagemModel {
  String codigo;
  String nomeCompleto;
  String documento;
  String whatsapp;
  ClienteListagemModel({
    required this.codigo,
    required this.nomeCompleto,
    required this.documento,
    required this.whatsapp,
  });

  ClienteListagemModel copyWith({
    String? codigo,
    String? nomeCompleto,
    String? documento,
    String? whatsapp,
  }) {
    return ClienteListagemModel(
      codigo: codigo ?? this.codigo,
      nomeCompleto: nomeCompleto ?? this.nomeCompleto,
      documento: documento ?? this.documento,
      whatsapp: whatsapp ?? this.whatsapp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'codigo': codigo,
      'nomeCompleto': nomeCompleto,
      'documento': documento,
      'whatsapp': whatsapp,
    };
  }

  factory ClienteListagemModel.fromMap(Map<String, dynamic> map) {
    return ClienteListagemModel(
      codigo: map['codigo'] ?? '',
      nomeCompleto: map['nomeCompleto'] ?? '',
      documento: map['documento'] ?? '',
      whatsapp: map['whatsapp'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ClienteListagemModel.fromJson(String source) =>
      ClienteListagemModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ClienteListagemModel(codigo: $codigo, nomeCompleto: $nomeCompleto, documento: $documento, whatsapp: $whatsapp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ClienteListagemModel &&
        other.codigo == codigo &&
        other.nomeCompleto == nomeCompleto &&
        other.documento == documento &&
        other.whatsapp == whatsapp;
  }

  @override
  int get hashCode {
    return codigo.hashCode ^
        nomeCompleto.hashCode ^
        documento.hashCode ^
        whatsapp.hashCode;
  }
}
