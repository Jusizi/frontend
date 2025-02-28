import '../../models/caixa_movimentacao_model.dart';
import '../../models/caixa_movimentacao_nova_model.dart';
import '../../shared/either.dart';
import '../../shared/services/httpClient/DIOHttpClientServiceImplementation.dart';
import '../../shared/services/httpClient/IHttpClientServiceInterface.dart';
import 'financeiro_repository.dart';

class FinanceiroRepositoryImplementation implements FinanceiroRepository {
  late final IHttpClientServiceInterface _httpClientService;

  FinanceiroRepositoryImplementation() {
    _httpClientService = DIOHttpClientServiceImplementation();
  }

  @override
  Future<Either<String, bool>> lancarMovimentacao(
    CaixaMovimentacaoNovaModel caixaMovimentacaoModel,
  ) async {
    try {
      final response = await _httpClientService.post(
        endpoint: '/financeiro/movimentacao',
        body: {
          'planoDeContaCodigo': caixaMovimentacaoModel.planoDeContaCodigo,
          'contaBancariaCodigo': caixaMovimentacaoModel.contaBancariaCodigo,
          'dataMovimentacao': caixaMovimentacaoModel.dataMovimentacao,
          'descricao': caixaMovimentacaoModel.descricao,
          'valor': caixaMovimentacaoModel.valor,
        },
      );

      return response.fold((l) {
        return Left(l);
      }, (r) {
        return Right(true);
      });
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<CaixaMovimentacaoModel>>>
      buscarMovimentacoesDaContaBancaria(
    String contaBancariaCodigo,
  ) async {
    try {
      final response = await _httpClientService.get(
        '/financeiro/movimentacoes/$contaBancariaCodigo',
      );

      return response.fold((l) {
        return Left(l);
      }, (r) {
        var retorno = r.data.map<CaixaMovimentacaoModel>((e) {
          CaixaMovimentacaoModel objeto = CaixaMovimentacaoModel.fromMap(e);

          return objeto;
        }).toList();

        return Right(retorno);
      });
    } catch (e) {
      return Left(e.toString());
    }
  }
}
