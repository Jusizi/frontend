import 'package:appjusizi/app/designSystem/layout/drawermenuComponent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../../designSystem/snackbar_component.dart';
import '../../../../../models/CNJ.dart';
import '../processos_store.dart';

class ProcessoAdicionarPage extends StatefulWidget {
  const ProcessoAdicionarPage({super.key});

  @override
  State<ProcessoAdicionarPage> createState() => _ProcessoAdicionarPageState();
}

class _ProcessoAdicionarPageState extends State<ProcessoAdicionarPage> {
  final TextEditingController _numeroProcessoController =
      TextEditingController();

  late ProcessosStore processosStore;

  String _errorMessage = '';
  bool _isValidCNJ = false;

  @override
  void initState() {
    super.initState();

    processosStore = Modular.get<ProcessosStore>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Processo (CNJ)'),
      ),
      drawer: drawerORleading(),
      body: Center(
        child: Container(
          width: 650,
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('Insira o número do processo abaixo (CNJ):'),
                SizedBox(height: 20),
                TextField(
                  controller: _numeroProcessoController,
                  maxLength: 25, // Limita o número de caracteres para 20
                  decoration: InputDecoration(
                    labelText: 'Número do Processo',
                    hintText: 'Exemplo: 5002200-64.2021.8.21.0076',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                    errorText: _errorMessage.isEmpty ||
                            _errorMessage ==
                                'O número do processo deve ter 20 caracteres.'
                        ? null
                        : _errorMessage,
                    suffixIcon: _isValidCNJ
                        ? Icon(Icons.check, color: Colors.green)
                        : null, // Ícone de verificação verde se o CNJ for válido
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (String value) {
                    setState(() {
                      // Remove tudo que não for número, mas mantendo a estrutura do valor colado
                      String cleanedValue =
                          value.replaceAll(RegExp(r'[^0-9]'), '');

                      // Se o valor limpo tiver mais de 20 caracteres, não permitir
                      if (cleanedValue.length > 20) {
                        _errorMessage =
                            'O número do processo deve ter 20 caracteres.';
                        _isValidCNJ = false;
                      } else {
                        _errorMessage = '';
                        _isValidCNJ =
                            false; // Assume como inválido enquanto está digitando
                      }

                      try {
                        // Tenta criar o objeto CNJ com o valor limpo
                        CNJ cnj = CNJ(cleanedValue);
                        _errorMessage = '';
                        _isValidCNJ = true; // Marca como válido

                        // Formata o valor do CNJ para mostrar no campo
                        _numeroProcessoController.text = cnj.value;
                        _numeroProcessoController.selection =
                            TextSelection.fromPosition(
                          TextPosition(
                              offset: _numeroProcessoController.text.length),
                        ); // Mantém o cursor no final após formatação
                      } catch (e) {
                        _errorMessage = e.toString();
                        _isValidCNJ = false;
                      }
                    });
                  },
                ),
                Visibility(visible: _isValidCNJ, child: SizedBox(height: 20)),
                Visibility(
                  visible: _isValidCNJ,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_isValidCNJ) {
                        final resposta = await processosStore
                            .adicionarProcesso(_numeroProcessoController.text);

                        resposta.fold((String mensagemErro) {
                          SnackBarComponent().showError(mensagemErro);
                        }, (String mensagemSucesso) {
                          SnackBarComponent().showSuccess(mensagemSucesso);
                          Modular.to.pushNamed('/sistema/processos');
                        });
                      } else {
                        SnackBarComponent()
                            .showWarning("Número do processo inválido.");
                      }
                    },
                    child: Text('Adicionar Processo'),
                  ),
                ),
                SizedBox(height: 30),
                Visibility(
                  visible: !_isValidCNJ,
                  child:
                      Text("Exemplo de CNJ válido: 5002200-64.2021.8.21.0076"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
