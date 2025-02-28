import '../../models/email_e_cpf_checkout_model.dart';
import '../../models/user_model.dart';
import '../../shared/either.dart';

abstract class IAuthRepositoryInterface {
  Future<Either<String, UserModel>> login(String email, String password);
  Future<Either<String, UserModel>> cadastrar(
    String empresaNomeFantasia,
    String empresaDocumento,
    String oab,
    String responsavelEmail,
    String responsavelSenha,
    String responsavelNomeCompleto,
    String checkoutID,
  );
  void logout();

  Future<Either<String, String>> verificarEmail(String token);
  Future<Either<String, EmailECPFCheckoutModel>> emailECpfCheckout(
    String checkoutID,
  );
}
