import 'dart:math';

import 'package:flutter_triple/flutter_triple.dart';

import '../../../../models/colaborador_model.dart';
import '../../../../repositories/empresa/empresa_repository.dart';

class EmpresaStore extends Store<int> {
  final EmpresaRepository _repository;
  List<ColaboradorModel> colaboradores = [];

  EmpresaStore(this._repository) : super(0) {
    getColaboradores();
  }

  Future<void> getColaboradores() async {
    setLoading(true);
    try {
      final result = await _repository.getColaboradores();
      result.fold(
        (l) => setError(Exception(l)),
        (r) {
          colaboradores = r;
          update((Random()).nextInt(99999));
        },
      );
    } on Exception catch (e) {
      setError(e);
    }
    setLoading(false);
  }

  Future<String> addColaborador(ColaboradorModel colaboradorModel) async {
    final result = await _repository.addColaborador(colaboradorModel);
    result.fold(
      (l) => {},
      (novoColaborador) {
        colaboradores.add(novoColaborador);
        update((Random()).nextInt(99999));
      },
    );

    return result.fold((l) {
      throw Exception(l);
    }, (r) => 'Colaborador adicionado com sucesso');
  }
}
