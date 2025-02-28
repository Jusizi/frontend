import 'dart:convert';

class ModeloModel {
  String codigo;
  String nome;
  String nomeArquivo;
  bool loadingExcluir = false;

  ModeloModel({
    required this.codigo,
    required this.nome,
    required this.nomeArquivo,
  });

  ModeloModel copyWith({
    String? codigo,
    String? nome,
    String? nomeArquivo,
  }) {
    return ModeloModel(
      codigo: codigo ?? this.codigo,
      nome: nome ?? this.nome,
      nomeArquivo: nomeArquivo ?? this.nomeArquivo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'codigo': codigo,
      'nome': nome,
      'nomeArquivo': nomeArquivo,
    };
  }

  factory ModeloModel.fromMap(Map<String, dynamic> map) {
    return ModeloModel(
      codigo: map['codigo'] ?? '',
      nome: map['nome'] ?? '',
      nomeArquivo: map['nomeArquivo'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ModeloModel.fromJson(String source) =>
      ModeloModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'ModeloModel(codigo: $codigo, nome: $nome, nomeArquivo: $nomeArquivo)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ModeloModel &&
        other.codigo == codigo &&
        other.nome == nome &&
        other.nomeArquivo == nomeArquivo;
  }

  @override
  int get hashCode => codigo.hashCode ^ nome.hashCode ^ nomeArquivo.hashCode;
}
