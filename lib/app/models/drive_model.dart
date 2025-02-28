import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'arquivo_model.dart';

class DriveModel {
  List<ArquivoModel> arquivos;
  DriveModel({
    required this.arquivos,
  });

  DriveModel copyWith({
    List<ArquivoModel>? arquivos,
  }) {
    return DriveModel(
      arquivos: arquivos ?? this.arquivos,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'arquivos': arquivos.map((x) => x.toMap()).toList(),
    };
  }

  factory DriveModel.fromMap(Map<String, dynamic> map) {
    return DriveModel(
      arquivos: List<ArquivoModel>.from(
          map['arquivos']?.map((x) => ArquivoModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory DriveModel.fromJson(String source) =>
      DriveModel.fromMap(json.decode(source));

  @override
  String toString() => 'DriveModel(arquivos: $arquivos)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DriveModel && listEquals(other.arquivos, arquivos);
  }

  @override
  int get hashCode => arquivos.hashCode;
}
