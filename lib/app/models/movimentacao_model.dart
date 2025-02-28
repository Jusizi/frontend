import 'dart:convert';

class MovimentacaoModel {
  String id;
  String empresaCodigo;
  String processoCodigo;
  String processoCNJ;
  String data;
  String tipo;
  String tipoPublicacao;
  String classificacaoPreditaName;
  String classificacaoPreditaDescricao;
  String classificacaoPreditaHierarquia;
  String conteudo;
  String textoCategoria;
  String fonteProcessoFonteId;
  String fonteFonteId;
  String fonteNome;
  String fonteTipo;
  String fonteSigla;
  String fonteGrau;
  String fonteGrauFormatado;
  MovimentacaoModel({
    required this.id,
    required this.empresaCodigo,
    required this.processoCodigo,
    required this.processoCNJ,
    required this.data,
    required this.tipo,
    required this.tipoPublicacao,
    required this.classificacaoPreditaName,
    required this.classificacaoPreditaDescricao,
    required this.classificacaoPreditaHierarquia,
    required this.conteudo,
    required this.textoCategoria,
    required this.fonteProcessoFonteId,
    required this.fonteFonteId,
    required this.fonteNome,
    required this.fonteTipo,
    required this.fonteSigla,
    required this.fonteGrau,
    required this.fonteGrauFormatado,
  });

  MovimentacaoModel copyWith({
    String? id,
    String? empresaCodigo,
    String? processoCodigo,
    String? processoCNJ,
    String? data,
    String? tipo,
    String? tipoPublicacao,
    String? classificacaoPreditaName,
    String? classificacaoPreditaDescricao,
    String? classificacaoPreditaHierarquia,
    String? conteudo,
    String? textoCategoria,
    String? fonteProcessoFonteId,
    String? fonteFonteId,
    String? fonteNome,
    String? fonteTipo,
    String? fonteSigla,
    String? fonteGrau,
    String? fonteGrauFormatado,
  }) {
    return MovimentacaoModel(
      id: id ?? this.id,
      empresaCodigo: empresaCodigo ?? this.empresaCodigo,
      processoCodigo: processoCodigo ?? this.processoCodigo,
      processoCNJ: processoCNJ ?? this.processoCNJ,
      data: data ?? this.data,
      tipo: tipo ?? this.tipo,
      tipoPublicacao: tipoPublicacao ?? this.tipoPublicacao,
      classificacaoPreditaName:
          classificacaoPreditaName ?? this.classificacaoPreditaName,
      classificacaoPreditaDescricao:
          classificacaoPreditaDescricao ?? this.classificacaoPreditaDescricao,
      classificacaoPreditaHierarquia:
          classificacaoPreditaHierarquia ?? this.classificacaoPreditaHierarquia,
      conteudo: conteudo ?? this.conteudo,
      textoCategoria: textoCategoria ?? this.textoCategoria,
      fonteProcessoFonteId: fonteProcessoFonteId ?? this.fonteProcessoFonteId,
      fonteFonteId: fonteFonteId ?? this.fonteFonteId,
      fonteNome: fonteNome ?? this.fonteNome,
      fonteTipo: fonteTipo ?? this.fonteTipo,
      fonteSigla: fonteSigla ?? this.fonteSigla,
      fonteGrau: fonteGrau ?? this.fonteGrau,
      fonteGrauFormatado: fonteGrauFormatado ?? this.fonteGrauFormatado,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'empresaCodigo': empresaCodigo,
      'processoCodigo': processoCodigo,
      'processoCNJ': processoCNJ,
      'data': data,
      'tipo': tipo,
      'tipoPublicacao': tipoPublicacao,
      'classificacaoPreditaName': classificacaoPreditaName,
      'classificacaoPreditaDescricao': classificacaoPreditaDescricao,
      'classificacaoPreditaHierarquia': classificacaoPreditaHierarquia,
      'conteudo': conteudo,
      'textoCategoria': textoCategoria,
      'fonteProcessoFonteId': fonteProcessoFonteId,
      'fonteFonteId': fonteFonteId,
      'fonteNome': fonteNome,
      'fonteTipo': fonteTipo,
      'fonteSigla': fonteSigla,
      'fonteGrau': fonteGrau,
      'fonteGrauFormatado': fonteGrauFormatado,
    };
  }

