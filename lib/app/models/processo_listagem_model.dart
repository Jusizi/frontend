import 'dart:convert';

class ProcessoListagemModel {
  String codigo;
  String numeroCNJ;
  String dataUltimaMovimentacao;
  String quantidadeMovimentacoes;
  String demandante;
  String demandado;
  String ultimaMovimentacaoDescricao;
  String ultimaMovimentacaoData;
  ProcessoListagemModel({
    required this.codigo,
    required this.numeroCNJ,
    required this.dataUltimaMovimentacao,
    required this.quantidadeMovimentacoes,
    required this.demandante,
    required this.demandado,
    required this.ultimaMovimentacaoDescricao,
    required this.ultimaMovimentacaoData,
  }) {
    int quantidadeMovimentacoesValor =
        int.tryParse(quantidadeMovimentacoes) ?? 0;
    if (quantidadeMovimentacoesValor > 0 && quantidadeMovimentacoesValor < 10) {
      quantidadeMovimentacoes = '0$quantidadeMovimentacoes';
    }
  }

  ProcessoListagemModel copyWith({
    String? codigo,
    String? numeroCNJ,
    String? dataUltimaMovimentacao,
    String? quantidadeMovimentacoes,
    String? demandante,
    String? demandado,
    String? ultimaMovimentacaoDescricao,
    String? ultimaMovimentacaoData,
  }) {
    return ProcessoListagemModel(
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
    };
  }

  factory ProcessoListagemModel.fromMap(Map<String, dynamic> map) {
    return ProcessoListagemModel(
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
    );
  }

  String toJson() => json.encode(toMap());

  factory ProcessoListagemModel.fromJson(String source) =>
      ProcessoListagemModel.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProcessoListagemModel &&
        other.codigo == codigo &&
        other.numeroCNJ == numeroCNJ &&
        other.dataUltimaMovimentacao == dataUltimaMovimentacao &&
        other.quantidadeMovimentacoes == quantidadeMovimentacoes &&
        other.demandante == demandante &&
        other.demandado == demandado &&
        other.ultimaMovimentacaoDescricao == ultimaMovimentacaoDescricao &&
        other.ultimaMovimentacaoData == ultimaMovimentacaoData;
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
        ultimaMovimentacaoData.hashCode;
  }
}
