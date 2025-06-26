import 'package:appjusizi/app/models/tarefa_listagem_model.dart';
import 'package:appjusizi/app/models/tarefa_model.dart';
import 'package:appjusizi/app/shared/either.dart';

abstract class TarefasRepository {
  Future<Either<String, List<TarefaListagemModel>>> getTarefas();
  Future<Either<String, String>> cadastrarTarefa(TarefaModel tarefa);
}
