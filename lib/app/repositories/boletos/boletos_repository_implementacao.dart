import '../../models/boleto_model.dart';
import '../../shared/either.dart';
import '../../shared/services/httpClient/DIOHttpClientServiceImplementation.dart';
import '../../shared/services/httpClient/HttpClientResponse.dart';
import '../../shared/services/httpClient/IHttpClientServiceInterface.dart';
import 'boletos_repository.dart';

class BoletosRepositoryImplementacao implements BoletosRepository {
  late final IHttpClientServiceInterface _httpClientService;

  BoletosRepositoryImplementacao() {
    _httpClientService = DIOHttpClientServiceImplementation();
  }

  @override
  Future<Either<String, String>> consultarBoletoNoBanco(
    BoletoModel boleto,
  ) async {
    try {
      final Either<String, HttpClientResponse> response =
          await _httpClientService
              .get('/boleto/consultarnaplataforma/${boleto.boletoCodigo}');
      return response.fold(
        (l) => Left(l),
        (r) => Right("${r.data['message']} - Status: ${r.data['status']}"),
      );
    } on Exception catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> cancelarBoleto(BoletoModel boleto) async {
    try {
      final Either<String, HttpClientResponse> response =
          await _httpClientService.post(
        endpoint: '/boleto/cancelar',
        body: {
          'codigo': boleto.boletoCodigo,
        },
      );
      return response.fold(
        (l) => Left(l),
        (r) => Right(r.data['message']),
      );
    } on Exception catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, BoletoModel>> buscarInformacoesDoBoleto(
    String boletoCodigo,
  ) async {
    try {
      final Either<String, HttpClientResponse> response =
          await _httpClientService.get('/boleto/detalhes/$boletoCodigo');
      return response.fold(
        (l) => Left(l),
        (r) => Right(BoletoModel.fromMap(r.data)),
      );
    } on Exception catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> liquidarBoleto(BoletoModel boleto) async {
    try {
      final Either<String, HttpClientResponse> response =
          await _httpClientService.post(
        endpoint: '/boleto/liquidar',
        body: {
          'codigo': boleto.boletoCodigo,
          'data': '2024-11-11',
          'valor': boleto.valor,
        },
      );
      return response.fold(
        (l) => Left(l),
        (r) => Right(r.data['message']),
      );
    } on Exception catch (e) {
      return Left(e.toString());
    }
  }
}
