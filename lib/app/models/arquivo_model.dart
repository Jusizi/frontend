import 'dart:convert';

class ArquivoModel {
  String id;
  String nome;
  String url;
  String tipo;
  String tamanho;
  String data;
  ArquivoModel({
    required this.id,
    required this.nome,
    required this.url,
    required this.tipo,
    required this.tamanho,
    required this.data,
  });

  ArquivoModel copyWith({
    String? id,
    String? nome,
    String? url,
    String? tipo,
    String? tamanho,
    String? data,
  }) {
    return ArquivoModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      url: url ?? this.url,
      tipo: tipo ?? this.tipo,
      tamanho: tamanho ?? this.tamanho,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'url': url,
      'tipo': tipo,
      'tamanho': tamanho,
      'data': data,
    };
  }

  factory ArquivoModel.fromMap(Map<String, dynamic> map) {
    return ArquivoModel(
      id: map['id'] ?? '',
      nome: map['nome'] ?? '',
      url: map['url'] ?? '',
      tipo: map['tipo'] ?? '',
      tamanho: map['tamanho'] ?? '',
      data: map['data'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ArquivoModel.fromJson(String source) =>
      ArquivoModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ArquivoModel(id: $id, nome: $nome, url: $url, tipo: $tipo, tamanho: $tamanho, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ArquivoModel &&
        other.id == id &&
        other.nome == nome &&
        other.url == url &&
        other.tipo == tipo &&
        other.tamanho == tamanho &&
        other.data == data;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        nome.hashCode ^
        url.hashCode ^
        tipo.hashCode ^
        tamanho.hashCode ^
        data.hashCode;
  }
}
