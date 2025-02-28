import '../../models/processo_listagem_model.dart';
import '../../models/processo_model.dart';
import '../../shared/either.dart';

abstract class ProcessosRepository {
  Future<Either<String, List<ProcessoListagemModel>>> getProcessos();
  Future<Either<String, String>> consultarMovimentacoesProcesso(
    ProcessoModel processo,
  );
  Future<Either<String, String>> solicitarAtualizacaoDoProcesso(
    ProcessoModel processo,
  );

  Future<Either<String, ProcessoModel>> getProcessoDetalhes(
    String processoCodigo,
  );

  Future<Either<String, String>> monitorarProcesso(String processoCodigo);
}
