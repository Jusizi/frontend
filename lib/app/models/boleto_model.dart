import 'dart:convert';

import 'cliente_model.dart';

class BoletoModel {
  String boletoCodigo;
  String cobrancaCodigo;
  String pagadorCodigo;
  StatusBoleto status;
  DateTime vencimento;
  String nossoNumero;
  String codigoDeBarras;
  String linhaDigitavel;
  String link;
  String mensagem;
  bool aceito;
  double valor;
  ClienteModel? pagador;
  bool isLoading = false;
  late String dataVencimentoFormatada;
  BoletoModel({
    required this.boletoCodigo,
    required this.cobrancaCodigo,
    required this.pagadorCodigo,
    required this.status,
    required this.vencimento,
    required this.nossoNumero,
    required this.codigoDeBarras,
    required this.linhaDigitavel,
    required this.link,
    required this.mensagem,
    required this.aceito,
    required this.valor,
  }) {
    // dataVencimento == 'YYYY-MM-DD'
    // dataVencimentoFormatada == 'DD/MM/YYYY'
    dataVencimentoFormatada =
        '${vencimento.day.toString().padLeft(2, '0')}/${vencimento.month.toString().padLeft(2, '0')}/${vencimento.year}';
  }

  BoletoModel copyWith({
    String? boletoCodigo,
    String? pagadorCodigo,
    StatusBoleto? status,
    DateTime? vencimento,
    String? nossoNumero,
    String? codigoDeBarras,
    String? mensagem,
    String? linhaDigitavel,
    String? link,
    bool? aceito,
    double? valor,
  }) {
    return BoletoModel(
      boletoCodigo: boletoCodigo ?? this.boletoCodigo,
      cobrancaCodigo: cobrancaCodigo,
      pagadorCodigo: pagadorCodigo ?? this.pagadorCodigo,
      status: status ?? this.status,
      vencimento: vencimento ?? this.vencimento,
      mensagem: mensagem ?? this.mensagem,
      nossoNumero: nossoNumero ?? this.nossoNumero,
      codigoDeBarras: codigoDeBarras ?? this.codigoDeBarras,
      linhaDigitavel: linhaDigitavel ?? this.linhaDigitavel,
      link: link ?? this.link,
      aceito: aceito ?? this.aceito,
      valor: valor ?? this.valor,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'boletoCodigo': boletoCodigo,
      'pagadorCodigo': pagadorCodigo,
      'cobrancaCodigo': cobrancaCodigo,
      'status': status,
      'vencimento': vencimento,
      'nossoNumero': nossoNumero,
      'codigoDeBarras': codigoDeBarras,
      'linhaDigitavel': linhaDigitavel,
      'mensagem': mensagem,
      'link': link,
      'aceito': aceito,
      'valor': valor,
    };
  }

  factory BoletoModel.fromMap(Map<String, dynamic> map) {
    StatusBoleto statusBoleto = StatusBoleto.PENDENTE;

    if (map['status'] == 'Pago') {
      statusBoleto = StatusBoleto.PAGO;
    } else if (map['status'] == 'Cancelado') {
      statusBoleto = StatusBoleto.CANCELADO;
    }

    return BoletoModel(
      boletoCodigo: map['boletoCodigo'] ?? '',
      cobrancaCodigo: map['cobrancaCodigo'] ?? '',
      pagadorCodigo: map['pagadorCodigo'] ?? '',
      status: statusBoleto,
      vencimento: DateTime.parse(map['vencimento'] ?? ''),
      nossoNumero: map['nossoNumero'] ?? '',
      codigoDeBarras: map['codigoDeBarras'] ?? '',
      linhaDigitavel: map['linhaDigitavel'] ?? '',
      mensagem: map['mensagem'] ?? '',
      link: map['linkBoleto'] ?? '',
      aceito: map['aceito'] ?? false,
      valor: map['valor']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory BoletoModel.fromJson(String source) =>
      BoletoModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'BoletoModel(boletoCodigo: $boletoCodigo, pagadorCodigo: $pagadorCodigo, status: $status, vencimento: $vencimento, nossoNumero: $nossoNumero, codigoDeBarras: $codigoDeBarras, linhaDigitavel: $linhaDigitavel, link: $link, aceito: $aceito, valor: $valor)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BoletoModel &&
        other.boletoCodigo == boletoCodigo &&
        other.pagadorCodigo == pagadorCodigo &&
        other.cobrancaCodigo == cobrancaCodigo &&
        other.status == status &&
        other.vencimento == vencimento &&
        other.mensagem == mensagem &&
        other.nossoNumero == nossoNumero &&
        other.codigoDeBarras == codigoDeBarras &&
        other.linhaDigitavel == linhaDigitavel &&
        other.link == link &&
        other.aceito == aceito &&
        other.valor == valor;
  }

  @override
  int get hashCode {
    return boletoCodigo.hashCode ^
        pagadorCodigo.hashCode ^
        status.hashCode ^
        cobrancaCodigo.hashCode ^
        vencimento.hashCode ^
        nossoNumero.hashCode ^
        mensagem.hashCode ^
        codigoDeBarras.hashCode ^
        linhaDigitavel.hashCode ^
        link.hashCode ^
        aceito.hashCode ^
        valor.hashCode;
  }
}

enum StatusBoleto { PENDENTE, PAGO, CANCELADO }
