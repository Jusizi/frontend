import 'dart:convert';

class PlanoDeContaModel {
  int codigo;
  String nome;
  String tipo;
  String categoria;
  String descricao;
  int codigoPlanoDeContasPai;
  int nivel;
  PlanoDeContaModel({
    required this.codigo,
    required this.nome,
    required this.tipo,
    required this.categoria,
    required this.descricao,
    required this.codigoPlanoDeContasPai,
    required this.nivel,
  });

  PlanoDeContaModel copyWith({
    int? codigo,
    String? nome,
    String? tipo,
    String? categoria,
    String? descricao,
    int? codigoPlanoDeContasPai,
    int? nivel,
  }) {
    return PlanoDeContaModel(
      codigo: codigo ?? this.codigo,
      nome: nome ?? this.nome,
      tipo: tipo ?? this.tipo,
      categoria: categoria ?? this.categoria,
      descricao: descricao ?? this.descricao,
      codigoPlanoDeContasPai:
          codigoPlanoDeContasPai ?? this.codigoPlanoDeContasPai,
      nivel: nivel ?? this.nivel,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'codigo': codigo,
      'nome': nome,
      'tipo': tipo,
      'categoria': categoria,
      'descricao': descricao,
      'codigoPlanoDeContasPai': codigoPlanoDeContasPai,
      'nivel': nivel,
    };
  }

  factory PlanoDeContaModel.fromMap(Map<String, dynamic> map) {
    return PlanoDeContaModel(
      codigo: (map['codigo']?.toInt() ?? 0).toInt(),
      nome: map['nome'] ?? '',
      tipo: map['tipo'] ?? '',
      categoria: map['categoria'] ?? '',
      descricao: map['descricao'] ?? '',
      codigoPlanoDeContasPai:
          (map['codigoPlanoDeContasPai']?.toInt() ?? 0).toInt(),
      nivel: (map['nivel']?.toInt() ?? 0).toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory PlanoDeContaModel.fromJson(String source) =>
      PlanoDeContaModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PlanoDeContaModel(codigo: $codigo, nome: $nome, tipo: $tipo, categoria: $categoria, descricao: $descricao, codigoPlanoDeContasPai: $codigoPlanoDeContasPai, nivel: $nivel)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PlanoDeContaModel &&
        other.codigo == codigo &&
        other.nome == nome &&
        other.tipo == tipo &&
        other.categoria == categoria &&
        other.descricao == descricao &&
        other.codigoPlanoDeContasPai == codigoPlanoDeContasPai &&
        other.nivel == nivel;
  }

  @override
  int get hashCode {
    return codigo.hashCode ^
        nome.hashCode ^
        tipo.hashCode ^
        categoria.hashCode ^
        descricao.hashCode ^
        codigoPlanoDeContasPai.hashCode ^
        nivel.hashCode;
  }
}
