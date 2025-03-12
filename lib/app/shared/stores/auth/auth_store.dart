import 'dart:io';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../main.dart';
import '../../../models/email_e_cpf_checkout_model.dart';
import '../../../models/empresa_model.dart';
import '../../../models/user_model.dart';
import '../../../repositories/auth/auth_repository_interface.dart';
import '../../../repositories/minhasinformacoes/minhasinformacoes_repository.dart';
import '../../either.dart';

class AuthStore extends Store<int> {
  final IAuthRepositoryInterface _authRepository;
  final MinhasinformacoesRepository _minhasinformacoesRepository;

  AuthStore(this._authRepository, this._minhasinformacoesRepository)
      : super(0) {
    _initializeStore();
  }

  bool isLoggedIn = false;
  EmpresaModel empresa = EmpresaModel.getMock();
  String accessToken = '';

  UserModel user = UserModel(
    id: '',
    email: '',
    name: '',
    foto:
        'https://img.freepik.com/fotos-gratis/banner-de-folha-monstera-tropical-neon_53876-138943.jpg?w=1380&t=st=1726800675~exp=1726801275~hmac=0ac5975a7d4dcea1c6943545410057d2193c7188be33e9d4de88b58d18fa3883',
  );

  Future<void> _initializeStore() async {
    final token = await loadToken();
    if (token != null && token.isNotEmpty && token.length > 30) {
      setAcessToken(token);
      if (await getInformacoesCliente()) {
        isLoggedIn = true;
      }
    }
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwtToken', token);
  }

  Future<String?> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('jwtToken');

    if (jwtToken != null && jwtToken.isNotEmpty && jwtToken.length > 30) {
      return jwtToken;
    }
    return null;
  }

  Future<Either<String, EmailECPFCheckoutModel>> emailECpfCheckout({
    required String checkoutID,
  }) async {
    final Either<String, EmailECPFCheckoutModel> resposta =
        await _authRepository.emailECpfCheckout(checkoutID);

    return resposta;
  }

  Future<bool> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('jwtToken', '');
    prefs.remove('jwtToken');
    prefs.clear();
    return true;
  }

  Future<bool> getInformacoesDaEmpresa() async {
    final response =
        await _minhasinformacoesRepository.getInformacoesDaEmpresa();

    return response.fold(
      (l) {
        // EmpresaModel empresaModel = EmpresaModel.getMock();
        return false;
      },
      (EmpresaModel empresaModel) {
        empresa = empresaModel;
        return true;
      },
    );
  }

  Future<void> atualizarFirebaseToken() async {
    if (isTest) {
      return;
    }
    String fcmToken = '';

    try {
      if (kIsWeb) {
        fcmToken = (await FirebaseMessaging.instance.getToken(
                vapidKey:
                    "BE3xBM_8Hcg-LsBgr1wvd6npBYEsMOQmK3FkbBSmUYskIjpCLquM9X2BFeMDIGy_2jLhUDggNGxSaN5uE10dDSc"))
            .toString();
      } else if (Platform.isAndroid) {
        fcmToken = (await FirebaseMessaging.instance.getToken()).toString();
      }

      if (fcmToken.isNotEmpty) {
        await _minhasinformacoesRepository.atualizarFirebaseToken(
          fcmToken: fcmToken.toString(),
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<bool> getInformacoesCliente() async {
    final response = await _minhasinformacoesRepository.getMinhasinformacoes();

    return response.fold(
      (l) {
        return false;
      },
      (userModel) async {
        atualizarFirebaseToken();
        user = userModel;
        await getInformacoesDaEmpresa();

        update(Random().nextInt(100));
        return true;
      },
    );
  }

  Future<bool> removeAcessToken() async {
    accessToken = '';
    isLoggedIn = false;
    await deleteToken();
    update(Random().nextInt(100));

    return true;
  }

  setUser(UserModel user) {
    this.user = user;
  }

  setAcessToken(String token) {
    accessToken = token;
    saveToken(token);
    print("token é: $token");
  }

  Future<Either<String, UserModel>> logar({
    required String email,
    required String password,
  }) async {
    final Either<String, UserModel> resposta =
        await _authRepository.login(email, password);

    resposta.fold((l) {}, (UserModel userModel) {
      user = userModel;
      getInformacoesDaEmpresa();
      getInformacoesCliente();
    });

    return resposta;
  }

  Future<Either<String, String>> sair() async {
    await removeAcessToken();

    return Right("Você foi desconectado com sucesso");
  }

  Future<Either<String, UserModel>> cadastrar({
    required String empresaNomeFantasia,
    required String empresaDocumento,
    required String oab,
    required String responsavelEmail,
    required String responsavelSenha,
    required String responsavelNomeCompleto,
    required String checkoutID,
  }) async {
    final resposta = await _authRepository.cadastrar(
      empresaNomeFantasia,
      empresaDocumento,
      oab,
      responsavelEmail,
      responsavelSenha,
      responsavelNomeCompleto,
      checkoutID,
    );

    resposta.fold((l) {}, (UserModel userModel) {
      user = userModel;
    });

    return resposta;
  }

  Future<Either<String, String>> verificarEmail(String token) async {
    final resposta = await _authRepository.verificarEmail(token);

    return resposta;
  }
}
