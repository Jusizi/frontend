import 'package:flutter_triple/flutter_triple.dart';

import '../../../../models/caixa_movimentacao_model.dart';
import '../../../../models/caixa_movimentacao_nova_model.dart';
import '../../../../repositories/financeiro/financeiro_repository.dart';
import '../../../../shared/either.dart';

class CaixamovimentacoesStore extends Store<List<CaixaMovimentacaoModel>> {
  late final FinanceiroRepository _financeiroRepository;

  CaixamovimentacoesStore(this._financeiroRepository) : super([]);

  Future<Either<String, bool>> lancarMovimentacao(
      CaixaMovimentacaoNovaModel caixaMovimentacaoNovaModel) async {
    setLoading(true);

    final response = await _financeiroRepository
        .lancarMovimentacao(caixaMovimentacaoNovaModel);

    return response.fold(
      (error) {
        setError(error);
        setLoading(false);

        return Left(error);
      },
      (sucesso) {
        setLoading(false);
        return Right(sucesso);
      },
    );
  }

  Future<Either<String, List<CaixaMovimentacaoModel>>>
      getMovimentacoesDaContaBancaria(String contaBancariaCodigo) async {
    setLoading(true);

    final response = await _financeiroRepository
        .buscarMovimentacoesDaContaBancaria(contaBancariaCodigo);

    return response.fold(
      (error) {
        setError(error);
        setLoading(false);

        return Left(error);
      },
      (movimentacoes) {
        update(movimentacoes);

        setLoading(false);
        return Right(movimentacoes);
      },
    );
  }
}
