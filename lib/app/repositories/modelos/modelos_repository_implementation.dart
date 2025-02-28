import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../models/modelo_model.dart';
import '../../models/variaveis_substituicao_model.dart';
import '../../shared/either.dart';
import '../../shared/services/httpClient/DIOHttpClientServiceImplementation.dart';
import '../../shared/services/httpClient/IHttpClientServiceInterface.dart';
import 'modelos_repository.dart';

class ModelosRepositoryImplementation implements ModelosRepository {
  late final IHttpClientServiceInterface _httpClientService;

  ModelosRepositoryImplementation() {
    _httpClientService = DIOHttpClientServiceImplementation();
  }

  @override
  Future<Either<String, String>> excluirModelo(String modeloCodigo) async {
    final resposta = await _httpClientService.delete(
      '/modelos/$modeloCodigo',
    );

    return resposta.fold(
      (l) => Left(l),
      (r) => Right('Modelo excluído com sucesso'),
    );
  }

  @override
  Future<Either<String, String>> downloadDocumentoPDF(
      String linkDownloadPDF) async {
    final directory = await getExternalStorageDirectory();
    final savePath = '${directory?.path}/documento.pdf';

    final bool resposta = await _httpClientService.downloadFile(
      urlExternalFile: linkDownloadPDF,
      localToSaveInDevice: savePath,
      onReceiveProgress: (count, total) {},
    );

    if (resposta) {
      return Right("Download foi realizado com sucesso");
    } else {
      return Left('Erro ao baixar o arquivo da url $linkDownloadPDF');
    }
  }

  @override
  Future<Either<String, List<ModeloModel>>> getModelos() async {
    final resposta = await _httpClientService.get(
      '/modelos',
    );

    return resposta.fold(
      (l) => Left(l),
      (r) {
        var retorno = r.data.map<ModeloModel>((e) {
          ModeloModel modelo = ModeloModel.fromMap(e);

          return modelo;
        }).toList();

        return Right(retorno);
      },
    );
  }

  List<VariaveisSubstituicaoModel> _adicionarUmNovoGrupoAVariaveis(
    String grupo,
    Map<String, dynamic> variaveis,
    List<VariaveisSubstituicaoModel> variaveisSubstituicao,
  ) {
    VariaveisSubstituicaoModel variaveisDoRequest = VariaveisSubstituicaoModel(
      grupo: grupo,
      variaveisSubstituicao: [],
    );
    variaveis.forEach((chave, valor) {
      VariavelSubstituicaoModel variavel = VariavelSubstituicaoModel(
        nome: chave,
        descricao: valor,
      );
      variaveisDoRequest.variaveisSubstituicao.add(variavel);
    });

    variaveisSubstituicao.add(variaveisDoRequest);

    return variaveisSubstituicao;
  }

  @override
  Future<Either<String, String>> gerarDocumentoApartirDoModeloParaOCliente({
    required String modeloCodigo,
    required String clienteCodigo,
  }) async {
    final resposta = await _httpClientService.get(
        '/clientes/gerardocumento/?modelo=$modeloCodigo&cliente=$clienteCodigo');

    return resposta.fold(
      (l) => Left(l),
      (r) => Right(r.data['link']),
    );
  }

  @override
  Future<Either<String, List<VariaveisSubstituicaoModel>>>
      obterVariaveisSubstituicao() async {
    List<VariaveisSubstituicaoModel> variaveisSubstituicao = [];

    _httpClientService
        .get(
          '/empresa/substituicoes',
        )
        .then(
          (resposta) => resposta.fold(
            (l) => Left(l),
            (r) => _adicionarUmNovoGrupoAVariaveis(
                'Empresa', r.data, variaveisSubstituicao),
          ),
        );

    _httpClientService
        .get(
          '/modelos/utils',
        )
        .then(
          (resposta) => resposta.fold(
            (l) => Left(l),
            (r) => _adicionarUmNovoGrupoAVariaveis(
                'Utils', r.data, variaveisSubstituicao),
          ),
        );

    _httpClientService
        .get(
          '/clientes/substituicoes',
        )
        .then(
          (resposta) => resposta.fold(
            (l) => Left(l),
            (r) => _adicionarUmNovoGrupoAVariaveis(
                'Cliente', r.data, variaveisSubstituicao),
          ),
        );

    return Right(variaveisSubstituicao);
  }

  @override
  Future<Either<String, String>> obterPreviewModelo(ModeloModel modelo) async {
    final resposta = await _httpClientService.get(
      '/modelos/preview/${modelo.codigo}',
    );

    return resposta.fold(
      (l) => Left(l),
      (r) => Right(r.data['link']),
    );
  }

  @override
  Future<Either<String, ModeloModel>> atualizarModelo(
    ModeloModel modelo,
    PlatformFile? documento,
  ) async {
    if (documento != null) {
      MultipartFile arrayfiles =
          MultipartFile.fromBytes(documento.bytes!, filename: documento.name);

      FormData formData = FormData.fromMap({
        "codigo": modelo.codigo,
        "nome": modelo.nome,
        "files[]": arrayfiles,
      });

      final resposta = await _httpClientService.put(
        endpoint: '/modelos',
        body: formData,
      );

      return resposta.fold(
        (l) => Left(l),
        (r) {
          return Right(modelo);
        },
      );
    }

    final resposta = await _httpClientService.put(
      endpoint: '/modelos',
      body: {
        "codigo": modelo.codigo,
        "nome": modelo.nome,
      },
    );

    return resposta.fold(
      (l) => Left(l),
      (r) => Right(modelo),
    );
  }

  @override
  Future<Either<String, ModeloModel>> criarModelo(
    ModeloModel modelo,
    PlatformFile documento,
  ) async {
    MultipartFile arrayfiles =
        MultipartFile.fromBytes(documento.bytes!, filename: documento.name);

    FormData formData =
        FormData.fromMap({"nome": modelo.nome, "files[]": arrayfiles});

    final resposta = await _httpClientService.post(
      endpoint: '/modelos',
      body: formData,
    );

    return resposta.fold(
      (l) => Left(l),
      (r) {
        return Right(modelo);
      },
    );
  }
}
