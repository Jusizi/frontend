import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../models/modelo_model.dart';
import '../../../../models/variaveis_substituicao_model.dart';
import '../../../../repositories/modelos/modelos_repository.dart';
import '../../../../shared/either.dart';

class ModelosStore extends Store<int> {
  late final ModelosRepository _repository;

  List<VariaveisSubstituicaoModel> variaveisSubstituicao = [];
  List<ModeloModel> modelos = [];

  ModelosStore(this._repository) : super(0) {
    obterVariaveisSubstituicao();
    getModelos();
  }

  ModeloModel identificarModeloPeloCodigo(String codigo) {
    return modelos.firstWhere((element) => element.codigo == codigo);
  }

  Future<Either<String, String>> fazerDownloadDoDocumentoPDF(
      String linkDownloadPDF) async {
    try {
      Uri urliParaDownloadPDF = Uri.parse(linkDownloadPDF);
      if (await canLaunchUrl(urliParaDownloadPDF)) {
        await launchUrl(urliParaDownloadPDF);
        return Right('Download foi realizado com sucesso');
      } else {
        throw 'Não foi possível abrir o link: $linkDownloadPDF';
      }
    } catch (e) {
      return Left('Ops, parece que o link para download do PDF está inválido');
    }
  }

  Future<Either<String, List<VariaveisSubstituicaoModel>>>
      obterVariaveisSubstituicao() async {
    setLoading(true);
    try {
      final result = await _repository.obterVariaveisSubstituicao();
      return result.fold(
        (l) {
          setError(Exception(l));
          setLoading(false);
          return Left(l);
        },
        (r) {
          variaveisSubstituicao = r;
          setLoading(false);
          return Right(r);
        },
      );
    } on Exception catch (e) {
      setError(e);
      setLoading(false);
      return Left(e.toString());
    } finally {
      setLoading(false);
      update((Random()).nextInt(99999));
    }
  }

  Future<Either<String, String>> gerarDocumentoApartirDoModeloParaOCliente({
    required String modeloCodigo,
    required String clienteCodigo,
  }) async {
    setLoading(true);
    try {
      final result =
          await _repository.gerarDocumentoApartirDoModeloParaOCliente(
        modeloCodigo: modeloCodigo,
        clienteCodigo: clienteCodigo,
      );
      return result.fold(
        (l) {
          setError(Exception(l));
          setLoading(false);
          return Left(l);
        },
        (r) {
          setLoading(false);
          return Right(r);
        },
      );
    } on Exception catch (e) {
      setError(e);
      setLoading(false);
      return Left(e.toString());
    } finally {
      setLoading(false);
      update((Random()).nextInt(99999));
    }
  }

  Future<Either<String, String>> obterPreviewModelo(ModeloModel modelo) async {
    setLoading(true);
    try {
      final result = await _repository.obterPreviewModelo(modelo);
      return result.fold(
        (l) {
          setError(Exception(l));
          setLoading(false);
          return Left(l);
        },
        (r) {
          setLoading(false);
          return Right(r);
        },
      );
    } on Exception catch (e) {
      setError(e);
      setLoading(false);
      return Left(e.toString());
    } finally {
      setLoading(false);
      update((Random()).nextInt(99999));
    }
  }

  Future<void> getModelos() async {
    setLoading(true);
    try {
      final result = await _repository.getModelos();
      result.fold(
        (l) => setError(Exception(l)),
        (r) {
          modelos = r;

          update((Random()).nextInt(99999));
        },
      );
    } on Exception catch (e) {
      setError(e);
    } finally {
      setLoading(false);
      update((Random()).nextInt(99999));
    }
  }

  Future<Either<String, bool>> criarModelo({
    required ModeloModel modelo,
    required PlatformFile documento,
  }) async {
    setLoading(true);
    try {
      final result = await _repository.criarModelo(modelo, documento);
      return result.fold(
        (l) {
          setError(Exception(l));
          setLoading(false);
          return Left(l);
        },
        (r) {
          modelos.add(r);
          update((Random()).nextInt(99999));
          setLoading(false);
          return Right(true);
        },
      );
    } on Exception catch (e) {
      setError(e);
      setLoading(false);
      return Left(e.toString());
    } finally {
      setLoading(false);
      update((Random()).nextInt(99999));
    }
  }

  Future<Either<String, String>> excluirModelo(String modeloCodigo) async {
    ModeloModel modelo =
        modelos.firstWhere((element) => element.codigo == modeloCodigo);

    modelo.loadingExcluir = true;
    update((Random()).nextInt(99999));

    final result = await _repository.excluirModelo(modeloCodigo);

    modelos.removeWhere((element) => element.codigo == modeloCodigo);
    update((Random()).nextInt(99999));

    return result;
  }

  Future<Either<String, bool>> editarModelo({
    required ModeloModel modelo,
    PlatformFile? documento,
  }) async {
    setLoading(true);
    try {
      final result = await _repository.atualizarModelo(modelo, documento);
      return result.fold(
        (l) {
          setError(Exception(l));
          setLoading(false);
          return Left(l);
        },
        (r) {
          modelos.removeWhere((element) => element.codigo == r.codigo);
          modelos.add(r);
          update((Random()).nextInt(99999));
          setLoading(false);
          return Right(true);
        },
      );
    } on Exception catch (e) {
      setError(e);
      setLoading(false);
      return Left(e.toString());
    } finally {
      setLoading(false);
      update((Random()).nextInt(99999));
    }
  }
}
