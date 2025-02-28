import 'dart:convert';

class FamiliarModel {
  String nome;
  String parentesco;
  String documento;
  bool isLoading = false;

  FamiliarModel({
    required this.nome,
    required this.parentesco,
    required this.documento,
  });

  FamiliarModel copyWith({
    String? nome,
    String? parentesco,
    String? documento,
  }) {
    return FamiliarModel(
      nome: nome ?? this.nome,
      parentesco: parentesco ?? this.parentesco,
      documento: documento ?? this.documento,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'parentesco': parentesco,
      'documento': documento,
    };
  }

  factory FamiliarModel.fromMap(Map<String, dynamic> map) {
    return FamiliarModel(
      nome: map['nome'] ?? '',
      parentesco: map['parentesco'] ?? '',
      documento: map['documento'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory FamiliarModel.fromJson(String source) =>
      FamiliarModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'FamiliarModel(nome: $nome, parentesco: $parentesco, documento: $documento)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FamiliarModel &&
        other.nome == nome &&
        other.parentesco == parentesco &&
        other.documento == documento;
  }

  @override
  int get hashCode => nome.hashCode ^ parentesco.hashCode ^ documento.hashCode;
}
