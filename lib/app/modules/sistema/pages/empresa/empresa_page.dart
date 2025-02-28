import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../designSystem/layout/body_component.dart';
import '../../../../designSystem/layout/drawermenuComponent.dart';
import '../../../../shared/stores/auth/auth_store.dart';

class EmpresaPage extends StatefulWidget {
  const EmpresaPage({super.key});

  @override
  State<EmpresaPage> createState() => _EmpresaPageState();
}

class _EmpresaPageState extends State<EmpresaPage> {
  late AuthStore _authStore;
  @override
  void initState() {
    super.initState();

    _authStore = Modular.get<AuthStore>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Empresa'),
      ),
      drawer: drawerORleading(),
      body: Bodycomponent(
        bodyWidget: Padding(
          padding: const EdgeInsets.all(10),
          child: Card(
            child: ListTile(
              title: const Text("Empresa"),
              subtitle: Row(children: [
                Text("${_authStore.empresa.apelido} "),
                const Icon(Icons.verified_outlined),
                const Spacer(),
                Text(_authStore.empresa.documentoNumero),
              ]),
              leading: const Icon(Icons.business),
            ),
          ),
        ),
      ),
    );
  }
}
