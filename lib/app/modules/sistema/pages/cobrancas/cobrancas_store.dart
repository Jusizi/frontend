import 'package:flutter_triple/flutter_triple.dart';

import '../../../../models/boleto_model.dart';
import '../../../../models/cobranca_listagem_model.dart';
import '../../../../models/cobranca_model.dart';
import '../../../../repositories/cobrancas/cobrancas_repository.dart';
import '../../../../shared/either.dart';
import '../clientes/clientes_store.dart';

class CobrancasStore extends Store<List<CobrancaListagemModel>> {
  late final CobrancasRepository _repository;
  late ClientesStore clientesStore;
  List<CobrancaListagemModel> cobrancas = [];

  CobrancasStore(this._repository, this.clientesStore) : super([]) {
    buscarTodasAsCobrancas();
  }

  Future<Either<String, CobrancaModel>> buscarInformacoesDaCobranca(
      String cobrancaCodigo) async {
    try {
      final Either<String, CobrancaModel> result =
          await _repository.buscarInformacoesDaCobranca(cobrancaCodigo);

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

  Future<Either<String, String>> lancarCobranca(CobrancaModel cobranca) async {
    try {
      final Either<String, String> result =
          await _repository.lancarCobranca(cobranca);

      return result.fold(
        (l) {
          setError(Exception(l));
          return Left(l);
        },
        (resposta) {
          buscarTodasAsCobrancas();
          return Right(resposta);
        },
      );
    } on Exception catch (e) {
      setError(e);
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> consultarBoletoNoBanco(
      BoletoModel boleto) async {
    try {
      final Either<String, String> result =
          await _repository.consultarBoletoNoBanco(boleto);

      return result.fold(
        (l) {
          setError(Exception(l));
          return Left(l);
        },
        (resposta) {
          if (!resposta.contains(boleto.status.name)) {
            buscarTodasAsCobrancas();
          }
          return Right(resposta);
        },
      );
    } on Exception catch (e) {
      setError(e);
      return Left(e.toString());
    }
  }

  Future<List<CobrancaListagemModel>> buscarTodasAsCobrancas() async {
    setLoading(true);
    try {
      final Either<String, List<CobrancaListagemModel>> result =
          await _repository.buscarTodasAsCobrancas();

      return result.fold(
        (l) {
          setError(Exception(l));
          setLoading(false);

          return [];
        },
        (r) {
          cobrancas = r;

          update(r);
          setLoading(false);

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
