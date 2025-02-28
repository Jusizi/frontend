import '../../models/colaborador_model.dart';
import '../../shared/either.dart';
import '../../shared/services/httpClient/DIOHttpClientServiceImplementation.dart';
import '../../shared/services/httpClient/IHttpClientServiceInterface.dart';
import 'empresa_repository.dart';

class EmpresaRepositoryImplementation implements EmpresaRepository {
  late final IHttpClientServiceInterface _httpClientService;

  EmpresaRepositoryImplementation() {
    _httpClientService = DIOHttpClientServiceImplementation();
  }

  @override
  Future<Either<String, List<ColaboradorModel>>> getColaboradores() async {
    final resposta = await _httpClientService.get(
      '/business/colaboradores',
    );

    return resposta.fold(
      (l) => Left(l),
      (r) {
        return Right(
          r.data
              .map<ColaboradorModel>((e) => ColaboradorModel.fromJson(e))
              .toList(),
        );
      },
    );
  }

  @override
  Future<Either<String, ColaboradorModel>> addColaborador(
      ColaboradorModel colaboradorModel) async {
    final resposta = await _httpClientService.post(
      endpoint: '/business/colaboradores',
      body: {
        "nome": colaboradorModel.nome,
        "email": colaboradorModel.email,
      },
    );

    return resposta.fold(
      (l) => Left(l),
      (r) => Right(colaboradorModel),
    );
  }
}
