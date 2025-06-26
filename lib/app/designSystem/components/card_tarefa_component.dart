import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../models/tarefa_listagem_model.dart';

class CardTarefaComponent extends StatelessWidget {
  final TarefaListagemModel tarefa;
  const CardTarefaComponent({
    super.key,
    required this.tarefa,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.task),
            ),
            title: Text(tarefa.nome),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                tarefa.descricao.isEmpty ? Container() : Text(tarefa.descricao),
              ],
            ),
            trailing: Wrap(
              children: [
                Text(
                  tarefa.dataCriacao.toLocal().toString().split(' ')[0],
                  style: const TextStyle(fontSize: 12),
                ),
                tarefa.isConcluida
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : const Icon(Icons.circle_outlined, color: Colors.grey),
              ],
            ),
            onTap: () {
              Modular.to.pushNamed(
                '/sistema/tarefas/detalhes/${tarefa.codigo}',
              );
            },
          ),
        ],
      ),
    );
  }
}
