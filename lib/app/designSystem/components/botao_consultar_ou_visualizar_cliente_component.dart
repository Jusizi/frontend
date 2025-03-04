import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../models/cliente_listagem_model.dart';
import '../../modules/sistema/pages/clientes/clientes_store.dart';
import '../../shared/either.dart';
import '../snackbar_component.dart';

class BotaoConsultarOuVisualizarClienteComponent extends StatefulWidget {
  final String documento;
  const BotaoConsultarOuVisualizarClienteComponent({
    super.key,
    required this.documento,
  });

  @override
  State<BotaoConsultarOuVisualizarClienteComponent> createState() =>
      _BotaoConsultarOuVisualizarClienteComponentState();
}

class _BotaoConsultarOuVisualizarClienteComponentState
    extends State<BotaoConsultarOuVisualizarClienteComponent> {
  late ClientesStore _clientesStore;
  ClienteListagemModel? clienteJaExiste;
  bool carregando = false;
  @override
  void initState() {
    super.initState();
    _clientesStore = Modular.get<ClientesStore>();

    // executar depois que o widget for construído
    WidgetsBinding.instance.addPostFrameCallback((_) {
      clienteJaExiste = _clientesStore.getClientePorDocumento(widget.documento);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (clienteJaExiste != null) {
      return TextButton.icon(
        onPressed: () {
          Modular.to.pushNamed(
            '/sistema/clientes/detalhes/${clienteJaExiste!.codigo}',
          );
        },
        label: const Text('Visualizar'),
        icon: const Icon(Icons.remove_red_eye),
      );
    }

    if (carregando) {
      return const CircularProgressIndicator.adaptive();
    }

    if (widget.documento.isEmpty) {
      return Container();
    }

    return TextButton.icon(
      style: TextButton.styleFrom(
        backgroundColor: Colors.black12,
      ),
      onPressed: () async {
        setState(() {
          carregando = true;
        });

        SnackBarComponent()
            .showWarning("Consultando informações na internet...");

        Either<String, String> resposta = await _clientesStore
            .consultarInformacoesNaInternet(widget.documento);

        resposta.fold(
          (l) {
            SnackBarComponent().showError(l);
          },
          (r) async {
            SnackBarComponent().showSuccess(r);

            await _clientesStore.getClientes();

            SnackBarComponent().showWarning(
              "Você será redirecionado para a página do cliente.",
            );
          },
        );

        setState(() {
          carregando = false;
        });

        try {
          ClienteListagemModel clienteAtualizado =
              _clientesStore.getClientePorDocumento(widget.documento);

          Modular.to.pushNamed(
              '/sistema/clientes/detalhes/${clienteAtualizado.codigo}');
        } catch (e) {
          debugPrint("Não foi possível encontrar o cliente.");
        }
      },
      label: const Text('Consultar'),
      icon: const Icon(Icons.search),
    );
  }
}
