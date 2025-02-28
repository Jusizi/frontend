import '../../models/caixa_movimentacao_model.dart';
import '../../models/caixa_movimentacao_nova_model.dart';
import '../../shared/either.dart';

abstract class FinanceiroRepository {
  Future<Either<String, List<CaixaMovimentacaoModel>>>
      buscarMovimentacoesDaContaBancaria(
    String contaBancariaCodigo,
  );

  Future<Either<String, bool>> lancarMovimentacao(
    CaixaMovimentacaoNovaModel caixaMovimentacaoModel,
  );
}
