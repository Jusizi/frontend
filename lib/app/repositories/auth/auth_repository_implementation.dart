import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../models/email_e_cpf_checkout_model.dart';
import '../../models/user_model.dart';
import '../../shared/either.dart';
import '../../shared/services/httpClient/AUTHDIOHttpClientServiceImplementation.dart';
import '../../shared/services/httpClient/IHttpClientServiceInterface.dart';
import '../../shared/stores/auth/auth_store.dart';
import 'auth_repository_interface.dart';

class AuthRepositoryImplementation implements IAuthRepositoryInterface {
  late final IHttpClientServiceInterface _httpClientService;

  AuthRepositoryImplementation() {
    _httpClientService = AUTHDIOHttpClientServiceImplementation(
      Dio(),
      const String.fromEnvironment('baseUrlAUTH',
          defaultValue: 'http://localhost:8052/'),
    );
  }

  @override
  Future<Either<String, String>> verificarEmail(String token) async {
    final response = await _httpClientService.post(
      endpoint: '/verificaremail',
      body: {
        'token': token,
      },
    );

    return response.fold(
      (l) {
        return Left(l.toString());
      },
      (r) {
        return Right(r.data['message']);
      },
    );
  }

  @override
  Future<Either<String, UserModel>> login(String email, String password) async {
    final authStore = Modular.get<AuthStore>();
    authStore.setUser(UserModel(
      id: '-',
      email: email,
      name: '-',
      foto: '-',
    ));

    final response = await _httpClientService.post(
      endpoint: '/login',
      body: {
        'email': email,
        'senha': password,
      },
    );

    return response.fold(
      (l) {
        return Left(l.toString());
      },
      (r) {
        if (r.data['access_token'] != null) {
          authStore.setAcessToken(r.data['access_token']);
        }

        return Right(authStore.user);
      },
    );
  }

  @override
  void logout() {}

  @override
  Future<Either<String, UserModel>> cadastrar(
    String empresaNomeFantasia,
    String empresaDocumento,
    String oab,
    String responsavelEmail,
    String responsavelSenha,
    String responsavelNomeCompleto,
    String checkoutID,
  ) async {
    final response = await _httpClientService.post(
      endpoint: '/empresa',
      body: {
        'nome_fantasia': empresaNomeFantasia,
        'numero_documento': empresaDocumento,
        'oab': oab,
        'responsavel_nome_completo': responsavelNomeCompleto,
        'responsavel_email': responsavelEmail,
        'responsavel_senha': responsavelSenha,
        'checkout_id': checkoutID,
      },
    );

    return response.fold(
      (l) {
        return Left(l.toString());
      },
      (r) {
        /*String codigoEmpresa = '';
        if (r.data is Map<String, dynamic>) {
          codigoEmpresa = r.data['empresa_codigo'] as String;
        } else if (r.data is String) {
          var dataParsed = jsonDecode(r.data) as Map<String, dynamic>;
          codigoEmpresa = dataParsed['empresa_codigo'] as String;
        }*/

        UserModel userModel = UserModel(
          id: r.data['empresa_codigo'],
          email: responsavelEmail,
          name: responsavelNomeCompleto,
          foto:
              'https://img.freepik.com/fotos-gratis/banner-de-folha-monstera-tropical-neon_53876-138943.jpg?w=1380&t=st=1726800675~exp=1726801275~hmac=0ac5975a7d4dcea1c6943545410057d2193c7188be33e9d4de88b58d18fa3883',
        );

        return Right(userModel);
      },
    );
  }

  @override
  Future<Either<String, EmailECPFCheckoutModel>> emailECpfCheckout(
      String checkoutID) async {
    final response = await _httpClientService.get('/pagamento?id=$checkoutID');

    return response.fold(
      (l) {
        return Left(l.toString());
      },
      (r) {
        return Right(
          EmailECPFCheckoutModel(
            checkoutID: r.data['checkoutID'],
            email: r.data['email'],
            cpf: r.data['cpf'],
          ),
        );
      },
    );
  }
}
