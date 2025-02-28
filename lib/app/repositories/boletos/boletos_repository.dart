import '../../models/boleto_model.dart';
import '../../shared/either.dart';

abstract class BoletosRepository {
  Future<Either<String, String>> consultarBoletoNoBanco(BoletoModel boleto);
  Future<Either<String, String>> cancelarBoleto(BoletoModel boleto);
  Future<Either<String, String>> liquidarBoleto(BoletoModel boleto);
  Future<Either<String, BoletoModel>> buscarInformacoesDoBoleto(
    String boletoCodigo,
  );
}
