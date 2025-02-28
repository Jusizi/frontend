import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'colaborador_model.dart';
import 'endereco_model.dart';

class EmpresaModel {
  String codigo;
  String apelido;
  String documentoTipo;
  String documentoNumero;
  String email;
  EnderecoModel endereco;
  List<ColaboradorModel> colaboradores;
  EmpresaModel({
    required this.codigo,
    required this.apelido,
    required this.documentoTipo,
    required this.documentoNumero,
    required this.email,
    required this.endereco,
    required this.colaboradores,
  });

  static EmpresaModel getMock() {
    return EmpresaModel(
      codigo: '',
      apelido: '',
      documentoTipo: '',
      documentoNumero: '',
      email: '',
      endereco: EnderecoModel.getMock(),
      colaboradores: [],
    );
  }

  EmpresaModel copyWith({
    String? codigo,
    String? apelido,
    String? documentoTipo,
    String? documentoNumero,
    String? email,
    EnderecoModel? endereco,
    List<ColaboradorModel>? colaboradores,
  }) {
    return EmpresaModel(
      codigo: codigo ?? this.codigo,
      apelido: apelido ?? this.apelido,
      documentoTipo: documentoTipo ?? this.documentoTipo,
      documentoNumero: documentoNumero ?? this.documentoNumero,
      email: email ?? this.email,
      endereco: endereco ?? this.endereco,
      colaboradores: colaboradores ?? this.colaboradores,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'codigo': codigo,
      'apelido': apelido,
      'documentoTipo': documentoTipo,
      'documentoNumero': documentoNumero,
      'email': email,
      'endereco': endereco.toMap(),
      'colaboradores': colaboradores.map((x) => x.toMap()).toList(),
    };
  }

  factory EmpresaModel.fromMap(Map<String, dynamic> map) {
    return EmpresaModel(
      codigo: map['codigo'] ?? '',
      apelido: map['apelido'] ?? '',
      documentoTipo: map['documentoTipo'] ?? '',
      documentoNumero: map['documentoNumero'] ?? '',
      email: map['email'] ?? '',
      endereco: EnderecoModel.fromMap(map['endereco'] ?? {}),
      colaboradores: List<ColaboradorModel>.from(
          map['colaboradores']?.map((x) => ColaboradorModel.fromMap(x)) ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory EmpresaModel.fromJson(String source) =>
      EmpresaModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'EmpresaModel(codigo: $codigo, apelido: $apelido, documentoTipo: $documentoTipo, documentoNumero: $documentoNumero, email: $email, endereco: $endereco, colaboradores: $colaboradores)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EmpresaModel &&
        other.codigo == codigo &&
        other.apelido == apelido &&
        other.documentoTipo == documentoTipo &&
        other.documentoNumero == documentoNumero &&
        other.email == email &&
        other.endereco == endereco &&
        listEquals(other.colaboradores, colaboradores);
  }

  @override
  int get hashCode {
    return codigo.hashCode ^
        apelido.hashCode ^
        documentoTipo.hashCode ^
        documentoNumero.hashCode ^
        email.hashCode ^
        endereco.hashCode ^
        colaboradores.hashCode;
  }
}
