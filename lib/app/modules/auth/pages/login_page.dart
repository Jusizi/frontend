import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../main.dart';
import '../../../designSystem/snackbar_component.dart';
import '../../../models/user_model.dart';
import '../../../shared/either.dart';
import '../../../shared/stores/auth/auth_store.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  String mensagemErro = '';

  bool loading = false;
  bool obscurecerSenha = true;

  late AuthStore _authStore;

  Icon iconeShowPassword = const Icon(Icons.remove_red_eye_outlined);

  @override
  void initState() {
    super.initState();
    _authStore = Modular.get<AuthStore>();

    _emailController.text = _authStore.user.email;
    _senhaController.text = '';

    if (isTest) {
      _emailController.text = 'mattmaydana@gmail.com';
      _senhaController.text = '0hHMaydana%';
      //'0hHMaydana%';
      Future.delayed(const Duration(seconds: 1), clicouEntrar);
    }
  }

  Future<void> clicouEntrar() async {
    setState(() {
      loading = true;
    });

    final Either<String, UserModel> resposta = await _authStore.logar(
      email: _emailController.text,
      password: _senhaController.text,
    );

    setState(() {
      loading = false;
    });

    resposta.fold(
      (l) {
        SnackBarComponent().showError(l);
        setState(() {
          mensagemErro = l;
        });
      },
      (r) => Modular.to.pushNamedAndRemoveUntil('/sistema/', (p0) => false),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 248, 248),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                SizedBox(
                  width: 500,
                  height: 650,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Faça uma imagem de logo para o seu app e coloque aqui borda arredondada
                        Image.asset(
                          'assets/icons/11.png',
                          width: 200,
                          height: 200,
                        ),
                        const SizedBox(height: 10),
                        const Text("Seja bem-vindo!! 👏"),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 10, bottom: 20),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _emailController,
                                  decoration: const InputDecoration(
                                    labelText: 'E-mail',
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  _emailController.text = '';
                                },
                                icon: const Icon(Icons.email_outlined),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 10, bottom: 20),
                          child: Row(
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
                        ),
                        const SizedBox(height: 10),
                        Visibility(
                          visible: loading,
                          child: const CircularProgressIndicator.adaptive(),
                        ),
                        Visibility(
                          visible: mensagemErro.isNotEmpty && !loading,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(mensagemErro,
                                style: const TextStyle(color: Colors.red)),
                          ),
                        ),
                        Visibility(
                          visible: !loading,
                          child: ElevatedButton(
                            onPressed: clicouEntrar,
                            child: const Text('Entrar'),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () {
                            Modular.to.navigate('/auth/create');
                          },
                          child: const Text('Não tem conta? Cadastre-se'),
                        ),
                      ],
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
