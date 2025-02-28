import '../../models/contrato_listagem_model.dart';
import '../../models/contrato_model.dart';
import '../../shared/either.dart';
import '../../shared/services/httpClient/DIOHttpClientServiceImplementation.dart';
import '../../shared/services/httpClient/HttpClientResponse.dart';
import '../../shared/services/httpClient/IHttpClientServiceInterface.dart';
import 'contratos_repository.dart';

class ContratosRepositoryImplementation implements ContratosRepository {
  late final IHttpClientServiceInterface _httpClientService;

  ContratosRepositoryImplementation() {
    _httpClientService = DIOHttpClientServiceImplementation();
  }

/*
 Future<Either<String, String>> baixarBoleto(BoletoModel boleto) async {
    try {
      final Either<String, HttpClientResponse> response =
          await _httpClientService
              .get('/cobranca/baixarboleto/${boleto.boletoCodigo}');

      return response.fold(
        (l) => Left(l),
        (r) => Right(r.data['message']),
      );
    } on Exception catch (e) {
      return Left(e.toString());
    }
  }

*/
  @override
  Future<Either<String, List<ContratoListagemModel>>> getContratos() async {
    try {
      final Either<String, HttpClientResponse> response =
          await _httpClientService.get('/contrato');

      return response.fold(
        (l) => Left(l),
        (r) {
          var retorno = r.data.map<ContratoListagemModel>((e) {
            ContratoListagemModel objeto = ContratoListagemModel.fromMap(e);

            return objeto;
          }).toList();

          return Right(retorno);
        },
      );
    } on Exception catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, ContratoModel>> getContratoDetalhes(
    String contratoCodigo,
  ) async {
    try {
      final Either<String, HttpClientResponse> response =
          await _httpClientService.get('/contrato/$contratoCodigo');

      return response.fold(
        (l) => Left(l),
        (r) {
          ContratoModel objeto = ContratoModel.fromMap(r.data);

          return Right(objeto);
        },
      );
    } on Exception catch (e) {
      return Left(e.toString());
    }
  }
}
