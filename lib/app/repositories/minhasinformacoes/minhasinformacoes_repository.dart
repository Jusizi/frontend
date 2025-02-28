import '../../models/empresa_model.dart';
import '../../models/user_model.dart';
import '../../shared/either.dart';

abstract class MinhasinformacoesRepository {
  Future<Either<String, UserModel>> getMinhasinformacoes();
  Future<Either<String, EmpresaModel>> getInformacoesDaEmpresa();

  Future<Either<String, bool>> atualizarFirebaseToken({
    required String fcmToken,
  });
}
