import '../../models/contrato_listagem_model.dart';
import '../../models/contrato_model.dart';
import '../../shared/either.dart';

abstract class ContratosRepository {
  Future<Either<String, List<ContratoListagemModel>>> getContratos();

  Future<Either<String, ContratoModel>> getContratoDetalhes(
    String contratoCodigo,
  );
}
