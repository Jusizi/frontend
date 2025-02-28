import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'plano_de_conta_model.dart';

class PlanoDeContaAgrupadoModel {
  String grupo;
  List<PlanoDeContaModel> planosDeConta;
  PlanoDeContaAgrupadoModel({
    required this.grupo,
    required this.planosDeConta,
  });

  PlanoDeContaAgrupadoModel copyWith({
    String? grupo,
    List<PlanoDeContaModel>? planosDeConta,
  }) {
    return PlanoDeContaAgrupadoModel(
      grupo: grupo ?? this.grupo,
      planosDeConta: planosDeConta ?? this.planosDeConta,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'grupo': grupo,
      'planosDeConta': planosDeConta.map((x) => x.toMap()).toList(),
    };
  }

  factory PlanoDeContaAgrupadoModel.fromMap(Map<String, dynamic> map) {
    return PlanoDeContaAgrupadoModel(
      grupo: map['grupo'] ?? '',
      planosDeConta: List<PlanoDeContaModel>.from(
          map['planosDeConta']?.map((x) => PlanoDeContaModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory PlanoDeContaAgrupadoModel.fromJson(String source) =>
      PlanoDeContaAgrupadoModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'PlanoDeContaAgrupadoModel(grupo: $grupo, planosDeConta: $planosDeConta)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PlanoDeContaAgrupadoModel &&
        other.grupo == grupo &&
        listEquals(other.planosDeConta, planosDeConta);
  }

  @override
  int get hashCode => grupo.hashCode ^ planosDeConta.hashCode;
}
