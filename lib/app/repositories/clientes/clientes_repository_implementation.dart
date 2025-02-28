import '../../models/cliente_listagem_model.dart';
import '../../models/cliente_model.dart';
import '../../models/processo_listagem_model.dart';
import '../../shared/either.dart';
import '../../shared/services/httpClient/DIOHttpClientServiceImplementation.dart';
import '../../shared/services/httpClient/IHttpClientServiceInterface.dart';
import 'clientes_repository.dart';

class ClientesRepositoryImplementation implements ClientesRepository {
  late final IHttpClientServiceInterface _httpClientService;

  ClientesRepositoryImplementation() {
    _httpClientService = DIOHttpClientServiceImplementation();
  }

  @override
  Future<Either<String, ClienteModel>> buscarClientePorCodigo(
    String clienteCodigo,
  ) async {
    final resposta = await _httpClientService.get(
      '/clientes/detalhes/$clienteCodigo',
    );

    return resposta.fold(
      (l) => Left(l),
      (r) => Right(ClienteModel.fromMap(r.data)),
    );
  }

  @override
  Future<Either<String, List<ClienteListagemModel>>> getClientes() async {
    final resposta = await _httpClientService.get(
      '/clientes',
    );

    return resposta.fold(
      (l) => Left(l),
      (r) {
        var retorno = r.data.map<ClienteListagemModel>((e) {
          ClienteListagemModel cliente = ClienteListagemModel.fromMap(e);

          return cliente;
        }).toList();

        return Right(retorno);
      },
    );
  }

  @override
  Future<Either<String, String>> adicionarClientePorDocumento(
    String documento,
  ) async {
    final resposta = await _httpClientService.post(
      endpoint: '/clientes/consultarinformacoesnainternet',
      body: {
        "documento": documento,
      },
    );

    return resposta.fold(
      (l) => Left(l),
      (r) {
        return Right(r.data['message']);
      },
    );
  }

  @override
  Future<Either<String, ClienteModel>> addCliente(
      ClienteModel clienteModel) async {
    final resposta = await _httpClientService.post(
      endpoint: '/clientes',
      body: {
        "name": clienteModel.nomeCompleto,
        "email": clienteModel.email,
        "telefone": clienteModel.telefone,
        "documento": clienteModel.documento,
      },
    );

    return resposta.fold(
      (l) => Left(l),
      (r) {
        return Right(
          ClienteModel.fromJson(r.data),
        );
      },
    );
  }

  @override
  Future<Either<String, List<ProcessoListagemModel>>> obterProcessosDoCliente(
    ClienteModel clienteModel,
  ) async {
    final resposta = await _httpClientService
        .get('/clientes/processos/${clienteModel.codigo}');

    return resposta.fold(
      (l) => Left(l),
      (r) {
        if (r.data == null || r.data.isEmpty) {
          return Right([]);
        }

        var retorno = r.data.map<ProcessoListagemModel>((e) {
          ProcessoListagemModel processo = ProcessoListagemModel.fromMap(e);

          return processo;
        }).toList();

        return Right(retorno);
      },
    );
  }

  @override
  Future<Either<String, String>> consultarInformacoesNaInternet(
    String documento,
  ) async {
    final resposta = await _httpClientService.post(
      endpoint: '/clientes/consultarinformacoesnainternet',
      body: {
        "documento": documento,
      },
    );

    return resposta.fold(
      (l) => Left(l),
      (r) => Right(r.data['message']),
    );
  }

  @override
  Future<Either<String, ClienteModel>> updateCliente(
      ClienteModel clienteModel) async {
    final resposta = await _httpClientService.put(
      endpoint: '/clientes',
      body: {
        "id": clienteModel.codigo,
        "nome": clienteModel.nomeCompleto,
        "telefone": clienteModel.telefone,
        "email": clienteModel.email,
        "documento": clienteModel.documento,
        "endereco": clienteModel.logradouro,
        "enderecoNumero": clienteModel.numero,
        "enderecoBairro": clienteModel.bairro,
        "enderecoCidade": clienteModel.cidade,
        "enderecoEstado": clienteModel.estado,
        "enderecoCep": clienteModel.cep,
        "enderecoComplemento": clienteModel.complemento,
        "nomeMae": clienteModel.nomeDaMae,
        "sexo": clienteModel.sexo,
        "dataNascimento": clienteModel.dataAniversario,
      },
    );

    return resposta.fold(
      (l) => Left(l),
      (r) => Right(clienteModel),
    );
  }

  @override
  Future<Either<String, ClienteModel>> deleteCliente(
      ClienteModel clienteModel) async {
    final resposta =
        await _httpClientService.delete('/cliente?id=${clienteModel.codigo}');

    return resposta.fold(
      (l) => Left(l),
      (r) => Right(clienteModel),
    );
  }

  @override
  Future<Either<String, String>> consultarProcessosCliente(
    ClienteModel clienteModel,
  ) async {
    final resposta = await _httpClientService.post(
      endpoint: '/clientes/consultarProcessos',
      body: {
        "documento": clienteModel.documento,
      },
    );

    return resposta.fold(
      (l) => Left(l),
      (r) => Right(r.data['message']),
    );
  }
}
