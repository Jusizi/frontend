// ignore_for_file: camel_case_types

import '../../models/conta_bancaria_model.dart';
import '../../shared/either.dart';

abstract class ContasBancariasRepository {
  Future<Either<String, List<ContaBancariaModel>>> getContasBancarias();

  Future<Either<String, String>> atualizarContaBancaria(
    ContaBancariaModel contaBancaria,
  );

  Future<Either<String, ContaBancariaModel>> getContaBancariaPorCodigo(
    String contaBancariaCodigo,
  );

  Future<Either<String, String>> verificaConexaoComPlataformaAPIDeCobrancas(
    ContaBancariaModel contaBancaria,
  );
}
