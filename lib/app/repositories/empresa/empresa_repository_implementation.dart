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
      '/empresa/usuarios',
    );

    return resposta.fold(
      (l) => Left(l),
      (r) {
        return Right(
          r.data.map<ColaboradorModel>((e) {
            return ColaboradorModel.fromMap(e);
          }).toList(),
        );
      },
    );
  }

  @override
  Future<Either<String, ColaboradorModel>> addColaborador(
      ColaboradorModel colaboradorModel) async {
    final resposta = await _httpClientService.post(
      endpoint: '/empresa/usuarios',
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
