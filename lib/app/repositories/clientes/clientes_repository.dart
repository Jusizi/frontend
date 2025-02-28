// ignore_for_file: camel_case_types
import '../../models/cliente_listagem_model.dart';
import '../../models/cliente_model.dart';
import '../../models/processo_listagem_model.dart';
import '../../shared/either.dart';

abstract class ClientesRepository {
  Future<Either<String, List<ClienteListagemModel>>> getClientes();

  Future<Either<String, List<ProcessoListagemModel>>> obterProcessosDoCliente(
    ClienteModel clienteModel,
  );
  Future<Either<String, ClienteModel>> addCliente(ClienteModel clienteModel);
  Future<Either<String, String>> consultarInformacoesNaInternet(
    String documento,
  );
  Future<Either<String, ClienteModel>> updateCliente(
    ClienteModel clienteModel,
  );
  Future<Either<String, ClienteModel>> deleteCliente(
    ClienteModel clienteModel,
  );

  Future<Either<String, String>> adicionarClientePorDocumento(
    String documento,
  );

  Future<Either<String, String>> consultarProcessosCliente(
    ClienteModel clienteModel,
  );
  Future<Either<String, ClienteModel>> buscarClientePorCodigo(
    String clienteCodigo,
  );
}
