import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

import '../../../../../models/conta_bancaria_model.dart';
import '../../../../../repositories/contasBancarias/contasbancarias_repository.dart';
import '../../../../../shared/either.dart';
import '../contasbancarias_store.dart';

abstract class ContabancariaFormularioState {}

class ContabancariaFormularioStateInitial
    extends ContabancariaFormularioState {}

class ContabancariaFormularioStateLoading
    extends ContabancariaFormularioState {}

class ContabancariaFormularioStateError extends ContabancariaFormularioState {}

class ContabancariaFormularioStateSuccess
    extends ContabancariaFormularioState {}

class ContabancariaFormularioAlterado
    extends ContabancariaFormularioStateSuccess {}

class ContaBancariaFormularioStore extends Store<ContabancariaFormularioState> {
  late String contaBancariaCodigo;
  late final ContasBancariasRepository repository;
  ContaBancariaFormularioStore({
    required this.contaBancariaCodigo,
    required this.repository,
  }) : super(ContabancariaFormularioStateInitial()) {
    update(ContabancariaFormularioStateLoading());

    Modular.get<ContasBancariasStore>()
        .buscarInformacoesDaContaBancariaPorCodigo(contaBancariaCodigo)
        .then((Either<String, ContaBancariaModel> resposta) {
      resposta.fold((String erro) {
        update(ContabancariaFormularioStateError());
      }, (ContaBancariaModel conta) {
        contaBancaria = conta;
        nomeController.text = contaBancaria.nome;
        bancoController.text = contaBancaria.banco;
        chaveAPIController.text = contaBancaria.chaveAPI;
        clientIDController.text = contaBancaria.clientID;
        haInformacoesAlteradasNaConta = false;
        iconeWifiConexaoCombanco = conexaoComOBancoEstaOk
            ? const Icon(Icons.wifi, color: Colors.green)
            : const Icon(Icons.wifi, color: Colors.grey);
        feedBackConexaoComOBanco = conexaoComOBancoEstaOk
            ? const Text(
                "Conexão com o banco OK",
                style: TextStyle(color: Colors.green),
              )
            : const Text(
                "Conexão com o banco NOK",
                style: TextStyle(color: Colors.red),
              );

        if (chaveAPIController.text.isNotEmpty) {
          chaveAPIBackUP = chaveAPIController.text;
          chaveAPIHidden = "*".padRight(chaveAPIController.text.length, "*");

          chaveAPIController.text = chaveAPIHidden;
        }
        update(ContabancariaFormularioStateSuccess());
      });
    });
  }

  final TextEditingController nomeController = TextEditingController();
  final TextEditingController bancoController = TextEditingController();
  final TextEditingController chaveAPIController = TextEditingController();
  final TextEditingController clientIDController = TextEditingController();

  late ContaBancariaModel contaBancaria;
  bool loadingSalvandoContaBancaria = false;
  bool conexaoComOBancoEstaOk = false;
  bool tentandoConexaoComOBanco = false;
  bool haInformacoesAlteradasNaConta = false;
  Icon iconeWifiConexaoCombanco = const Icon(Icons.wifi, color: Colors.grey);
  Widget feedBackConexaoComOBanco = const Text(
    "Conexão com o banco OK",
    style: TextStyle(color: Colors.green),
  );
  String chaveAPIBackUP = "";
  String chaveAPIHidden = "";

  final Uri urllinkAPI =
      Uri.parse("https://www.asaas.com/customerConfigIntegrations/index");

  void verificaSeHaInformacoesAlteradasNaConta() {
    if (contaBancaria.nome != nomeController.text) {
      haInformacoesAlteradasNaConta = true;
      update(ContabancariaFormularioAlterado());
      return;
    }

    if (contaBancaria.chaveAPI != chaveAPIController.text) {
      haInformacoesAlteradasNaConta = true;
      update(ContabancariaFormularioAlterado());
      return;
    }

    haInformacoesAlteradasNaConta = false;
    update(ContabancariaFormularioStateSuccess());
  }

  Future<Either<String, String>> verificaConexaoComPlataformaAPIDeCobrancas(
      ContaBancariaModel contaBancaria) async {
    tentandoConexaoComOBanco = true;
    update(ContabancariaFormularioAlterado());

    try {
      final result =
          await repository.verificaConexaoComPlataformaAPIDeCobrancas(
        contaBancaria,
      );
      tentandoConexaoComOBanco = false;

      result.fold(
        (l) {
          conexaoComOBancoEstaOk = false;
          iconeWifiConexaoCombanco = const Icon(Icons.wifi, color: Colors.red);
          feedBackConexaoComOBanco = const Text(
            "Conexão com o banco NOK",
            style: TextStyle(color: Colors.red),
          );
          update(ContabancariaFormularioAlterado());

          return Left(l);
        },
        (r) {
          conexaoComOBancoEstaOk = true;
          iconeWifiConexaoCombanco =
              const Icon(Icons.wifi, color: Colors.green);
          feedBackConexaoComOBanco = const Text(
            "Conexão com o banco OK",
            style: TextStyle(color: Colors.green),
          );
          update(ContabancariaFormularioStateSuccess());
          return Right(r);
        },
      );
      return result;
    } on Exception catch (e) {
      conexaoComOBancoEstaOk = false;
      iconeWifiConexaoCombanco = const Icon(Icons.wifi, color: Colors.red);
      feedBackConexaoComOBanco = const Text(
        "Conexão com o banco NOK",
        style: TextStyle(color: Colors.red),
      );
      update(ContabancariaFormularioAlterado());

      return Left(e.toString());
    }
  }

  Future<Either<String, String>> atualizarContaBancaria(
    ContaBancariaModel contaBancariaAtualizada,
  ) async {
    try {
      final result =
          await repository.atualizarContaBancaria(contaBancariaAtualizada);
      result.fold(
        (l) => Left(l),
        (r) {
          contaBancaria = contaBancariaAtualizada;
          Right(r);
          haInformacoesAlteradasNaConta = false;
          update(ContabancariaFormularioStateSuccess());
        },
      );
      return result;
    } on Exception catch (e) {
      return Left(e.toString());
    }
  }

  void atualizarChaveAPI() {
    if (chaveAPIController.text.isEmpty) {
      chaveAPIController.text = chaveAPIBackUP;
      return;
    }

    if (chaveAPIController.text == chaveAPIHidden) {
      chaveAPIController.text = chaveAPIBackUP;
      return;
    }

    if (chaveAPIController.text != chaveAPIHidden) {
      chaveAPIBackUP = chaveAPIController.text;
      chaveAPIHidden = "*".padRight(chaveAPIController.text.length, "*");

      chaveAPIController.text = chaveAPIHidden;
    }
  }
}
