import '../../models/plano_de_conta_agrupado_model.dart';
import '../../shared/either.dart';

abstract class PlanodecontasRepository {
  Future<Either<String, List<PlanoDeContaAgrupadoModel>>> getPlanodecontas();
}
