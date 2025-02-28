import 'dart:convert';

class EnvolvidoModel {
  String codigo;
  String nomeCompleto;
  String documento;
  String tipo;
  String oab;
  int quantidadeDeProcessos;
  EnvolvidoModel({
    required this.codigo,
    required this.nomeCompleto,
    required this.documento,
    required this.tipo,
    required this.oab,
    required this.quantidadeDeProcessos,
  });

  EnvolvidoModel copyWith({
    String? codigo,
    String? nomeCompleto,
    String? documento,
    String? tipo,
    String? oab,
    int? quantidadeDeProcessos,
  }) {
    return EnvolvidoModel(
      codigo: codigo ?? this.codigo,
      nomeCompleto: nomeCompleto ?? this.nomeCompleto,
      documento: documento ?? this.documento,
      tipo: tipo ?? this.tipo,
      oab: oab ?? this.oab,
      quantidadeDeProcessos:
          quantidadeDeProcessos ?? this.quantidadeDeProcessos,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'codigo': codigo,
      'nomeCompleto': nomeCompleto,
      'documento': documento,
      'tipo': tipo,
      'oab': oab,
      'quantidadeDeProcessos': quantidadeDeProcessos,
    };
  }

  factory EnvolvidoModel.fromMap(Map<String, dynamic> map) {
    return EnvolvidoModel(
      codigo: map['codigo'] ?? '',
      nomeCompleto: map['nomeCompleto'] ?? '',
      documento: map['documento'] ?? '',
      tipo: map['tipo'] ?? '',
      oab: map['oab'] ?? '',
      quantidadeDeProcessos: map['quantidadeDeProcessos']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory EnvolvidoModel.fromJson(String source) =>
      EnvolvidoModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'EnvolvidoModel(codigo: $codigo, nomeCompleto: $nomeCompleto, documento: $documento, tipo: $tipo, oab: $oab, quantidadeDeProcessos: $quantidadeDeProcessos)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EnvolvidoModel &&
        other.codigo == codigo &&
        other.nomeCompleto == nomeCompleto &&
        other.documento == documento &&
        other.tipo == tipo &&
        other.oab == oab &&
        other.quantidadeDeProcessos == quantidadeDeProcessos;
  }

  @override
  int get hashCode {
    return codigo.hashCode ^
        nomeCompleto.hashCode ^
        documento.hashCode ^
        tipo.hashCode ^
        oab.hashCode ^
        quantidadeDeProcessos.hashCode;
  }
}
