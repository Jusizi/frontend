import 'dart:convert';

class TarefaListagemModel {
  final String codigo;
  final String nome;
  final String descricao;
  final DateTime dataCriacao;
  final String responsavel;
  final String situacao;
  final bool isConcluida;
  TarefaListagemModel({
    required this.codigo,
    required this.nome,
    required this.descricao,
    required this.dataCriacao,
    required this.responsavel,
    required this.situacao,
    required this.isConcluida,
  });

  TarefaListagemModel copyWith({
    String? codigo,
    String? nome,
    String? descricao,
    DateTime? dataCriacao,
    String? responsavel,
    String? situacao,
    bool? isConcluida,
  }) {
    return TarefaListagemModel(
      codigo: codigo ?? this.codigo,
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      responsavel: responsavel ?? this.responsavel,
      situacao: situacao ?? this.situacao,
      isConcluida: isConcluida ?? this.isConcluida,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'codigo': codigo,
      'nome': nome,
      'descricao': descricao,
      'dataCriacao': dataCriacao,
      'responsavel': responsavel,
      'situacao': situacao,
      'isConcluida': isConcluida,
    };
  }

  factory TarefaListagemModel.fromMap(Map<String, dynamic> map) {
    return TarefaListagemModel(
      codigo: (map['codigo'] ?? '').toString(),
      nome: (map['nome'] ?? '').toString(),
      descricao: (map['descricao'] ?? '').toString(),
      dataCriacao: DateTime.parse(map['dataCriacao'] ?? ''),
      responsavel: (map['usuarioCodigoCriou'] ?? '').toString(),
      situacao: (map['situacao'] ?? '').toString(),
      isConcluida: (map['isConcluida'] ?? false),
    );
  }

  String toJson() => json.encode(toMap());

  factory TarefaListagemModel.fromJson(String source) =>
      TarefaListagemModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TarefaListagemModel(codigo: $codigo, nome: $nome, descricao: $descricao, dataCriacao: $dataCriacao, responsavel: $responsavel, situacao: $situacao, isConcluida: $isConcluida)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TarefaListagemModel &&
        other.codigo == codigo &&
        other.nome == nome &&
        other.descricao == descricao &&
        other.dataCriacao == dataCriacao &&
        other.responsavel == responsavel &&
        other.situacao == situacao &&
        other.isConcluida == isConcluida;
  }

  @override
  int get hashCode {
    return codigo.hashCode ^
        nome.hashCode ^
        descricao.hashCode ^
        dataCriacao.hashCode ^
        responsavel.hashCode ^
        situacao.hashCode ^
        isConcluida.hashCode;
  }
}
