import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'evento_model.dart';

class ContaBancariaModel {
  String id;
  String nome;
  String banco;
  String chaveAPI;
  String clientID;
  List<Evento> eventos;
  bool producao;
  String logo = '';
  ContaBancariaModel({
    required this.id,
    required this.nome,
    required this.banco,
    required this.chaveAPI,
    required this.clientID,
    required this.eventos,
    required this.producao,
  }) {
    logo =
        '${const String.fromEnvironment('baseUrlAPI', defaultValue: 'http://localhost:8053')}/bancos/asaas.jpg';
  }

  ContaBancariaModel copyWith({
    String? id,
    String? nome,
    String? banco,
    String? chaveAPI,
    String? clientID,
    List<Evento>? eventos,
    bool producao = false,
  }) {
    return ContaBancariaModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      banco: banco ?? this.banco,
      chaveAPI: chaveAPI ?? this.chaveAPI,
      clientID: clientID ?? this.clientID,
      eventos: eventos ?? this.eventos,
      producao: producao,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'banco': banco,
      'chaveAPI': chaveAPI,
      'clientID': clientID,
      'eventos': eventos.map((x) => x.toMap()).toList(),
      'producao': producao,
    };
  }

  factory ContaBancariaModel.fromMap(Map<String, dynamic> map) {
    return ContaBancariaModel(
      id: (map['codigo'] ?? '').toString(),
      nome: (map['nome'] ?? '').toString(),
      banco: (map['banco'] ?? '').toString(),
      chaveAPI: (map['chaveAPI'] ?? '').toString(),
      clientID: (map['clientID'] ?? '').toString(),
      producao: (map['ambiente'] ?? 'Sandbox') == 'Sandbox' ? false : true,
      eventos: List<Evento>.from(
          map['eventos']?.map((x) => Evento.fromMap(x)) ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory ContaBancariaModel.fromJson(String source) =>
      ContaBancariaModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ContaBancariaModel(id: $id, nome: $nome, banco: $banco, chaveAPI: $chaveAPI, clientID: $clientID, eventos: $eventos)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ContaBancariaModel &&
        other.id == id &&
        other.nome == nome &&
        other.banco == banco &&
        other.chaveAPI == chaveAPI &&
        other.producao == producao &&
        other.clientID == clientID &&
        listEquals(other.eventos, eventos);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        nome.hashCode ^
        banco.hashCode ^
        chaveAPI.hashCode ^
        clientID.hashCode ^
        producao.hashCode ^
        eventos.hashCode;
  }
}
