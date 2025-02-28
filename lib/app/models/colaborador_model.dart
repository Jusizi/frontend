import 'dart:convert';

// ignore_for_file: file_names

class ColaboradorModel {
  String id;
  String nome;
  String email;
  ColaboradorModel({
    required this.id,
    required this.nome,
    required this.email,
  });

  ColaboradorModel copyWith({
    String? id,
    String? nome,
    String? email,
  }) {
    return ColaboradorModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
    };
  }

  factory ColaboradorModel.fromMap(Map<String, dynamic> map) {
    return ColaboradorModel(
      id: map['id'] ?? '',
      nome: map['nome'] ?? '',
      email: map['email'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ColaboradorModel.fromJson(String source) =>
      ColaboradorModel.fromMap(json.decode(source));

  @override
  String toString() => 'ColaboradorModel(id: $id, nome: $nome, email: $email)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ColaboradorModel &&
        other.id == id &&
        other.nome == nome &&
        other.email == email;
  }

  @override
  int get hashCode => id.hashCode ^ nome.hashCode ^ email.hashCode;
}
