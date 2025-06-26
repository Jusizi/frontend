import 'package:appjusizi/app/models/tarefa_listagem_model.dart';
import 'package:appjusizi/app/models/tarefa_model.dart';
import 'package:appjusizi/app/repositories/tarefas/tarefas_repository.dart';
import 'package:appjusizi/app/shared/either.dart';
import 'package:flutter_triple/flutter_triple.dart';

class TarefasStore extends Store<List<TarefaListagemModel>> {
  final TarefasRepository _repository;

  TarefasStore(this._repository) : super(<TarefaListagemModel>[]) {
    getTarefas();
  }

  Future<void> getTarefas() async {
    final result = await _repository.getTarefas();
    result.fold(
      (String error) => setError(error),
      (List<TarefaListagemModel> tarefas) => update(tarefas),
    );
  }

  Future<Either<String, String>> cadastrarTarefa(TarefaModel tarefa) async {
    final result = await _repository.cadastrarTarefa(tarefa);
    return result.fold(
      (String error) => Left(error),
      (String successMessage) {
        getTarefas(); // Atualiza a lista de tarefas após o cadastro
        return Right(successMessage);
      },
    );
  }
}
