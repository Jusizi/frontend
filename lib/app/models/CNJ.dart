import 'dart:core';

class CNJ {
  final String nome =
      'Conselho Nacional de Justiça'; // Já inicializado diretamente
  late String _value;
  final String data;

  CNJ(this.data) {
    if (!validarNumeroUnicoProcesso(data)) {
      throw CNJException(
          'O número Conselho Nacional de Justiça (CNJ) está inválido. - $data');
    }
    _value = mascara(data, '#######-##.####.#.##.####');
  }

  bool validarNumeroUnicoProcesso(String numero) {
    int bcmod(String x, int y) {
      int take = 5;
      String mod = '';

      try {
        while (x.isNotEmpty) {
          int a = int.parse(mod + x.substring(0, take));
          x = x.substring(take);
          mod = (a % y).toString();
        }
      } catch (e) {
        return -1;
      }

      return int.parse(mod);
    }

    // Remove todos os pontos e traços
    String numeroProcesso = numero.replaceAll(RegExp(r'[.-]'), '');

    if (numeroProcesso.length < 14 ||
        !RegExp(r'^\d+$').hasMatch(numeroProcesso)) {
      return false;
    }

    int digitoVerificadorExtraido = int.parse(numeroProcesso.substring(
        numeroProcesso.length - 13, numeroProcesso.length - 11));

    String vara = numeroProcesso.substring(
        numeroProcesso.length - 4, numeroProcesso.length); // Vara
    String tribunal = numeroProcesso.substring(
        numeroProcesso.length - 6, numeroProcesso.length - 4); // Tribunal
    String ramo = numeroProcesso.substring(
        numeroProcesso.length - 7, numeroProcesso.length - 6); // Ramo
    String anoInicio = numeroProcesso.substring(
        numeroProcesso.length - 11, numeroProcesso.length - 7); // Ano
    int tamanho = numeroProcesso.length - 13;
    String numeroSequencial = numeroProcesso
        .substring(0, tamanho)
        .padLeft(7, '0'); // Número sequencial

    int digitoVerificadorCalculado =
        98 - bcmod('$numeroSequencial$anoInicio$ramo$tribunal$vara' '00', 97);

    return digitoVerificadorExtraido == digitoVerificadorCalculado;
  }

  String mascara(String numero, String formato) {
    int index = 0;
    String resultado = '';
    for (int i = 0; i < formato.length; i++) {
      if (formato[i] == '#') {
        if (index < numero.length) {
          resultado += numero[index];
          index++;
        } else {
          resultado += ' ';
        }
      } else {
        resultado += formato[i];
      }
    }
    return resultado;
  }

  String get value => _value;
}

class CNJException implements Exception {
  final String message;

  CNJException(this.message);

  @override
  String toString() => message;
}