  factory MovimentacaoModel.fromMap(Map<String, dynamic> map) {
    return MovimentacaoModel(
      id: (map['id'] ?? '').toString(),
      empresaCodigo: (map['empresaCodigo'] ?? '').toString(),
      processoCodigo: (map['processoCodigo'] ?? '').toString(),
      processoCNJ: (map['processoCNJ'] ?? '').toString(),
      data: (map['data'] ?? '').toString(),
      tipo: (map['tipo'] ?? '').toString(),
      tipoPublicacao: (map['tipoPublicacao'] ?? '').toString(),
      classificacaoPreditaName:
          (map['classificacaoPreditaNome'] ?? '').toString(),
      classificacaoPreditaDescricao:
          (map['classificacaoPreditaDescricao'] ?? '').toString(),
      classificacaoPreditaHierarquia:
          (map['classificacaoPreditaHierarquia'] ?? '').toString(),
      conteudo: (map['conteudo'] ?? '').toString(),
      textoCategoria: (map['textoCategoria'] ?? '').toString(),
      fonteProcessoFonteId: (map['fonteProcessoFonteId'] ?? '').toString(),
      fonteFonteId: (map['fonteFonteId'] ?? '').toString(),
      fonteNome: (map['fonteNome'] ?? '').toString(),
      fonteTipo: (map['fonteTipo'] ?? '').toString(),
      fonteSigla: (map['fonteSigla'] ?? '').toString(),
      fonteGrau: (map['fonteGrau'] ?? '').toString(),
      fonteGrauFormatado: (map['fonteGrauFormatado'] ?? '').toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory MovimentacaoModel.fromJson(String source) =>
      MovimentacaoModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MovimentacaoModel(id: $id, empresaCodigo: $empresaCodigo, processoCodigo: $processoCodigo, processoCNJ: $processoCNJ, data: $data, tipo: $tipo, tipoPublicacao: $tipoPublicacao, classificacaoPreditaName: $classificacaoPreditaName, classificacaoPreditaDescricao: $classificacaoPreditaDescricao, classificacaoPreditaHierarquia: $classificacaoPreditaHierarquia, conteudo: $conteudo, textoCategoria: $textoCategoria, fonteProcessoFonteId: $fonteProcessoFonteId, fonteFonteId: $fonteFonteId, fonteNome: $fonteNome, fonteTipo: $fonteTipo, fonteSigla: $fonteSigla, fonteGrau: $fonteGrau, fonteGrauFormatado: $fonteGrauFormatado)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MovimentacaoModel &&
        other.id == id &&
        other.empresaCodigo == empresaCodigo &&
        other.processoCodigo == processoCodigo &&
        other.processoCNJ == processoCNJ &&
        other.data == data &&
        other.tipo == tipo &&
        other.tipoPublicacao == tipoPublicacao &&
        other.classificacaoPreditaName == classificacaoPreditaName &&
        other.classificacaoPreditaDescricao == classificacaoPreditaDescricao &&
        other.classificacaoPreditaHierarquia ==
            classificacaoPreditaHierarquia &&
        other.conteudo == conteudo &&
        other.textoCategoria == textoCategoria &&
        other.fonteProcessoFonteId == fonteProcessoFonteId &&
        other.fonteFonteId == fonteFonteId &&
        other.fonteNome == fonteNome &&
        other.fonteTipo == fonteTipo &&
        other.fonteSigla == fonteSigla &&
        other.fonteGrau == fonteGrau &&
        other.fonteGrauFormatado == fonteGrauFormatado;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        empresaCodigo.hashCode ^
        processoCodigo.hashCode ^
        processoCNJ.hashCode ^
        data.hashCode ^
        tipo.hashCode ^
        tipoPublicacao.hashCode ^
        classificacaoPreditaName.hashCode ^
        classificacaoPreditaDescricao.hashCode ^
        classificacaoPreditaHierarquia.hashCode ^
        conteudo.hashCode ^
        textoCategoria.hashCode ^
        fonteProcessoFonteId.hashCode ^
        fonteFonteId.hashCode ^
        fonteNome.hashCode ^
        fonteTipo.hashCode ^
        fonteSigla.hashCode ^
        fonteGrau.hashCode ^
        fonteGrauFormatado.hashCode;
  }
}
