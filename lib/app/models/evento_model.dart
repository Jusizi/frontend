import 'dart:convert';

class Evento {
  String descricao;
  String momento;
  Evento({
    required this.descricao,
    required this.momento,
  });

  Evento copyWith({
    String? descricao,
    String? momento,
  }) {
    return Evento(
      descricao: descricao ?? this.descricao,
      momento: momento ?? this.momento,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'descricao': descricao,
      'momento': momento,
    };
  }

  factory Evento.fromMap(Map<String, dynamic> map) {
    return Evento(
      descricao: map['descricao'] ?? '',
      momento: map['momento'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Evento.fromJson(String source) => Evento.fromMap(json.decode(source));

  @override
  String toString() => 'Evento(descricao: $descricao, momento: $momento)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Evento &&
        other.descricao == descricao &&
        other.momento == momento;
  }

  @override
  int get hashCode => descricao.hashCode ^ momento.hashCode;
}
