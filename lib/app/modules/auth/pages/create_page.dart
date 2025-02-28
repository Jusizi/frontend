import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../main.dart';
import '../../../designSystem/snackbar_component.dart';
import '../../../models/email_e_cpf_checkout_model.dart';
import '../../../shared/stores/auth/auth_store.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final TextEditingController _nomeEmpresaController = TextEditingController();
  final TextEditingController _cpfCNPJController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _oabController = TextEditingController();
  final TextEditingController _nomeResponsavelController =
      TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController =
      TextEditingController();

  String checkoutID = '';
  bool loading = false;
  bool concordoComOsTermos = false;
  bool obscurecerSenha = true;
  bool obscurecerConfirmacaoSenha = true;
  bool CPFHabilitadoParaEditar = true;
  bool EmailHabilitadoParaEditar = true;
  Icon iconeShowPassword = const Icon(Icons.remove_red_eye_outlined);
  Icon iconeShowConfirmacaoPassword = const Icon(Icons.remove_red_eye_outlined);

  late AuthStore _authStore;

  emailECpfDoCheckout() async {
    // Vamos ver se existe na URL um parametro chamdo "id";
    checkoutID = (Uri.base.queryParameters['id'] ?? '').toString();

    if (checkoutID.isEmpty) {
      return;
    }

    final resposta = await _authStore.emailECpfCheckout(
      checkoutID: checkoutID,
    );

    resposta.fold((String erro) {
      SnackBarComponent().showError(erro);
    }, (EmailECPFCheckoutModel emailECpfCheckoutModel) {
      _emailController.text = emailECpfCheckoutModel.email;
      _cpfCNPJController.text = emailECpfCheckoutModel.cpf;

      CPFHabilitadoParaEditar = false;
      EmailHabilitadoParaEditar = false;

      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    _authStore = Modular.get<AuthStore>();

    _nomeEmpresaController.text = '';
    _emailController.text = '';
    _cpfCNPJController.text = '';
    _senhaController.text = '';
    _nomeResponsavelController.text = '';
    _oabController.text = '';
    _confirmarSenhaController.text = '';

    emailECpfDoCheckout();

    if (isTest && 1 == 2) {
      _nomeEmpresaController.text = 'Empresa Teste';
      _emailController.text = 'mattmaydana@gmail.com';
      _cpfCNPJController.text = '84167670097';
      _senhaController.text = '0hHMaydana%';
      _confirmarSenhaController.text = _senhaController.text;
      _nomeResponsavelController.text = 'Matheus Fogaca Maydana';
      _oabController.text = 'RS 123.456';
      concordoComOsTermos = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: GlobalKey(),
      backgroundColor: const Color.fromARGB(255, 248, 248, 248),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 500,
                  height: 1000,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/11.png',
                            width: 150,
                            height: 150,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                              "Cadastre-se ou acesse sua conta para começar a usar a Jusizi! 🚀"),
                          const SizedBox(height: 20),
                          const Text('Escritório',
                              style: TextStyle(fontSize: 17)),
                          TextField(
                            controller: _nomeEmpresaController,
                            decoration: const InputDecoration(
                              labelText: 'Nome do escritório',
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Responsável pelo escritório',
                            style: TextStyle(fontSize: 17),
                          ),
                          TextField(
                            controller: _nomeResponsavelController,
                            decoration: const InputDecoration(
                              labelText: 'Nome Completo (igual ao documento)',
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _cpfCNPJController,
                                  enabled: CPFHabilitadoParaEditar,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    CpfInputFormatter()
                                  ],
                                  decoration: const InputDecoration(
                                    labelText: 'CPF',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: TextField(
                                  controller: _oabController,
                                  decoration: const InputDecoration(
                                    labelText: 'OAB',
                                    hintText: 'RS 999.999',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                          const Text(
                            'Acesso ao sistema',
                            style: TextStyle(fontSize: 17),
                          ),
                          TextField(
                            controller: _emailController,
                            enabled: EmailHabilitadoParaEditar,
                            decoration: const InputDecoration(
                              labelText: 'E-mail',
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _senhaController,
                                  obscureText: obscurecerSenha,
                                  decoration: const InputDecoration(
                                    labelText: 'Senha',
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    obscurecerSenha = !obscurecerSenha;
                                    iconeShowPassword = obscurecerSenha
                                        ? const Icon(
                                            Icons.remove_red_eye_outlined)
                                        : const Icon(
                                            Icons.remove_red_eye_rounded);
                                  });
                                },
                                icon: iconeShowPassword,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _confirmarSenhaController,
                                  obscureText: obscurecerConfirmacaoSenha,
                                  decoration: const InputDecoration(
                                    labelText: 'Confirmar Senha',
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    obscurecerConfirmacaoSenha =
                                        !obscurecerConfirmacaoSenha;
                                    iconeShowConfirmacaoPassword =
                                        obscurecerConfirmacaoSenha
                                            ? const Icon(
                                                Icons.remove_red_eye_outlined)
                                            : const Icon(
                                                Icons.remove_red_eye_rounded);
                                  });
                                },
                                icon: iconeShowConfirmacaoPassword,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Checkbox(
                                value: concordoComOsTermos,
                                onChanged: (value) {
                                  setState(() {
                                    concordoComOsTermos = value!;
                                  });
                                },
                              ),
                              const Text('Li e concordo com os'),
                              TextButton(
                                onPressed: () => Navigator.pushNamed(
                                    context, '/auth/termos'),
                                child: const Text('Termos de uso'),
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          Visibility(
                            visible: loading,
                            child: const CircularProgressIndicator.adaptive(),
                          ),
                          Visibility(
                            visible: !loading,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_confirmarSenhaController.text !=
                                    _senhaController.text) {
                                  SnackBarComponent()
                                      .showError("As senhas estão diferentes.");
                                  return;
                                }

                                setState(() {
                                  loading = true;
                                });

                                if (!concordoComOsTermos) {
                                  SnackBarComponent().showError(
                                      'Você precisa concordar com os termos de uso');
                                  setState(() {
                                    loading = false;
                                  });
                                  return;
                                }

                                final resposta = await _authStore.cadastrar(
                                  empresaNomeFantasia:
                                      _nomeEmpresaController.text,
                                  empresaDocumento: _cpfCNPJController.text,
                                  oab: _oabController.text,
                                  responsavelEmail: _emailController.text,
                                  responsavelSenha: _senhaController.text,
                                  responsavelNomeCompleto:
                                      _nomeResponsavelController.text,
                                  checkoutID: checkoutID,
                                );

                                setState(() {
                                  loading = false;
                                });

                                resposta.fold(
                                  (l) {
                                    SnackBarComponent().showError(l);
                                  },
                                  (r) {
                                    SnackBarComponent().showSuccess(
                                        'Conta criada com sucesso');
                                    Modular.to.navigate('/auth/');
                                  },
                                );
                              },
                              child: const Text('Criar conta'),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: () {
                              Modular.to.navigate('/auth/');
                            },
                            child: const Text('Ja tem conta? Faça login'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        if (kIsWeb) {
                          launchUrl(Uri.parse(
                              'https://web.whatsapp.com/send?phone=5554984192072'));
                        } else {
                          launchUrl(
                              Uri.parse('whatsapp://send?phone=5554984192072'));
                        }
                      },
                      label: const Text('Suporte'),
                      icon: const FaIcon(FontAwesomeIcons.whatsapp),
                    ),
                    const Text(" · "),
                    TextButton.icon(
                      onPressed: () {
                        if (kIsWeb) {
                          launchUrl(
                              Uri.parse('https://instagram.com/jusizi.app'));
                        } else {
                          launchUrl(Uri.parse(
                              'instagram://user?username=jusizi.app'));
                        }
                      },
                      label: const Text("Instagram"),
                      icon: const FaIcon(FontAwesomeIcons.instagram),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
