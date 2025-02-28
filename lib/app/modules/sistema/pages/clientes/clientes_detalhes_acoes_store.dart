import 'dart:math';

import 'package:flutter_triple/flutter_triple.dart';

import '../../../../models/cliente_model.dart';
import '../../../../models/processo_listagem_model.dart';
import '../../../../repositories/clientes/clientes_repository.dart';
import '../../../../shared/either.dart';
import 'clientes_store.dart';

class ClientesDetalhesAcoesStore extends Store<int> {
  late ClientesStore clientesStore;
  late final ClientesRepository _repository;
  late ClienteModel clienteSelecionado;

  ClientesDetalhesAcoesStore(this.clientesStore, this._repository) : super(0);

  void selecionarCliente(ClienteModel cliente) {
    clienteSelecionado = cliente;
    update(Random().nextInt(1000));
  }

  void buscarProcessosDoCliente() {
    obterProcessosCliente(clienteSelecionado);
  }

  List<ProcessoListagemModel> processos = [];
  bool loadingConsultandoProcessos = false;
  bool loadingConsultandoInformacoesNaInternet = false;
  bool naoHaProcessos = false;
  bool jaFoiConsultadoInformacoesNaInternet = false;

  Future<Either<String, String>> consultarInformacoesNaInternet(
      String documento) async {
    loadingConsultandoInformacoesNaInternet = true;
    jaFoiConsultadoInformacoesNaInternet = true;
    update(Random().nextInt(1000));

    final Either<String, String> resposta =
        await clientesStore.consultarInformacoesNaInternet(documento);

    loadingConsultandoInformacoesNaInternet = false;
    update(Random().nextInt(1000));
    return resposta;
  }

  Future<Either<String, String>> consultarProcessosClienteNaInternet(
      ClienteModel cliente) async {
    loadingConsultandoProcessos = true;
    update(Random().nextInt(1000));

    final Either<String, String> resposta =
        await clientesStore.consultarProcessosCliente(cliente);

    loadingConsultandoProcessos = false;
    update(Random().nextInt(1000));
    return resposta;
  }

  Future<void> obterProcessosCliente(ClienteModel cliente) async {
    loadingConsultandoProcessos = true;
    update(Random().nextInt(1000));

    final Either<String, List<ProcessoListagemModel>> resposta =
        await _repository.obterProcessosDoCliente(cliente);

    resposta.fold(
      (erro) {
        processos = [];
        naoHaProcessos = true;
      },
      (processos) {
        this.processos = processos;
        naoHaProcessos = false;
      },
    );

    loadingConsultandoProcessos = false;
    update(Random().nextInt(1000));
  }
}
