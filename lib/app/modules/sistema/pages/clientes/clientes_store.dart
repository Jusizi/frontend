import 'package:flutter_triple/flutter_triple.dart';

import '../../../../models/cliente_listagem_model.dart';
import '../../../../models/cliente_model.dart';
import '../../../../models/processo_listagem_model.dart';
import '../../../../repositories/clientes/clientes_repository.dart';
import '../../../../shared/either.dart';
import '../../../../shared/errors/GenericException.dart';

class ClientesStore extends Store<List<ClienteListagemModel>> {
  final ClientesRepository _repository;

  ClientesStore(this._repository) : super(<ClienteListagemModel>[]) {
    getClientes();
  }

  List<ClienteListagemModel> clientes = [];
  List<ClienteListagemModel> clientesCopy = [];

  void restaurarClientesdaCopia() {
    setLoading(true);
    update([...clientesCopy]);
    setLoading(false);
  }

  void atualizarState() {
    setLoading(true);
    update([...state]);
    setLoading(false);
  }

  ClienteListagemModel getClientePorCodigo(String codigo) {
    return clientesCopy.firstWhere((element) => element.codigo == codigo);
  }

  ClienteListagemModel getClientePorDocumento(String documento) {
    return clientesCopy.firstWhere((element) => element.documento == documento);
  }

  Future<void> filtrarClientes(String filtro) async {
    setLoading(true);
    try {
      filtro = filtro.toLowerCase();
      List<ClienteListagemModel> clientesFiltrados = state
          .where(
            (element) => (element.nomeCompleto.toLowerCase().contains(filtro) ||
                element.documento.toLowerCase().contains(filtro) ||
                element.whatsapp.toLowerCase().contains(filtro)),
          )
          .toList();

      clientesCopy = clientesFiltrados;
      if (clientesCopy.isEmpty) {
        if (filtro.isEmpty) {
          clientesCopy = clientes;
        }
      }
      update([...clientesCopy]);
    } on Exception catch (e) {
      setError(e);
    } finally {
      setLoading(false);
    }
  }

  Future<Either<String, List<ProcessoListagemModel>>> obterProcessosDoCliente(
    ClienteModel cliente,
  ) async {
    final result = await _repository.obterProcessosDoCliente(cliente);
    return result.fold(
      (l) {
        return Left(l);
      },
      (retorno) {
        return Right(retorno);
      },
    );
  }

  Future<Either<String, String>> consultarProcessosCliente(
      ClienteModel clienteModel) async {
    final result = await _repository.consultarProcessosCliente(clienteModel);
    return result.fold(
      (l) {
        return Left(l);
      },
      (retorno) {
        return Right(retorno);
      },
    );
  }

  Future<Either<String, String>> consultarInformacoesNaInternet(
    String documento,
  ) async {
    final result = await _repository.consultarInformacoesNaInternet(documento);

    return result.fold(
      (l) => Left(l),
      (r) => Right('Cliente adicionado com sucesso'),
    );
  }

  Future<Either<String, String>> adicionarClientePorDocumento(
      String documento) async {
    final result = await _repository.adicionarClientePorDocumento(documento);
    return result.fold(
      (l) {
        return Left(l);
      },
      (retorno) {
        return Right(retorno);
      },
    );
  }

  Future<void> getClientesListagem() async {
    setLoading(true);
    try {
      final result = await getClientes();
      clientes = result;
      clientesCopy = result;
      update([...clientes]);
      setLoading(false);
    } on Exception catch (e) {
      setError(e);
      setLoading(false);
    }
  }

  Future<List<ClienteListagemModel>> getClientes() async {
    final result = await _repository.getClientes();

    clientes = result.fold(
      (l) {
        return [];
      },
      (r) {
        return r;
      },
    );

    clientesCopy = clientes;

    return clientes;
  }

  Future<String> addCliente(ClienteModel clienteModel) async {
    final result = await _repository.addCliente(clienteModel);
    result.fold(
      (l) => {},
      (novoCliente) => update([...state]),
    );

    return result.fold((l) {
      throw GenericException(l);
    }, (r) => 'Cliente adicionado com sucesso');
  }

  Future<String> updateCliente(ClienteModel clienteModel) async {
    final result = await _repository.updateCliente(clienteModel);
    result.fold(
      (l) => {},
      (novoCliente) => {
        update([...state])
      },
    );

    return result.fold((l) {
      throw GenericException(l);
    }, (r) => 'Cliente adicionado com sucesso');
  }

  Future<String> deleteCliente(ClienteModel clienteModel) async {
    final result = await _repository.deleteCliente(clienteModel);
    result.fold(
      (l) => {},
      (novoCliente) => {
        state.removeWhere((element) => element.codigo == novoCliente.codigo),
        update([...state])
      },
    );

    return result.fold((l) {
      throw GenericException(l);
    }, (r) => 'Cliente adicionado com sucesso');
  }

  Future<Either<String, ClienteModel>> buscarClientePorCodigo(
      String clienteCodigo) async {
    final result = await _repository.buscarClientePorCodigo(clienteCodigo);
    return result.fold(
      (l) {
        return Left(l);
      },
      (r) {
        return Right(r);
      },
    );
  }
}
