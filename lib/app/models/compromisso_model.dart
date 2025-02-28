import 'dart:convert';

import 'package:flutter/material.dart';

class CompromissoModel {
  String codigo;
  String titulo;
  String descricao;
  String status;
  DateTime dataInicio;
  DateTime dataFim;
  String momento;
  bool diaTodo;
  String recorrencia;
  Color cor;
  CompromissoModel({
    required this.codigo,
    required this.titulo,
    required this.descricao,
    required this.status,
    required this.dataInicio,
    required this.dataFim,
    required this.momento,
    required this.diaTodo,
    required this.recorrencia,
    this.cor = Colors.blue,
  }) {
    if (status == 'ativo') {
      cor = Colors.green;
    } else if (status == 'Cancelado') {
      cor = Colors.red;
    }
  }

  CompromissoModel copyWith({
    String? codigo,
    String? titulo,
    String? descricao,
    String? status,
    DateTime? dataInicio,
    DateTime? dataFim,
    String? momento,
    bool? diaTodo,
    String? recorrencia,
  }) {
    return CompromissoModel(
      codigo: codigo ?? this.codigo,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      status: status ?? this.status,
      dataInicio: dataInicio ?? this.dataInicio,
      dataFim: dataFim ?? this.dataFim,
      momento: momento ?? this.momento,
      diaTodo: diaTodo ?? this.diaTodo,
      recorrencia: recorrencia ?? this.recorrencia,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'codigo': codigo,
      'titulo': titulo,
      'descricao': descricao,
      'status': status,
      'dataInicio': dataInicio,
      'dataFim': dataFim,
      'momento': momento,
      'diaTodo': diaTodo,
      'recorrencia': recorrencia,
    };
  }

  factory CompromissoModel.fromMap(Map<String, dynamic> map) {
    final inicio = DateTime.parse(map['dataInicio'] ?? '');
    return CompromissoModel(
      codigo: (map['codigo'] ?? '').toString(),
      titulo: (map['titulo'] ?? '').toString(),
      descricao: (map['descricao'] ?? '').toString(),
      status: (map['status'] ?? '').toString(),
      dataInicio: inicio.toLocal(),
      dataFim: DateTime.parse(map['dataFim'] ?? '').toLocal(),
      momento: (map['momento'] ?? '').toString(),
      diaTodo: map['diaTodo'] ?? false,
      recorrencia: (map['recorrencia'] ?? '').toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory CompromissoModel.fromJson(String source) =>
      CompromissoModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CompromissoModel(codigo: $codigo, titulo: $titulo, descricao: $descricao, status: $status, dataInicio: $dataInicio, dataFim: $dataFim, momento: $momento, diaTodo: $diaTodo, recorrencia: $recorrencia)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CompromissoModel &&
        other.codigo == codigo &&
        other.titulo == titulo &&
        other.descricao == descricao &&
        other.status == status &&
        other.dataInicio == dataInicio &&
        other.dataFim == dataFim &&
        other.momento == momento &&
        other.diaTodo == diaTodo &&
        other.recorrencia == recorrencia;
  }

  @override
  int get hashCode {
    return codigo.hashCode ^
        titulo.hashCode ^
        descricao.hashCode ^
        status.hashCode ^
        dataInicio.hashCode ^
        dataFim.hashCode ^
        momento.hashCode ^
        diaTodo.hashCode ^
        recorrencia.hashCode;
  }
}
