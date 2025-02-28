import '../../models/plano_de_conta_agrupado_model.dart';
import '../../models/plano_de_conta_model.dart';
import '../../shared/either.dart';
import '../../shared/services/httpClient/DIOHttpClientServiceImplementation.dart';
import '../../shared/services/httpClient/IHttpClientServiceInterface.dart';
import 'planodecontas_repository.dart';

class PlanodecontasRepositoryImplementation implements PlanodecontasRepository {
  late final IHttpClientServiceInterface _httpClientService;

  PlanodecontasRepositoryImplementation() {
    _httpClientService = DIOHttpClientServiceImplementation();
  }

  @override
  Future<Either<String, List<PlanoDeContaAgrupadoModel>>>
      getPlanodecontas() async {
    final resposta = await _httpClientService.get(
      '/planosdecontas/agrupados',
    );

    return resposta.fold(
      (l) => Left(l),
      (r) {
        final List<PlanoDeContaAgrupadoModel> retorno = [];

        r.data.forEach((key, value) {
          List<PlanoDeContaModel> planosDeConta = [];

          value.forEach((plano) {
            planosDeConta.add(PlanoDeContaModel.fromMap(plano));
          });

          retorno.add(
            PlanoDeContaAgrupadoModel(
              grupo: key,
              planosDeConta: planosDeConta,
            ),
          );
        });

        return Right(retorno);
      },
    );
  }
}
