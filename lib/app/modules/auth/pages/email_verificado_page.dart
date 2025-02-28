import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../shared/either.dart';
import '../../../shared/stores/auth/auth_store.dart';

class EmailVerificadoPage extends StatefulWidget {
  const EmailVerificadoPage({super.key});

  @override
  State<EmailVerificadoPage> createState() => _EmailVerificadoPageState();
}

class _EmailVerificadoPageState extends State<EmailVerificadoPage> {
  late AuthStore _authStore;

  Color backgroundColor = Colors.white;

  @override
  void initState() {
    super.initState();

    _authStore = Modular.get<AuthStore>();

    tryVerify();
  }

  String getToken() {
    return Uri.base.queryParameters['token'] ?? '';
  }

  tryVerify() async {
    final String token = getToken();

    final Either<String, String> resposta =
        await _authStore.verificarEmail(token);
    resposta.fold((erro) {
      setState(() {
        backgroundColor = Colors.red[300]!;
        body = Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline_rounded,
                        size: 100, color: Colors.red[300]),
                    const Text(
                      'Erro ao verificar email',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(erro),
                  ],
                ),
              ),
            ),
          ),
        );
      });
    }, (r) {
      setState(() {
        backgroundColor = Colors.green[300]!;
        body = Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle_outline_rounded,
                        size: 100, color: Colors.green[300]),
                    const SizedBox(height: 20),
                    Text(r),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Modular.to.pushNamedAndRemoveUntil(
                          '/auth/',
                          (route) => false,
                        );
                      },
                      child: const Text('Entrar'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      });
    });
  }

  Widget body = const Center(
    child: CircularProgressIndicator.adaptive(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: body,
    );
  }
}
