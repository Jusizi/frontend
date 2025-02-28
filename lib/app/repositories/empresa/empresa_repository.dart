import '../../models/colaborador_model.dart';
import '../../shared/either.dart';

abstract class EmpresaRepository {
  Future<Either<String, List<ColaboradorModel>>> getColaboradores();

  Future<Either<String, ColaboradorModel>> addColaborador(
    ColaboradorModel colaboradorModel,
  );
}
