import 'package:flutter_triple/flutter_triple.dart';

import '../../../../models/plano_de_conta_agrupado_model.dart';
import '../../../../models/plano_de_conta_model.dart';
import '../../../../repositories/planodecontas/planodecontas_repository.dart';

class PlanoDeContasStore extends Store<List<PlanoDeContaAgrupadoModel>> {
  late final PlanodecontasRepository _repository;

  List<PlanoDeContaAgrupadoModel> get planodecontas => state;

  PlanoDeContasStore(this._repository) : super([]) {
    getPlanoDeContas();
  }

  PlanoDeContaModel? getPlanoDeContaPorCodigo(int codigo) {
    PlanoDeContaModel? planoDeConta;
    for (var element in state) {
      for (var plano in element.planosDeConta) {
        if (plano.codigo == codigo) {
          planoDeConta = plano;
        }
      }
    }
    return planoDeConta;
  }

  Future<void> getPlanoDeContas() async {
    setLoading(true);
    try {
      final result = await _repository.getPlanodecontas();
      result.fold(
        (l) {
          setError(Exception(l));
          setLoading(false);
        },
        (r) {
          update(r);
          setLoading(false);
        },
      );
    } on Exception catch (e) {
      setError(e);
      setLoading(false);
    }
  }
}
