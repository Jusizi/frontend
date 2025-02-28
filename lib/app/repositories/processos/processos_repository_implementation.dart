import '../../models/processo_listagem_model.dart';
import '../../models/processo_model.dart';
import '../../shared/either.dart';
import '../../shared/services/httpClient/DIOHttpClientServiceImplementation.dart';
import '../../shared/services/httpClient/IHttpClientServiceInterface.dart';
import 'processos_repository.dart';

class ProcessosRepositoryImplementation implements ProcessosRepository {
  late final IHttpClientServiceInterface _httpClientService;

  ProcessosRepositoryImplementation() {
    _httpClientService = DIOHttpClientServiceImplementation();
  }

  @override
  Future<Either<String, String>> monitorarProcesso(
      String processoCodigo) async {
    final resposta = await _httpClientService.post(
      endpoint: '/processos/monitorar',
      body: {"cnj": processoCodigo},
    );

    return resposta.fold(
      (l) => Left(l),
      (r) => Right(r.data['message']),
    );
  }

  @override
  Future<Either<String, String>> solicitarAtualizacaoDoProcesso(
    ProcessoModel processo,
  ) async {
    final resposta = await _httpClientService.post(
      endpoint: '/processos/atualizar',
      body: {"cnj": processo.numeroCNJ},
    );

    return resposta.fold(
      (l) => Left(l),
      (r) => Right('Processo atualizado com sucesso'),
    );
  }

  @override
  Future<Either<String, ProcessoModel>> getProcessoDetalhes(
    String processoCodigo,
  ) async {
    final resposta = await _httpClientService.get(
      '/processos/detalhes/$processoCodigo',
    );

    return resposta.fold(
      (l) => Left(l),
      (r) {
        var processo = ProcessoModel.fromMap(r.data);

        return Right(processo);
      },
    );
  }

  @override
  Future<Either<String, List<ProcessoListagemModel>>> getProcessos() async {
    final resposta = await _httpClientService.get(
      '/processos',
    );

    return resposta.fold(
      (l) => Left(l),
      (r) {
        var retorno = r.data.map<ProcessoListagemModel>((e) {
          ProcessoListagemModel processo = ProcessoListagemModel.fromMap(e);

          return processo;
        }).toList();

        return Right(retorno);
      },
    );
  }

  @override
  Future<Either<String, String>> consultarMovimentacoesProcesso(
    ProcessoModel processo,
  ) async {
    final resposta = await _httpClientService.post(
      endpoint: '/processos/consultarMovimentacoes',
      body: {"cnj": processo.numeroCNJ},
    );

    return resposta.fold(
      (l) => Left(l),
      (r) => Right('Movimentações do processo consultadas com sucesso'),
    );
  }
}
