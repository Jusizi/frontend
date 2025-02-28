import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../shared/either.dart';
import '../../../shared/stores/auth/auth_store.dart';

class SairPage extends StatefulWidget {
  const SairPage({super.key});

  @override
  State<SairPage> createState() => _SairPageState();
}

class _SairPageState extends State<SairPage> {
  late AuthStore authStore;
  @override
  void initState() {
    super.initState();

    authStore = Modular.get<AuthStore>();

    authStore.sair().then(
          (Either<String, String> resposta) => {
            resposta.fold((l) {
              Modular.to.pushNamedAndRemoveUntil('/auth/', (p0) => true);
            }, (String mensagem) {
              Modular.to.pushNamedAndRemoveUntil('/auth/', (p0) => true);
            })
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('ADIOS'),
      ),
    );
  }
}
