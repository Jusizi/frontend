import 'dart:convert';

class ResponsavelModel {
  String codigo;
  String nomeCompleto;
  String email;
  String oab;
  ResponsavelModel({
    required this.codigo,
    required this.nomeCompleto,
    required this.email,
    required this.oab,
  });

  static ResponsavelModel getMock() {
    return ResponsavelModel(
      codigo: '',
      nomeCompleto: '',
      email: '',
      oab: '',
    );
  }

  ResponsavelModel copyWith({
    String? codigo,
    String? nomeCompleto,
    String? email,
    String? oab,
  }) {
    return ResponsavelModel(
      codigo: codigo ?? this.codigo,
      nomeCompleto: nomeCompleto ?? this.nomeCompleto,
      email: email ?? this.email,
      oab: oab ?? this.oab,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'codigo': codigo,
      'nomeCompleto': nomeCompleto,
      'email': email,
      'oab': oab,
    };
  }

  factory ResponsavelModel.fromMap(Map<String, dynamic> map) {
    return ResponsavelModel(
      codigo: map['codigo'] ?? '',
      nomeCompleto: map['nomeCompleto'] ?? '',
      email: map['email'] ?? '',
      oab: map['oab'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ResponsavelModel.fromJson(String source) =>
      ResponsavelModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ResponsavelModel(codigo: $codigo, nomeCompleto: $nomeCompleto, email: $email, oab: $oab)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ResponsavelModel &&
        other.codigo == codigo &&
        other.nomeCompleto == nomeCompleto &&
        other.email == email &&
        other.oab == oab;
  }

  @override
  int get hashCode {
    return codigo.hashCode ^
        nomeCompleto.hashCode ^
        email.hashCode ^
        oab.hashCode;
  }
}
