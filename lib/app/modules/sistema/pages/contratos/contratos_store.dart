import 'dart:math';

import 'package:flutter_triple/flutter_triple.dart';

import '../../../../models/contrato_listagem_model.dart';
import '../../../../models/contrato_model.dart';
import '../../../../repositories/contratos/contratos_repository.dart';
import '../../../../shared/either.dart';

class ContratosStore extends Store<int> {
  final ContratosRepository _repository;
  List<ContratoListagemModel> contratos = [];
  List<ContratoListagemModel> contratosCopy = [];

  ContratosStore(this._repository) : super(0);

  Future<Either<String, ContratoModel>> getContratoDetalhes(
    String contratoCodigo,
  ) async {
    try {
      final result = await _repository.getContratoDetalhes(contratoCodigo);
      return result.fold(
        (String erro) {
          return Left(erro);
        },
        (ContratoModel contrato) {
          return Right(contrato);
        },
      );
    } on Exception catch (e) {
      return Left(e.toString());
    }
  }

  Future<List<ContratoListagemModel>> getContratos() async {
    setLoading(true);
    try {
      final result = await _repository.getContratos();
      return result.fold(
        (l) {
          setError(Exception(l));
          setLoading(false);
          return [];
        },
        (r) {
          contratos = r;
          contratosCopy = r;
          setLoading(false);

          update((Random()).nextInt(99999));
          return r;
        },
      );
    } on Exception catch (e) {
      setError(e);
      setLoading(false);
      return [];
    }
  }
}
