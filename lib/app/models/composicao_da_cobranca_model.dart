import 'dart:convert';

import 'package:flutter_modular/flutter_modular.dart';

import '../modules/sistema/pages/planodecontas/planodecontas_store.dart';
import 'plano_de_conta_model.dart';

class ItemComposicaoDaCobranca {
  PlanoDeContaModel planoDeConta;
  String descricao;
  double valor;
  ItemComposicaoDaCobranca({
    required this.planoDeConta,
    required this.descricao,
    required this.valor,
  });

  ItemComposicaoDaCobranca copyWith({
    PlanoDeContaModel? planoDeConta,
    String? descricao,
    double? valor,
  }) {
    return ItemComposicaoDaCobranca(
      planoDeConta: planoDeConta ?? this.planoDeConta,
      descricao: descricao ?? this.descricao,
      valor: valor ?? this.valor,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'planoDeConta': planoDeConta.toMap(),
      'descricao': descricao,
      'valor': valor,
    };
  }

  factory ItemComposicaoDaCobranca.fromMap(Map<String, dynamic> map) {
    return ItemComposicaoDaCobranca(
      planoDeConta: Modular.get<PlanoDeContasStore>()
          .getPlanoDeContaPorCodigo(map["planoDeContaCodigo"])!,
      descricao: map['descricao'] ?? '',
      valor: map['valor']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemComposicaoDaCobranca.fromJson(String source) =>
      ItemComposicaoDaCobranca.fromMap(json.decode(source));

  @override
  String toString() =>
      'ItemComposicaoDaCobranca(planoDeConta: $planoDeConta, descricao: $descricao, valor: $valor)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ItemComposicaoDaCobranca &&
        other.planoDeConta == planoDeConta &&
        other.descricao == descricao &&
        other.valor == valor;
  }

  @override
  int get hashCode =>
      planoDeConta.hashCode ^ descricao.hashCode ^ valor.hashCode;
}
