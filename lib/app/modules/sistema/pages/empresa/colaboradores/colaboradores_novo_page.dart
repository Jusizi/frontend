// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../../designSystem/layout/layout_component.dart';
import '../../../../../designSystem/layout/title_component.dart';
import '../../../../../designSystem/snackbar_component.dart';
import '../../../../../models/colaborador_model.dart';
import '../empresa_store.dart';

class ColaboradoresNovoPage extends StatefulWidget {
  const ColaboradoresNovoPage({super.key});

  @override
  State<ColaboradoresNovoPage> createState() => _ColaboradoresNovoPageState();
}

class _ColaboradoresNovoPageState extends State<ColaboradoresNovoPage> {
  late final EmpresaStore empresaStore;

  TextEditingController nomeController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();

    empresaStore = Modular.get<EmpresaStore>();
  }

  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutComponent(
      esconderDrawer: true,
      title: 'Adicionar Colaborador',
      body: Center(
        child: Column(
          children: [
            const TitleComponent(
              title: 'Adicionar Novo Colaborador',
              subtitle:
                  'Use o formulário abaixo para adicionar um novo colaborador.',
            ),

            // Formulário
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  TextFormField(
                    controller: nomeController,
                    decoration: const InputDecoration(
                      labelText: 'Nome completo',
                    ),
                  ),
                  TextFormField(
                    controller: emailController,
                    inputFormatters: [
                      FilteringTextInputFormatter.singleLineFormatter,
                    ],
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        final resposta = await empresaStore.addColaborador(
                          ColaboradorModel(
                            id: '',
                            email: emailController.text,
                            nome: nomeController.text,
                          ),
                        );

                        SnackBarComponent().showSuccess(resposta);
                        Modular.to.pushNamed('/empresa/colaboradores');
                      } catch (e) {
                        SnackBarComponent().showError(e.toString());
                      }
                    },
                    child: const Text('Adicionar'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
