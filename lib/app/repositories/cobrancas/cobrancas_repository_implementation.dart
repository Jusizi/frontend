import '../../models/boleto_model.dart';
import '../../models/cobranca_listagem_model.dart';
import '../../models/cobranca_model.dart';
import '../../shared/either.dart';
import '../../shared/services/httpClient/DIOHttpClientServiceImplementation.dart';
import '../../shared/services/httpClient/HttpClientResponse.dart';
import '../../shared/services/httpClient/IHttpClientServiceInterface.dart';
import 'cobrancas_repository.dart';

class CobrancasRepositoryImplementation implements CobrancasRepository {
  late final IHttpClientServiceInterface _httpClientService;

  CobrancasRepositoryImplementation() {
    _httpClientService = DIOHttpClientServiceImplementation();
  }

  @override
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

  @override
  Future<Either<String, CobrancaModel>> buscarInformacoesDaCobranca(
    String cobrancaCodigo,
  ) async {
    try {
      final Either<String, HttpClientResponse> response =
          await _httpClientService.get('/cobranca/detalhes/$cobrancaCodigo');

      return response.fold(
        (l) => Left(l),
        (r) {
          CobrancaModel objeto = CobrancaModel.fromMap(r.data);

          return Right(objeto);
        },
      );
    } on Exception catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> lancarCobranca(CobrancaModel cobranca) async {
    try {
      final Either<String, HttpClientResponse> response =
          await _httpClientService.post(
        endpoint: '/cobranca',
        body: {
          'clienteCodigo': cobranca.clienteCodigo,
          'descricao': cobranca.descricao,
          'meioDePagamento': cobranca.meioDePagamento.name,
          'juros': cobranca.juros,
          'multa': cobranca.multa,
          'parcelas': cobranca.parcelas,
          'dataVencimento':
              '${cobranca.dataVencimento.year}-${cobranca.dataVencimento.month}-${cobranca.dataVencimento.day}',
          'contaBancariaCodigo': cobranca.contaBancariaCodigo,
          'composicaoDaCobranca':
              cobranca.composicaoDaCobranca.map((itemDaComposicaoDaCobranca) {
            return {
              'descricao': itemDaComposicaoDaCobranca.descricao,
              'valor': itemDaComposicaoDaCobranca.valor,
              'planoDeContaCodigo':
                  itemDaComposicaoDaCobranca.planoDeConta.codigo,
            };
          }).toList(),
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
  Future<Either<String, String>> consultarBoletoNoBanco(
    BoletoModel boleto,
  ) async {
    try {
      final Either<String, HttpClientResponse> response =
          await _httpClientService
              .get('/cobranca/consultarboleto/${boleto.boletoCodigo}');

      return response.fold(
        (l) => Left(l),
        (r) => Right("${r.data['message']} - Status: ${r.data['status']}"),
      );
    } on Exception catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<CobrancaListagemModel>>>
      buscarTodasAsCobrancas() async {
    try {
      final Either<String, HttpClientResponse> response =
          await _httpClientService.get('/cobranca');

      return response.fold(
        (l) => Left(l),
        (r) {
          var retorno = r.data.map<CobrancaListagemModel>((e) {
            CobrancaListagemModel objeto = CobrancaListagemModel.fromMap(e);

            return objeto;
          }).toList();

          return Right(retorno);
        },
      );
    } on Exception catch (e) {
      return Left(e.toString());
    }
  }
}
