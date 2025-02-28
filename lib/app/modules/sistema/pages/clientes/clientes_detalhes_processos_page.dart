import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../designSystem/components/card_cliente_component.dart';
import '../../../../designSystem/components/card_processo_component.dart';
import '../../../../designSystem/layout/drawermenuComponent.dart';
import '../../../../models/cliente_model.dart';
import '../../../../models/processo_listagem_model.dart';
import '../../../../shared/either.dart';
import 'clientes_store.dart';

class ClientesDetalhesProcessosPage extends StatefulWidget {
  final String clienteCodigo;
  const ClientesDetalhesProcessosPage({super.key, required this.clienteCodigo});

  @override
  State<ClientesDetalhesProcessosPage> createState() =>
      _ClientesDetalhesProcessosPageState();
}

class _ClientesDetalhesProcessosPageState
    extends State<ClientesDetalhesProcessosPage> {
  late final ClientesStore clientesStore;

  String title = 'Processos';

  Widget body = const Center(
    child: CircularProgressIndicator(),
  );
  @override
  void initState() {
    super.initState();

    clientesStore = Modular.get<ClientesStore>();

    buscarInformacoesDoCliente();
  }

  Future<void> buscarInformacoesDoCliente() async {
    final Either<String, ClienteModel> resposta =
        await clientesStore.buscarClientePorCodigo(widget.clienteCodigo);

    resposta.fold((l) {
      body = Center(
        child: Text(l),
      );
      setState(() {});
    }, (ClienteModel clienteModel) async {
      ClienteModel cliente = clienteModel;

      title = 'Processos de ${cliente.nomeCompleto}';

      final Either<String, List<ProcessoListagemModel>> respostaProcessos =
          await clientesStore.obterProcessosDoCliente(cliente);

      respostaProcessos.fold((l) {
        body = Center(
          child: Text(l),
        );
        setState(() {});
      }, (List<ProcessoListagemModel> processosListagem) {
        body = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CardClienteComponent(cliente: cliente.toClienteListagemModel()),
            const SizedBox(height: 10),
            const Text('Processos'),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: processosListagem.length,
                itemBuilder: (BuildContext context, int index) {
                  ProcessoListagemModel processoListagem =
                      processosListagem[index];
                  return CardProcessoComponent(
                    processoListagem: processoListagem,
                  );
                },
              ),
            ),
          ],
        );
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      drawer: drawerORleading(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: body,
      ),
    );
  }
}
