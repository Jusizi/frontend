import 'package:appjusizi/app/designSystem/layout/drawermenuComponent.dart';
import 'package:appjusizi/app/designSystem/snackbar_component.dart';
import 'package:appjusizi/app/models/tarefa_model.dart';
import 'package:appjusizi/app/modules/sistema/pages/tarefas/tarefas_store.dart';
import 'package:appjusizi/app/shared/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CadastrarTarefaPage extends StatefulWidget {
  const CadastrarTarefaPage({super.key});

  @override
  State<CadastrarTarefaPage> createState() => _CadastrarTarefaPageState();
}

class _CadastrarTarefaPageState extends State<CadastrarTarefaPage> {
  TextEditingController nomeController = TextEditingController();
  TextEditingController descricaoController = TextEditingController();
  bool isLoading = false;
  late TarefasStore tarefasStore;

  @override
  void initState() {
    super.initState();
    tarefasStore = Modular.get<TarefasStore>();
  }

  @override
  void dispose() {
    nomeController.dispose();
    descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: GlobalKey(),
      appBar: AppBar(
        title: Text(
          'Cadastrar uma Tarefa',
        ),
      ),
      drawer: drawerORleading(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          TextFormField(
            controller: nomeController,
            decoration: InputDecoration(
              labelText: 'Nome da Tarefa',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: descricaoController,
            decoration: InputDecoration(
              labelText: 'Descrição',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 10),
          Visibility(
            visible: isLoading,
            child: const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          ),
          Visibility(
            visible: !isLoading,
            child: ElevatedButton(
              onPressed: () async {
                if (nomeController.text.isEmpty) {
                  SnackBarComponent()
                      .showError('O nome da tarefa é obrigatório.');
                  return;
                }

                if (descricaoController.text.isEmpty) {
                  SnackBarComponent()
                      .showError('A descrição da tarefa é obrigatória.');
                  return;
                }

                setState(() {
                  isLoading = true;
                });

                final tarefa = TarefaModel(
                  nome: nomeController.text,
                  descricao: descricaoController.text,
                );

                final Either<String, String> resposta =
                    await tarefasStore.cadastrarTarefa(tarefa);
                resposta.fold(
                  (error) {
                    SnackBarComponent().showError(error);
                    return;
                  },
                  (successMessage) {
                    SnackBarComponent().showSuccess(successMessage);

                    Modular.to.pop(); // Volta para a página de tarefas
                  },
                );

                setState(() {
                  isLoading = false;
                });
              },
              child: const Text('Cadastrar Tarefa'),
            ),
          ),
        ]),
      ),
    );
  }
}
