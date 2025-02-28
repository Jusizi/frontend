import 'package:flutter_triple/flutter_triple.dart';

import '../../../../models/boleto_model.dart';
import '../../../../repositories/boletos/boletos_repository.dart';
import '../../../../shared/either.dart';

class BoletosStore extends Store<int> {
  late final BoletosRepository _repository;

  BoletosStore(this._repository) : super(0);

  Future<Either<String, BoletoModel>> buscarInformacoesDoBoleto(
      String boletoCodigo) async {
    final Either<String, BoletoModel> response =
        await _repository.buscarInformacoesDoBoleto(boletoCodigo);

    return response;
  }

  Future<Either<String, String>> consultarBoletoNoBanco(
    BoletoModel boleto,
  ) async {
    final Either<String, String> response =
        await _repository.consultarBoletoNoBanco(boleto);

    return response;
  }

  Future<Either<String, String>> cancelarBoleto(BoletoModel boleto) async {
    final Either<String, String> response =
        await _repository.cancelarBoleto(boleto);

    return response;
  }

  Future<Either<String, String>> liquidarBoleto(BoletoModel boleto) async {
    final Either<String, String> response =
        await _repository.liquidarBoleto(boleto);

    return response;
  }
}
