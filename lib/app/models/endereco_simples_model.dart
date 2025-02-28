import 'dart:convert';

class EnderecoSimplesModel {
  String logradouro;
  String numero;
  String complemento;
  String bairro;
  String cidade;
  String estado;
  String cep;
  EnderecoSimplesModel({
    required this.logradouro,
    required this.numero,
    required this.complemento,
    required this.bairro,
    required this.cidade,
    required this.estado,
    required this.cep,
  });

  EnderecoSimplesModel copyWith({
    String? logradouro,
    String? numero,
    String? complemento,
    String? bairro,
    String? cidade,
    String? estado,
    String? cep,
  }) {
    return EnderecoSimplesModel(
      logradouro: logradouro ?? this.logradouro,
      numero: numero ?? this.numero,
      complemento: complemento ?? this.complemento,
      bairro: bairro ?? this.bairro,
      cidade: cidade ?? this.cidade,
      estado: estado ?? this.estado,
      cep: cep ?? this.cep,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'logradouro': logradouro,
      'numero': numero,
      'complemento': complemento,
      'bairro': bairro,
      'cidade': cidade,
      'estado': estado,
      'cep': cep,
    };
  }

  factory EnderecoSimplesModel.fromMap(Map<String, dynamic> map) {
    return EnderecoSimplesModel(
      logradouro: map['logradouro'] ?? '',
      numero: map['numero'] ?? '',
      complemento: map['complemento'] ?? '',
      bairro: map['bairro'] ?? '',
      cidade: map['cidade'] ?? '',
      estado: map['estado'] ?? '',
      cep: map['cep'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory EnderecoSimplesModel.fromJson(String source) =>
      EnderecoSimplesModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'EnderecoSimplesModel(logradouro: $logradouro, numero: $numero, complemento: $complemento, bairro: $bairro, cidade: $cidade, estado: $estado, cep: $cep)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EnderecoSimplesModel &&
        other.logradouro == logradouro &&
        other.numero == numero &&
        other.complemento == complemento &&
        other.bairro == bairro &&
        other.cidade == cidade &&
        other.estado == estado &&
        other.cep == cep;
  }

  @override
  int get hashCode {
    return logradouro.hashCode ^
        numero.hashCode ^
        complemento.hashCode ^
        bairro.hashCode ^
        cidade.hashCode ^
        estado.hashCode ^
        cep.hashCode;
  }
}
