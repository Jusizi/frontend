import 'dart:math';

import 'package:flutter_triple/flutter_triple.dart';

import '../../../../models/processo_listagem_model.dart';
import '../../../../models/processo_model.dart';
import '../../../../repositories/processos/processos_repository.dart';
import '../../../../shared/either.dart';

class ProcessosStore extends Store<int> {
  final ProcessosRepository _repository;
  List<ProcessoListagemModel> processos = [];
  List<ProcessoListagemModel> processosCopy = [];

  ProcessosStore(this._repository) : super(0);

  Future<void> filtrarProcessos(String filtro) async {
    setLoading(true);
    try {
      List<ProcessoListagemModel> processosFiltrados = processos
          .where(
            (element) => (element.numeroCNJ.contains(filtro) ||
                element.demandado.contains(filtro) ||
                element.demandante.contains(filtro)),
          )
          .toList();

      processos = processosFiltrados;
      update((Random()).nextInt(99999));
    } on Exception catch (e) {
      setError(e);
    } finally {
      setLoading(false);
    }
  }

  Future<Either<String, String>> monitorarProcesso(
      String processoCodigo) async {
    try {
      final result = await _repository.monitorarProcesso(processoCodigo);
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

  Future<Either<String, ProcessoModel>> getProcessoDetalhes(
    String processoCodigo,
  ) async {
    try {
      final result = await _repository.getProcessoDetalhes(processoCodigo);
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

  Future<List<ProcessoListagemModel>> getProcessos() async {
    setLoading(true);
    try {
      final result = await _repository.getProcessos();
      return result.fold(
        (l) {
          setError(Exception(l));
          setLoading(false);
          return [];
        },
        (r) {
          processos = r;
          processosCopy = r;
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

  Future<Either<String, bool>> solicitarAtualizacaoDoProcesso(
      ProcessoModel processo) async {
    setLoading(true);
    try {
      final result = await _repository.solicitarAtualizacaoDoProcesso(processo);
      return result.fold(
        (l) {
          setError(Exception(l));
          return Left(l);
        },
        (r) {
          setLoading(false);
          update((Random()).nextInt(99999));
          return Right(true);
        },
      );
    } on Exception catch (e) {
      setError(e);
      return Left(e.toString());
    } finally {
      //setLoading(false);
    }
  }

  Future<Either<String, bool>> consultarMovimentacoesProcesso(
      ProcessoModel processo) async {
    setLoading(true);
    try {
      final result = await _repository.consultarMovimentacoesProcesso(processo);
      return result.fold(
        (l) {
          setError(Exception(l));
          return Left(l);
        },
        (r) {
          setLoading(false);
          update((Random()).nextInt(99999));
          return Right(true);
        },
      );
    } on Exception catch (e) {
      setError(e);
      return Left(e.toString());
    } finally {
      //setLoading(false);
    }
  }
}
