import '../../models/conta_bancaria_model.dart';
import '../../shared/either.dart';
import '../../shared/services/httpClient/DIOHttpClientServiceImplementation.dart';
import '../../shared/services/httpClient/IHttpClientServiceInterface.dart';
import 'contasbancarias_repository.dart';

class ContasBancariasRepositoryImplementation
    implements ContasBancariasRepository {
  late final IHttpClientServiceInterface _httpClientService;

  ContasBancariasRepositoryImplementation() {
    _httpClientService = DIOHttpClientServiceImplementation();
  }

  @override
  Future<Either<String, String>> verificaConexaoComPlataformaAPIDeCobrancas(
    ContaBancariaModel contaBancaria,
  ) async {
    final resposta = await _httpClientService.post(
        endpoint: '/contasbancarias/verificaConexaoComPlataformaAPIDeCobrancas',
        body: {
          'codigo': contaBancaria.id,
        });

    return resposta.fold(
      (l) => Left(l),
      (r) => Right(r.data['message']),
    );
  }

  @override
  Future<Either<String, ContaBancariaModel>> getContaBancariaPorCodigo(
    String contaBancariaCodigo,
  ) async {
    final resposta = await _httpClientService.get(
      '/contasbancarias/detalhes/$contaBancariaCodigo',
    );

    return resposta.fold(
      (l) => Left(l),
      (r) {
        ContaBancariaModel contaBancaria = ContaBancariaModel.fromMap(r.data);

        return Right(contaBancaria);
      },
    );
  }

  @override
  Future<Either<String, String>> atualizarContaBancaria(
    ContaBancariaModel contaBancaria,
  ) async {
    final resposta = await _httpClientService.put(
      endpoint: '/contasbancarias',
      body: {
        'codigo': contaBancaria.id,
        'nome': contaBancaria.nome,
        'chaveAPI': contaBancaria.chaveAPI,
        'clientID': contaBancaria.clientID,
        'ambiente': contaBancaria.producao ? 'Producao' : 'Sandbox',
      },
    );

    return resposta.fold(
      (l) => Left(l),
      (r) => Right(r.data['message']),
    );
  }

  @override
  Future<Either<String, List<ContaBancariaModel>>> getContasBancarias() async {
    final resposta = await _httpClientService.get(
      '/contasbancarias',
    );

    return resposta.fold(
      (l) => Left(l),
      (r) {
        var retorno = r.data.map<ContaBancariaModel>((e) {
          ContaBancariaModel contaBancaria = ContaBancariaModel.fromMap(e);

          return contaBancaria;
        }).toList();

        return Right(retorno);
      },
    );
  }
}
