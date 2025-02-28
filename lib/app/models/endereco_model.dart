import 'dart:convert';

import 'localizacao_model.dart';
import 'responsavel_model.dart';

class EnderecoModel {
  String rua;
  String numero;
  String bairro;
  String cidade;
  String pais;
  String cep;
  String complemento;
  String referencia;
  String enderecoCompleto;
  Localizacaomodel localizacao;
  ResponsavelModel responsavel;
  EnderecoModel({
    required this.rua,
    required this.numero,
    required this.bairro,
    required this.cidade,
    required this.pais,
    required this.cep,
    required this.complemento,
    required this.referencia,
    required this.enderecoCompleto,
    required this.localizacao,
    required this.responsavel,
  });

  EnderecoModel copyWith({
    String? rua,
    String? numero,
    String? bairro,
    String? cidade,
    String? pais,
    String? cep,
    String? complemento,
    String? referencia,
    String? enderecoCompleto,
    Localizacaomodel? localizacao,
    ResponsavelModel? responsavel,
  }) {
    return EnderecoModel(
      rua: rua ?? this.rua,
      numero: numero ?? this.numero,
      bairro: bairro ?? this.bairro,
      cidade: cidade ?? this.cidade,
      pais: pais ?? this.pais,
      cep: cep ?? this.cep,
      complemento: complemento ?? this.complemento,
      referencia: referencia ?? this.referencia,
      enderecoCompleto: enderecoCompleto ?? this.enderecoCompleto,
      localizacao: localizacao ?? this.localizacao,
      responsavel: responsavel ?? this.responsavel,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'rua': rua,
      'numero': numero,
      'bairro': bairro,
      'cidade': cidade,
      'pais': pais,
      'cep': cep,
      'complemento': complemento,
      'referencia': referencia,
      'endereco_completo': enderecoCompleto,
      'localizacao': localizacao.toMap(),
      'responsavel': responsavel.toMap(),
    };
  }

  factory EnderecoModel.fromMap(Map<String, dynamic> map) {
    return EnderecoModel(
      rua: map['rua'] ?? '',
      numero: map['numero'] ?? '',
      bairro: map['bairro'] ?? '',
      cidade: map['cidade'] ?? '',
      pais: map['pais'] ?? '',
      cep: map['cep'] ?? '',
      complemento: map['complemento'] ?? '',
      referencia: map['referencia'] ?? '',
      enderecoCompleto: map['endereco_completo'] ?? '',
      localizacao: Localizacaomodel.fromMap(map['localizacao'] ?? {}),
      responsavel: ResponsavelModel.fromMap(map['responsavel'] ?? {}),
    );
  }

  static EnderecoModel getMock() {
    return EnderecoModel(
      rua: 'Rua dos Bobos',
      numero: '0',
      bairro: 'Bairro do Limoeiro',
      cidade: 'São Paulo',
      pais: 'Brasil',
      cep: '00000-000',
      complemento: 'Casa do Chico Bento',
      referencia: 'Próximo ao Pica-Pau',
      enderecoCompleto:
          'Rua dos Bobos, 0, Bairro do Limoeiro, São Paulo, Brasil',
      localizacao: Localizacaomodel.getMock(),
      responsavel: ResponsavelModel.getMock(),
    );
  }

  String toJson() => json.encode(toMap());

  factory EnderecoModel.fromJson(String source) =>
      EnderecoModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'EnderecoModel(rua: $rua, numero: $numero, bairro: $bairro, cidade: $cidade, pais: $pais, cep: $cep, complemento: $complemento, referencia: $referencia, enderecoCompleto: $enderecoCompleto, localizacao: $localizacao, responsavel: $responsavel)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EnderecoModel &&
        other.rua == rua &&
        other.numero == numero &&
        other.bairro == bairro &&
        other.cidade == cidade &&
        other.pais == pais &&
        other.cep == cep &&
        other.complemento == complemento &&
        other.referencia == referencia &&
        other.enderecoCompleto == enderecoCompleto &&
        other.localizacao == localizacao &&
        other.responsavel == responsavel;
  }

  @override
  int get hashCode {
    return rua.hashCode ^
        numero.hashCode ^
        bairro.hashCode ^
        cidade.hashCode ^
        pais.hashCode ^
        cep.hashCode ^
        complemento.hashCode ^
        referencia.hashCode ^
        enderecoCompleto.hashCode ^
        localizacao.hashCode ^
        responsavel.hashCode;
  }
}
