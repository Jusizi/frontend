// ignore_for_file: use_build_context_synchronously

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../designSystem/layout/drawermenuComponent.dart';
import '../../../../designSystem/layout/title_component.dart';
import '../../../../designSystem/snackbar_component.dart';
import '../../../../models/cliente_listagem_model.dart';
import '../../../../shared/either.dart';
import 'clientes_store.dart';

class ClientePorCPFPage extends StatefulWidget {
  const ClientePorCPFPage({super.key});

  @override
  State<ClientePorCPFPage> createState() => _ClientePorCPFPageState();
}

class _ClientePorCPFPageState extends State<ClientePorCPFPage> {
  late final ClientesStore clientesStore;

  TextEditingController documentoNumeroController = TextEditingController();

  bool loading = false;

  @override
  void initState() {
    super.initState();

    clientesStore = Modular.get<ClientesStore>();
  }

  @override
  void dispose() {
    documentoNumeroController.dispose();
    super.dispose();
  }

  Widget _buildNormalContainer() {
    return conteudoPadrao();
  }

  Widget _buildWideContainers() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      child: conteudoPadrao(),
    );
  }

  Widget conteudoPadrao() {
    return Column(
      children: [
        const TitleComponent(
          title: 'Adicionar Novo Cliente por CPF/CNPJ',
          subtitle: 'Adicione um novo cliente informando o CPF/CNPJ apenas.',
        ),

        // Formulário
        TextFormField(
          controller: documentoNumeroController,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            CpfInputFormatter(),
          ],
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Número do documento',
          ),
        ),
        const SizedBox(height: 20),
        Visibility(
          visible: !loading,
          child: ElevatedButton(
            onPressed: () async {
              try {
                ClienteListagemModel cliente =
                    clientesStore.clientes.firstWhere(
                  (cliente) =>
                      cliente.documento == documentoNumeroController.text,
                  orElse: () => throw Exception('Cliente não encontrado'),
                );

                SnackBarComponent().showWarning(
                  'Este cliente já está cadastrado, você será redirecionado para a página de detalhes.',
                );
                await Future.delayed(const Duration(seconds: 1));
                Modular.to.pushNamed(
                  '/sistema/clientes/detalhes/${cliente.codigo}',
                );
                return;
              } catch (e) {
                debugPrint(e.toString());
              }

              setState(() {
                loading = true;
              });
              Either<String, String> resposta =
                  await clientesStore.adicionarClientePorDocumento(
                documentoNumeroController.text,
              );

              resposta.fold((l) {
                SnackBarComponent().showError(l);
              }, (r) async {
                SnackBarComponent().showSuccess(r);

                Modular.to.pop();
                clientesStore.getClientesListagem();

                /*
                ClienteListagemModel cliente =
                    clientesStore.clientes.firstWhere(
                  (cliente) =>
                      cliente.documento == documentoNumeroController.text,
                  orElse: () => throw Exception('Cliente não encontrado'),
                );

                Modular.to.pushReplacementNamed(
                    '/sistema/clientes/detalhes/${cliente.codigo}');
                    */
              });
              setState(() {
                loading = false;
              });
            },
            child: const Text('Adicionar novo cliente'),
          ),
        ),
        Visibility(
          visible: loading,
          child: const CircularProgressIndicator.adaptive(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: GlobalKey(),
      appBar: AppBar(
        title: const Text('Adicionar Cliente por CPF/CNPJ'),
      ),
      drawer: drawerORleading(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              if (constraints.maxWidth > 600) {
                return _buildWideContainers();
              } else {
                return _buildNormalContainer();
              }
            },
          ),
        ),
      ),
    );
  }
}
