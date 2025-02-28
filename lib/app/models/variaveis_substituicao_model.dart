import 'dart:convert';

import 'package:flutter/foundation.dart';

class VariaveisSubstituicaoModel {
  String grupo;
  List<VariavelSubstituicaoModel> variaveisSubstituicao;
  VariaveisSubstituicaoModel({
    required this.grupo,
    required this.variaveisSubstituicao,
  });

  VariaveisSubstituicaoModel copyWith({
    String? grupo,
    List<VariavelSubstituicaoModel>? variaveisSubstituicao,
  }) {
    return VariaveisSubstituicaoModel(
      grupo: grupo ?? this.grupo,
      variaveisSubstituicao:
          variaveisSubstituicao ?? this.variaveisSubstituicao,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'grupo': grupo,
      'variaveisSubstituicao':
          variaveisSubstituicao.map((x) => x.toMap()).toList(),
    };
  }

  factory VariaveisSubstituicaoModel.fromMap(Map<String, dynamic> map) {
    return VariaveisSubstituicaoModel(
      grupo: map['grupo'] ?? '',
      variaveisSubstituicao: List<VariavelSubstituicaoModel>.from(
          map['variaveisSubstituicao']
              ?.map((x) => VariavelSubstituicaoModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory VariaveisSubstituicaoModel.fromJson(String source) =>
      VariaveisSubstituicaoModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'VariaveisSubstituicaoModel(grupo: $grupo, variaveisSubstituicao: $variaveisSubstituicao)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is VariaveisSubstituicaoModel &&
        other.grupo == grupo &&
        listEquals(other.variaveisSubstituicao, variaveisSubstituicao);
  }

  @override
  int get hashCode => grupo.hashCode ^ variaveisSubstituicao.hashCode;
}

class VariavelSubstituicaoModel {
  String nome;
  String descricao;
  VariavelSubstituicaoModel({
    required this.nome,
    required this.descricao,
  });

  VariavelSubstituicaoModel copyWith({
    String? nome,
    String? descricao,
  }) {
    return VariavelSubstituicaoModel(
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'descricao': descricao,
    };
  }

  factory VariavelSubstituicaoModel.fromMap(Map<String, dynamic> map) {
    return VariavelSubstituicaoModel(
      nome: map['nome'] ?? '',
      descricao: map['descricao'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory VariavelSubstituicaoModel.fromJson(String source) =>
      VariavelSubstituicaoModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'VariavelSubstituicaoModel(nome: $nome, descricao: $descricao)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is VariavelSubstituicaoModel &&
        other.nome == nome &&
        other.descricao == descricao;
  }

  @override
  int get hashCode => nome.hashCode ^ descricao.hashCode;
}
