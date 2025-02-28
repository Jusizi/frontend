import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../designSystem/layout/drawermenuComponent.dart';
import '../../../../../designSystem/snackbar_component.dart';
import '../../../../../models/conta_bancaria_model.dart';
import '../../../../../repositories/contasBancarias/contasbancarias_repository.dart';
import '../../../../../shared/either.dart';
import 'contabancaria_formulario_store.dart';

class ContaBancariaDetalhesPage extends StatefulWidget {
  final String contaBancariaCodigo;
  const ContaBancariaDetalhesPage({
    super.key,
    required this.contaBancariaCodigo,
  });

  @override
  State<ContaBancariaDetalhesPage> createState() =>
      _ContaBancariaDetalhesPageState();
}

class _ContaBancariaDetalhesPageState extends State<ContaBancariaDetalhesPage> {
  late ContaBancariaFormularioStore contaBancariaFormularioStore;

  @override
  void initState() {
    super.initState();

    contaBancariaFormularioStore = ContaBancariaFormularioStore(
      contaBancariaCodigo: widget.contaBancariaCodigo,
      repository: Modular.get<ContasBancariasRepository>(),
    );
  }

  Widget _buildSuccess(ContabancariaFormularioState state) {
    if (state is ContabancariaFormularioStateSuccess) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  alignment: Alignment.center,
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset(
                      'assets/icons/bancos/asaas.jpg',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  const Text(
                    'Nome da Conta Bancária',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      contaBancariaFormularioStore.contaBancaria.producao
                          ? "Produção"
                          : "Sandbox",
                      style: TextStyle(
                        color:
                            contaBancariaFormularioStore.contaBancaria.producao
                                ? Colors.green
                                : Colors.orange,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Switch(
                    value: contaBancariaFormularioStore.contaBancaria.producao,
                    onChanged: (value) async {
                      setState(() {
                        contaBancariaFormularioStore.contaBancaria.producao =
                            value;
                      });

                      final Either<String, String> resposta =
                          await contaBancariaFormularioStore
                              .atualizarContaBancaria(
                        contaBancariaFormularioStore.contaBancaria,
                      );

                      resposta.fold(
                        (l) {
                          SnackBarComponent().showError(l);
                        },
                        (r) {
                          SnackBarComponent().showSuccess(r);
                        },
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: contaBancariaFormularioStore.nomeController,
                onChanged: (_) => contaBancariaFormularioStore
                    .verificaSeHaInformacoesAlteradasNaConta(),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Digite o nome da sua conta',
                ),
              ),
              const SizedBox(height: 16),
              Visibility(
                visible: false,
                child: Column(
                  children: [
                    const Text(
                      'Carteira ID',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller:
                          contaBancariaFormularioStore.clientIDController,
                      onChanged: (value) => contaBancariaFormularioStore
                          .verificaSeHaInformacoesAlteradasNaConta(),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Digite sua carteira ID',
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              const Text(
                'Chave API',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: contaBancariaFormularioStore.chaveAPIController,
                onChanged: (value) => contaBancariaFormularioStore
                    .verificaSeHaInformacoesAlteradasNaConta(),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Digite sua Chave API',
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                alignment: WrapAlignment.start,
                children: [
                  Text(
                    'Para obter sua Chave API, faça login em sua conta Asaas e navegue até "Configurações" > "API".',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await launchUrl(contaBancariaFormularioStore.urllinkAPI);
                    },
                    icon: const Icon(Icons.link),
                    label: const Text('Obter Chave API'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Visibility(
                      visible: contaBancariaFormularioStore
                          .loadingSalvandoContaBancaria,
                      child: const CircularProgressIndicator.adaptive(),
                    ),
                    Visibility(
                      visible: contaBancariaFormularioStore
                              .haInformacoesAlteradasNaConta &&
                          !contaBancariaFormularioStore
                              .loadingSalvandoContaBancaria,
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            contaBancariaFormularioStore
                                .loadingSalvandoContaBancaria = true;
                          });

                          ContaBancariaModel novaContaBancaria =
                              contaBancariaFormularioStore.contaBancaria
                                  .copyWith(
                            nome: contaBancariaFormularioStore
                                .nomeController.text,
                            chaveAPI: contaBancariaFormularioStore
                                .chaveAPIController.text,
                          );
                          final Either<String, String> resposta =
                              await contaBancariaFormularioStore
                                  .atualizarContaBancaria(novaContaBancaria);

                          setState(() {
                            contaBancariaFormularioStore
                                .loadingSalvandoContaBancaria = false;
                          });
                          resposta.fold(
                            (l) {
                              SnackBarComponent().showError(l);
                            },
                            (r) {
                              SnackBarComponent().showSuccess(r);
                              Modular.to.pushReplacementNamed(
                                  '/sistema/contabancaria/detalhes/${contaBancariaFormularioStore.contaBancaria.id}');
                            },
                          );
                        },
                        child: const Text('Atualizar Informações'),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible:
                    !contaBancariaFormularioStore.haInformacoesAlteradasNaConta,
                child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Visibility(
                        visible: contaBancariaFormularioStore
                                .conexaoComOBancoEstaOk &&
                            !contaBancariaFormularioStore
                                .tentandoConexaoComOBanco,
                        child: contaBancariaFormularioStore
                            .feedBackConexaoComOBanco,
                      ),
                      Visibility(
                        visible: contaBancariaFormularioStore
                            .tentandoConexaoComOBanco,
                        child: const CircularProgressIndicator.adaptive(),
                      ),
                      Visibility(
                        visible: !contaBancariaFormularioStore
                            .tentandoConexaoComOBanco,
                        child: TextButton.icon(
                          onPressed: () async {
                            final Either<String, String> resposta =
                                await contaBancariaFormularioStore
                                    .verificaConexaoComPlataformaAPIDeCobrancas(
                              contaBancariaFormularioStore.contaBancaria,
                            );

                            resposta.fold(
                              (l) {
                                SnackBarComponent().showError(l);
                              },
                              (r) {
                                SnackBarComponent().showSuccess(r);
                              },
                            );
                          },
                          icon: const Icon(Icons.wifi),
                          label: const Text('Verificar Conexão'),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return const Center(
      child: Text("Erro ao carregar informações da conta bancária"),
    );
  }

  Widget _buildError(Exception state) {
    return Center(
      child: Text(state.toString()),
    );
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator.adaptive());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Configurações da conta bancária"),
      ),
      drawer: drawerORleading(),
      body: ScopedBuilder<ContaBancariaFormularioStore,
          ContabancariaFormularioState>(
        store: contaBancariaFormularioStore,
        onError: (context, erro) => _buildError(erro!),
        onLoading: (context) => _buildLoading(),
        onState: (context, state) => _buildSuccess(state),
      ),
    );
  }
}
