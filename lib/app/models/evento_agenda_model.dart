import 'dart:convert';

class EventoAgendaModel {
  String codigo;
  String descricao;
  EventoAgendaModel({
    required this.codigo,
    required this.descricao,
  });

  EventoAgendaModel copyWith({
    String? codigo,
    String? descricao,
  }) {
    return EventoAgendaModel(
      codigo: codigo ?? this.codigo,
      descricao: descricao ?? this.descricao,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'codigo': codigo,
      'descricao': descricao,
    };
  }

  factory EventoAgendaModel.fromMap(Map<String, dynamic> map) {
    return EventoAgendaModel(
      codigo: map['codigo'] ?? '',
      descricao: map['descricao'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory EventoAgendaModel.fromJson(String source) =>
      EventoAgendaModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'EventoAgendaModel(codigo: $codigo, descricao: $descricao)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EventoAgendaModel &&
        other.codigo == codigo &&
        other.descricao == descricao;
  }

  @override
  int get hashCode => codigo.hashCode ^ descricao.hashCode;
}
