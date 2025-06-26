import 'package:appjusizi/app/models/tarefa_listagem_model.dart';
import 'package:appjusizi/app/models/tarefa_model.dart';
import 'package:appjusizi/app/repositories/tarefas/tarefas_repository.dart';
import 'package:appjusizi/app/shared/either.dart';
import 'package:appjusizi/app/shared/services/httpClient/DIOHttpClientServiceImplementation.dart';
import 'package:appjusizi/app/shared/services/httpClient/IHttpClientServiceInterface.dart';

class TarefasRepositoryImplementation implements TarefasRepository {
  late final IHttpClientServiceInterface _httpClientService;

  TarefasRepositoryImplementation() {
    _httpClientService = DIOHttpClientServiceImplementation();
  }

  @override
  Future<Either<String, List<TarefaListagemModel>>> getTarefas() async {
    final resposta = await _httpClientService.get('/tarefas');

    return resposta.fold(
      (l) => Left(l),
      (r) {
        List<TarefaListagemModel> tarefas = (r.data as List).map((e) {
          return TarefaListagemModel.fromMap(e as Map<String, dynamic>);
        }).toList();
        return Right(tarefas);
      },
    );
  }

  @override
  Future<Either<String, String>> cadastrarTarefa(TarefaModel tarefa) async {
    final resposta = await _httpClientService.post(
      endpoint: '/tarefas',
      body: {
        'nome': tarefa.nome,
        'detalhes': tarefa.descricao,
      },
    );

    return resposta.fold(
      (l) => Left(l),
      (r) => Right('Tarefa cadastrada com sucesso'),
    );
  }
}
