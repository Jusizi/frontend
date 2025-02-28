import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

import '../../../../../designSystem/layout/layout_component.dart';
import '../../../../../models/colaborador_model.dart';
import '../empresa_store.dart';

class ColaboradoresPage extends StatefulWidget {
  const ColaboradoresPage({super.key});

  @override
  State<ColaboradoresPage> createState() => _ColaboradoresPageState();
}

class _ColaboradoresPageState extends State<ColaboradoresPage> {
  late EmpresaStore empresaStore;

  @override
  void initState() {
    super.initState();

    empresaStore = Modular.get<EmpresaStore>();
  }

  Widget _buildError(Exception state) {
    return Center(
      child: Text(state.toString()),
    );
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator.adaptive());
  }

  Widget _buildSuccess(state) {
    if (empresaStore.colaboradores.isEmpty) {
      return const Center(child: Text('Nenhum colaborador foi encontrado.'));
    }
    return ListView.builder(
      itemCount: empresaStore.colaboradores.length,
      itemBuilder: (context, indexContexto) {
        ColaboradorModel data = empresaStore.colaboradores[indexContexto];
        return Card(
          child: Column(
            children: [
              ListTile(
                leading: const CircleAvatar(
                  child: FlutterLogo(),
                ),
                title: Text(data.nome),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.email),
                  ],
                ),
                /*trailing: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Excluir'),
                          content: const Text(
                              'Tem certeza que deseja excluir este colaborador?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Modular.to.pop();
                              },
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () async {
                                // await clientesStore.deleteCliente(data);
                                Modular.to.pop();
                                //clientesStore.getClientes();
                              },
                              child: const Text('Excluir'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.delete),
                ),*/
                onTap: () => Modular.to.pushNamed(
                  '/empresa/colaboradores/detalhes',
                  arguments: data,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutComponent(
      title: 'Colaboradores',
      esconderDrawer: true,
      actions: [
        IconButton(
          onPressed: () {
            Modular.to.pushNamed('/empresa/colaboradores/novo');
          },
          icon: const Icon(Icons.add),
        ),
        IconButton(
          onPressed: empresaStore.getColaboradores,
          icon: const Icon(Icons.sync),
        ),
      ],
      body: RefreshIndicator(
        onRefresh: empresaStore.getColaboradores,
        child: ScopedBuilder<EmpresaStore, int>(
          store: empresaStore,
          onError: (context, erro) => _buildError(erro!),
          onLoading: (context) => _buildLoading(),
          onState: (context, state) => _buildSuccess(state),
        ),
      ),
    );
  }
}
