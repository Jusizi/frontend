import 'dart:math';

import 'package:flutter_triple/flutter_triple.dart';

import '../../../../models/conta_bancaria_model.dart';
import '../../../../repositories/contasBancarias/contasbancarias_repository.dart';
import '../../../../shared/either.dart';

class ContasBancariasStore extends Store<int> {
  final ContasBancariasRepository _repository;
  List<ContaBancariaModel> contasbancarias = [];

  ContasBancariasStore(this._repository) : super(0) {
    getContasBancarias();
  }

  ContaBancariaModel? getContaBancariaPorCodigo(String codigo) {
    return contasbancarias.firstWhere(
      (element) => element.id == codigo,
    );
  }

  Future<Either<String, ContaBancariaModel>>
      buscarInformacoesDaContaBancariaPorCodigo(
    String contaBancariaCodigo,
  ) async {
    try {
      final result =
          await _repository.getContaBancariaPorCodigo(contaBancariaCodigo);
      return result.fold(
        (l) {
          return Left(l);
        },
        (r) {
          return Right(r);
        },
      );
    } on Exception catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, List<ContaBancariaModel>>> getContasBancarias() async {
    setLoading(true);
    try {
      final result = await _repository.getContasBancarias();
      return result.fold(
        (l) {
          setError(Exception(l));
          setLoading(false);

          return Left(l);
        },
        (r) {
          contasbancarias = r;
          update((Random()).nextInt(99999));
          setLoading(false);
          return Right(r);
        },
      );
    } on Exception catch (e) {
      setError(e);
      setLoading(false);
      return Left(e.toString());
    }
  }
}
