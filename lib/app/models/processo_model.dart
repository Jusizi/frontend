import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'envolvido_model.dart';
import 'movimentacao_model.dart';

class ProcessoModel {
  String codigo;
  String numeroCNJ;
  String dataUltimaMovimentacao;
  String quantidadeMovimentacoes;
  String demandante;
  String demandado;
  String ultimaMovimentacaoDescricao;
  String ultimaMovimentacaoData;
  List<MovimentacaoModel> movimentacoes = [];
  List<EnvolvidoModel> envolvidos = [];
  ProcessoModel({
    required this.codigo,
    required this.numeroCNJ,
    required this.dataUltimaMovimentacao,
    required this.quantidadeMovimentacoes,
    required this.demandante,
    required this.demandado,
    required this.ultimaMovimentacaoDescricao,
    required this.ultimaMovimentacaoData,
    required this.movimentacoes,
    required this.envolvidos,
  }) {
    int quantidadeMovimentacoesValor =
        int.tryParse(quantidadeMovimentacoes) ?? 0;
    if (quantidadeMovimentacoesValor > 0 && quantidadeMovimentacoesValor < 10) {
      quantidadeMovimentacoes = '0$quantidadeMovimentacoes';
    }
  }

  ProcessoModel copyWith({
    String? codigo,
    String? numeroCNJ,
    String? dataUltimaMovimentacao,
    String? quantidadeMovimentacoes,
    String? demandante,
    String? demandado,
    String? ultimaMovimentacaoDescricao,
    String? ultimaMovimentacaoData,
    List<MovimentacaoModel>? movimentacoes,
    List<EnvolvidoModel>? envolvidos,
  }) {
    return ProcessoModel(
      codigo: codigo ?? this.codigo,
      numeroCNJ: numeroCNJ ?? this.numeroCNJ,
      dataUltimaMovimentacao:
          dataUltimaMovimentacao ?? this.dataUltimaMovimentacao,
      quantidadeMovimentacoes:
          quantidadeMovimentacoes ?? this.quantidadeMovimentacoes,
      demandante: demandante ?? this.demandante,
      demandado: demandado ?? this.demandado,
      ultimaMovimentacaoDescricao:
          ultimaMovimentacaoDescricao ?? this.ultimaMovimentacaoDescricao,
      ultimaMovimentacaoData:
          ultimaMovimentacaoData ?? this.ultimaMovimentacaoData,
      movimentacoes: movimentacoes ?? this.movimentacoes,
      envolvidos: envolvidos ?? this.envolvidos,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'codigo': codigo,
      'numeroCNJ': numeroCNJ,
      'dataUltimaMovimentacao': dataUltimaMovimentacao,
      'quantidadeMovimentacoes': quantidadeMovimentacoes,
      'demandante': demandante,
      'demandado': demandado,
      'ultimaMovimentacaoDescricao': ultimaMovimentacaoDescricao,
      'ultimaMovimentacaoData': ultimaMovimentacaoData,
      'movimentacoes': movimentacoes.map((x) => x.toMap()).toList(),
      'envolvidos': envolvidos.map((x) => x.toMap()).toList(),
    };
  }

  factory ProcessoModel.fromMap(Map<String, dynamic> map) {
    return ProcessoModel(
      codigo: map['codigo'] ?? '',
      numeroCNJ: map['numeroCNJ'] ?? '',
      dataUltimaMovimentacao: (map['dataUltimaMovimentacao'] ?? '').toString(),
      quantidadeMovimentacoes:
          (map['quantidadeMovimentacoes'] ?? '').toString(),
      demandante: (map['demandante'] ?? '').toString(),
      demandado: (map['demandado'] ?? '').toString(),
      ultimaMovimentacaoDescricao:
          (map['ultimaMovimentacaoDescricao'] ?? '').toString(),
      ultimaMovimentacaoData: (map['ultimaMovimentacaoData'] ?? '').toString(),
      movimentacoes: List<MovimentacaoModel>.from(
          map['movimentacoes']?.map((x) => MovimentacaoModel.fromMap(x))),
      envolvidos: List<EnvolvidoModel>.from(
          map['envolvidos']?.map((x) => EnvolvidoModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProcessoModel.fromJson(String source) =>
      ProcessoModel.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProcessoModel &&
        other.codigo == codigo &&
        other.numeroCNJ == numeroCNJ &&
        other.dataUltimaMovimentacao == dataUltimaMovimentacao &&
        other.quantidadeMovimentacoes == quantidadeMovimentacoes &&
        other.demandante == demandante &&
        other.demandado == demandado &&
        other.ultimaMovimentacaoDescricao == ultimaMovimentacaoDescricao &&
        other.ultimaMovimentacaoData == ultimaMovimentacaoData &&
        listEquals(other.movimentacoes, movimentacoes) &&
        listEquals(other.envolvidos, envolvidos);
  }

  @override
  int get hashCode {
    return codigo.hashCode ^
        numeroCNJ.hashCode ^
        dataUltimaMovimentacao.hashCode ^
        quantidadeMovimentacoes.hashCode ^
        demandante.hashCode ^
        demandado.hashCode ^
        ultimaMovimentacaoDescricao.hashCode ^
        ultimaMovimentacaoData.hashCode ^
        movimentacoes.hashCode ^
        envolvidos.hashCode;
  }
}
