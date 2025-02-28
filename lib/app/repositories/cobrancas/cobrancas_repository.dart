import '../../models/boleto_model.dart';
import '../../models/cobranca_listagem_model.dart';
import '../../models/cobranca_model.dart';
import '../../shared/either.dart';

abstract class CobrancasRepository {
  Future<Either<String, List<CobrancaListagemModel>>> buscarTodasAsCobrancas();

  Future<Either<String, CobrancaModel>> buscarInformacoesDaCobranca(
    String cobrancaCodigo,
  );

  Future<Either<String, String>> consultarBoletoNoBanco(BoletoModel boleto);
  Future<Either<String, String>> baixarBoleto(BoletoModel boleto);
  Future<Either<String, String>> lancarCobranca(CobrancaModel cobranca);
}
