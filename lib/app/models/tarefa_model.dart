import 'dart:convert';

class TarefaModel {
  final String nome;
  final String descricao;
  TarefaModel({
    required this.nome,
    required this.descricao,
  });

  TarefaModel copyWith({
    String? nome,
    String? descricao,
  }) {
    return TarefaModel(
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

  factory TarefaModel.fromMap(Map<String, dynamic> map) {
    return TarefaModel(
      nome: map['nome'] ?? '',
      descricao: map['descricao'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory TarefaModel.fromJson(String source) =>
      TarefaModel.fromMap(json.decode(source));

  @override
  String toString() => 'TarefaModel(nome: $nome, descricao: $descricao)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TarefaModel &&
        other.nome == nome &&
        other.descricao == descricao;
  }

  @override
  int get hashCode => nome.hashCode ^ descricao.hashCode;
}
