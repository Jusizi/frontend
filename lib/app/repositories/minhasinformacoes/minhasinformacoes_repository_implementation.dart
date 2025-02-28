import '../../models/empresa_model.dart';
import '../../models/user_model.dart';
import '../../shared/either.dart';
import '../../shared/services/httpClient/DIOHttpClientServiceImplementation.dart';
import '../../shared/services/httpClient/IHttpClientServiceInterface.dart';
import 'minhasinformacoes_repository.dart';

class MinhasinformacoesRepositoryImplementation
    implements MinhasinformacoesRepository {
  late final IHttpClientServiceInterface _httpClientService;

  MinhasinformacoesRepositoryImplementation() {
    _httpClientService = DIOHttpClientServiceImplementation();
  }

  @override
  Future<Either<String, UserModel>> getMinhasinformacoes() async {
    final response = await _httpClientService.get('/minhasinformacoes');

    return response.fold(
      (l) {
        return Left(l.toString());
      },
      (r) {
        return Right(UserModel(
          id: r.data['codigo'],
          email: r.data['email'],
          name: r.data['nomeCompleto'],
          foto:
              'https://img.freepik.com/fotos-gratis/banner-de-folha-monstera-tropical-neon_53876-138943.jpg?w=1380&t=st=1726800675~exp=1726801275~hmac=0ac5975a7d4dcea1c6943545410057d2193c7188be33e9d4de88b58d18fa3883',
        ));
      },
    );
  }

  @override
  Future<Either<String, EmpresaModel>> getInformacoesDaEmpresa() async {
    final response = await _httpClientService.get('/empresa');

    return response.fold(
      (l) {
        return Left(l.toString());
      },
      (r) {
        return Right(EmpresaModel.fromMap(r.data));
      },
    );
  }

  @override
  Future<Either<String, bool>> atualizarFirebaseToken({
    required String fcmToken,
  }) async {
    final response = await _httpClientService.post(
      endpoint: '/atualizarfcmtoken',
      body: {
        'fcmToken': fcmToken,
      },
    );

    return response.fold(
      (l) {
        return Left(l.toString());
      },
      (r) {
        return Right(true);
      },
    );
  }
}
