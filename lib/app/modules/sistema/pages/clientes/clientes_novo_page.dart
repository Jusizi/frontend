// ignore_for_file: use_build_context_synchronously

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../designSystem/layout/layout_component.dart';
import '../../../../designSystem/layout/title_component.dart';
import '../../../../designSystem/snackbar_component.dart';
import '../../../../models/cliente_model.dart';
import '../../../../models/drive_model.dart';
import 'clientes_store.dart';

class ClientesNovoPage extends StatefulWidget {
  const ClientesNovoPage({super.key});

  @override
  State<ClientesNovoPage> createState() => _ClientesNovoPageState();
}

class _ClientesNovoPageState extends State<ClientesNovoPage> {
  late final ClientesStore clientesStore;

  TextEditingController nomeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController documentoController = TextEditingController();
  TextEditingController telefoneController = TextEditingController();

  TextEditingController logradouroController = TextEditingController();
  TextEditingController numeroController = TextEditingController();
  TextEditingController bairroController = TextEditingController();
  TextEditingController cidadeController = TextEditingController();
  TextEditingController estadoController = TextEditingController();
  TextEditingController cepController = TextEditingController();
  TextEditingController complementoController = TextEditingController();
  TextEditingController nomeDaMaeController = TextEditingController();
  TextEditingController cpfDaMaeController = TextEditingController();
  TextEditingController sexoController = TextEditingController();
  TextEditingController dataNascimentoController = TextEditingController();
  TextEditingController cpfDoPaicontroller = TextEditingController();
  TextEditingController nomeDoPaiController = TextEditingController();
  TextEditingController rgController = TextEditingController();
  TextEditingController pisController = TextEditingController();
  TextEditingController carteiraDeTrabalhoController = TextEditingController();

  bool loading = false;

  @override
  void initState() {
    super.initState();

    clientesStore = Modular.get<ClientesStore>();
  }

  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    documentoController.dispose();
    telefoneController.dispose();
    logradouroController.dispose();
    numeroController.dispose();
    bairroController.dispose();
    cidadeController.dispose();
    estadoController.dispose();
    cepController.dispose();
    complementoController.dispose();
    nomeDaMaeController.dispose();
    cpfDaMaeController.dispose();
    sexoController.dispose();
    dataNascimentoController.dispose();
    cpfDoPaicontroller.dispose();
    nomeDoPaiController.dispose();
    rgController.dispose();
    pisController.dispose();
    carteiraDeTrabalhoController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutComponent(
      esconderDrawer: true,
      title: 'Adicionar Cliente',
      body: Center(
        child: Column(
          children: [
            const TitleComponent(
              title: 'Adicionar Novo Cliente',
              subtitle:
                  'Use o formulário abaixo para adicionar um novo cliente.',
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
                    controller: documentoController,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CpfInputFormatter()
                    ],
                    decoration: const InputDecoration(
                      labelText: 'CPF / CNPJ',
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
                  TextFormField(
                    controller: telefoneController,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      TelefoneInputFormatter()
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Telefone',
                    ),
                  ),
                  const SizedBox(height: 20),
                  Visibility(
                    visible: !loading,
                    child: ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          loading = true;
                        });
                        try {
                          final resposta = await clientesStore.addCliente(
                            ClienteModel(
                              codigo: '',
                              telefone: telefoneController.text,
                              nomeCompleto: nomeController.text,
                              documento: documentoController.text,
                              email: emailController.text,
                              drive: DriveModel(arquivos: []),
                              eventos: [],
                              processos: [],
                              logradouro: logradouroController.text,
                              numero: numeroController.text,
                              bairro: bairroController.text,
                              cidade: cidadeController.text,
                              estado: estadoController.text,
                              cep: cepController.text,
                              complemento: complementoController.text,
                              nomeDaMae: nomeDaMaeController.text,
                              cpfDaMae: cpfDaMaeController.text,
                              sexo: sexoController.text,
                              dataAniversario: dataNascimentoController.text,
                              nomeDoPai: nomeDoPaiController.text,
                              cpfDoPai: cpfDoPaicontroller.text,
                              rg: rgController.text,
                              pis: pisController.text,
                              carteiraDeTrabalho:
                                  carteiraDeTrabalhoController.text,
                              telefones: [],
                              emails: [],
                              enderecos: [],
                              familiares: [],
                            ),
                          );

                          SnackBarComponent().showSuccess(resposta);
                          Modular.to.pushNamed('/sistema/clientes');
                        } catch (e) {
                          SnackBarComponent().showError(e.toString());

                          setState(() {
                            loading = false;
                          });
                        }
                      },
                      child: const Text('Adicionar'),
                    ),
                  ),
                  Visibility(
                    visible: loading,
                    child: const CircularProgressIndicator.adaptive(),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
