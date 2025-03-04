// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
// import 'package:maps_launcher/maps_launcher.dart';

import '../../../../designSystem/components/botao_consultar_ou_visualizar_cliente_component.dart';
import '../../../../designSystem/components/card_pessoa_component.dart';
import '../../../../designSystem/components/card_processo_component.dart';
import '../../../../designSystem/components/selecionar_modelo_component.dart';
import '../../../../designSystem/layout/drawermenuComponent.dart';
import '../../../../designSystem/snackbar_component.dart';
import '../../../../models/cliente_listagem_model.dart';
import '../../../../models/cliente_model.dart';
import '../../../../models/endereco_simples_model.dart';
import '../../../../models/familiar_model.dart';
import '../../../../models/processo_listagem_model.dart';
import '../../../../repositories/clientes/clientes_repository.dart';
import '../../../../shared/either.dart';
import 'clientes_detalhes_acoes_store.dart';
import 'clientes_store.dart';

class ClientesDetalhesPage extends StatefulWidget {
  final String clienteCodigo;
  const ClientesDetalhesPage({
    super.key,
    required this.clienteCodigo,
  });

  @override
  State<ClientesDetalhesPage> createState() => _ClientesDetalhesPageState();
}

class _ClientesDetalhesPageState extends State<ClientesDetalhesPage> {
  late final ClientesStore clientesStore;
  ClienteModel? cliente;
  String titulo = 'Detalhes do cliente';

  bool jaFoiConsultadoInformacoesNaInternet = false;
  bool loadingConsultandoProcessos = false;
  bool loadingConsultandoInformacoesNaInternet = false;

  TextEditingController flagController = TextEditingController();

  bool get naoHaProcessos => flagController.text.isEmpty;

  late ClientesDetalhesAcoesStore clientesDetalhesAcoesStore;

  @override
  void initState() {
    super.initState();

    clientesStore = Modular.get<ClientesStore>();

    clientesDetalhesAcoesStore = ClientesDetalhesAcoesStore(
      clientesStore,
      Modular.get<ClientesRepository>(),
    );

    buscarInformacoesDoCliente();
  }

  @override
  dispose() {
    clientesDetalhesAcoesStore.destroy();
    super.dispose();
  }

  Future<void> buscarInformacoesDoCliente() async {
    final Either<String, ClienteModel> resposta =
        await clientesStore.buscarClientePorCodigo(widget.clienteCodigo);

    resposta.fold((l) {
      setState(() {
        titulo = l;
      });
    }, (ClienteModel clienteModel) {
      cliente = clienteModel;

      clientesDetalhesAcoesStore.selecionarCliente(clienteModel);

      clientesDetalhesAcoesStore.buscarProcessosDoCliente();

      titulo = '${clienteModel.nomeCompleto} - Detalhes do cliente';

      jaFoiConsultadoInformacoesNaInternet =
          clienteModel.nomeDaMae.isNotEmpty ||
              clienteModel.nomeDoPai.isNotEmpty ||
              clienteModel.telefones.isNotEmpty ||
              clienteModel.emails.isNotEmpty ||
              clienteModel.enderecos.isNotEmpty ||
              clienteModel.familiares.isNotEmpty;

      setState(() {});
    });
  }

  Widget widgetAcoes(ClienteModel cliente) {
    return Wrap(
      children: [
        Visibility(
          visible: clientesDetalhesAcoesStore.loadingConsultandoProcessos,
          child: const CircularProgressIndicator.adaptive(),
        ),
        Visibility(
          visible: !clientesDetalhesAcoesStore.loadingConsultandoProcessos &&
              !clientesDetalhesAcoesStore.naoHaProcessos,
          child: TextButton.icon(
            onPressed: () async {
              SnackBarComponent().showWarning(
                  "Estamos consultando os processos do cliente, aguarde...");

              final Either<String, String> resposta =
                  await clientesDetalhesAcoesStore
                      .consultarProcessosClienteNaInternet(cliente);

              resposta.fold(
                (l) {
                  SnackBarComponent().showError(l);
                },
                (r) {
                  SnackBarComponent().showSuccess(r);
                },
              );
            },
            icon: const Icon(Icons.menu_book_outlined),
            label: const Text('Consultar processos na internet'),
          ),
        ),
        Visibility(
          visible: clientesDetalhesAcoesStore
              .loadingConsultandoInformacoesNaInternet,
          child: const CircularProgressIndicator.adaptive(),
        ),
        Visibility(
          visible:
              !clientesDetalhesAcoesStore.jaFoiConsultadoInformacoesNaInternet,
          child: Visibility(
            visible: !clientesDetalhesAcoesStore
                .loadingConsultandoInformacoesNaInternet,
            child: TextButton.icon(
              onPressed: () async {
                SnackBarComponent().showWarning(
                    "Estamos consultando informações do cliente na internet, aguarde...");

                final Either<String, String> resposta =
                    await clientesDetalhesAcoesStore
                        .consultarInformacoesNaInternet(cliente.documento);

                resposta.fold(
                  (l) {
                    SnackBarComponent().showError(l);
                  },
                  (r) {
                    SnackBarComponent().showSuccess(r);
                    Modular.to.popAndPushNamed(
                        '/sistema/clientes/detalhes/${widget.clienteCodigo}');
                  },
                );
              },
              icon: const Icon(Icons.search),
              label: const Text('Consultar informações na internet'),
            ),
          ),
        ),
        TextButton.icon(
          onPressed: null,
          icon: const Icon(Icons.edit_outlined),
          label: const Text('Editar'),
        ),
        TextButton.icon(
          onPressed: () {
            SnackBarComponent()
                .showWarning('"Nada se perde, tudo se transforma."');
          },
          icon: const Icon(Icons.delete_outline_outlined),
          label: const Text('Excluir'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: GlobalKey(),
      appBar: AppBar(
        title: Text(titulo),
        actions: [
          kIsWeb && MediaQuery.of(context).size.width > 600
              ? SelecionarModeloComponent(clienteCodigo: widget.clienteCodigo)
              : const SizedBox(),

          // IconButton(
          //   tooltip: 'Histórico do cliente',
          //   onPressed: () {
          //     Modular.to.pushNamed(
          //       '/sistema/clientes/historico/${widget.clienteCodigo}',
          //     );
          //   },
          //   icon: const Icon(Icons.history_rounded),
          // ),
        ],
      ),
      drawer: drawerORleading(),
      body: Visibility(
        visible: cliente is ClienteModel,
        replacement: const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: !kIsWeb,
                  child: Column(
                    children: [
                      SelecionarModeloComponent(
                        clienteCodigo: widget.clienteCodigo,
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                Visibility(
                  visible: cliente != null && cliente!.nomeCompleto.isNotEmpty,
                  child: SelectableText(
                    cliente != null ? 'Nome: ${cliente!.nomeCompleto}' : '',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Visibility(
                  visible: cliente != null && cliente!.telefone.isNotEmpty,
                  child: SelectableText(
                    cliente != null ? 'Whatsapp: ${cliente!.telefone}' : '',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Visibility(
                  visible: cliente != null && cliente!.email.isNotEmpty,
                  child: SelectableText(
                    cliente != null ? 'Email: ${cliente!.email}' : '',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Visibility(
                  visible:
                      cliente != null && cliente!.dataAniversario.isNotEmpty,
                  child: SelectableText(
                    cliente != null
                        ? 'Data Nascimento: ${cliente!.dataAniversario}'
                        : '',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                const SizedBox(height: 20),
                SelectableText(
                  'Endereço',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Visibility(
                  visible: cliente != null && cliente!.logradouro.isNotEmpty,
                  child: SelectableText(
                    cliente != null ? 'Rua: ${cliente!.logradouro}' : '',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Visibility(
                  visible: cliente != null && cliente!.numero.isNotEmpty,
                  child: SelectableText(
                    cliente != null ? 'Número: ${cliente!.numero}' : '',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Visibility(
                  visible: cliente != null && cliente!.complemento.isNotEmpty,
                  child: SelectableText(
                    cliente != null
                        ? 'Complemento: ${cliente!.complemento}'
                        : '',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Visibility(
                  visible: cliente != null && cliente!.bairro.isNotEmpty,
                  child: SelectableText(
                    cliente != null ? 'Bairro: ${cliente!.bairro}' : '',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Visibility(
                  visible: cliente != null && cliente!.cidade.isNotEmpty,
                  child: SelectableText(
                    cliente != null ? 'Cidade: ${cliente!.cidade}' : '',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Visibility(
                  visible: cliente != null && cliente!.estado.isNotEmpty,
                  child: SelectableText(
                    cliente != null ? 'Estado: ${cliente!.estado}' : '',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Visibility(
                  visible: cliente != null && cliente!.cep.isNotEmpty,
                  child: SelectableText(
                    cliente != null ? 'CEP: ${cliente!.cep}' : '',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Visibility(
                  visible: cliente != null && cliente!.sexo.isNotEmpty,
                  child: SelectableText(
                    cliente != null ? 'Sexo: ${cliente!.sexo}' : '',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Visibility(
                  visible: cliente != null && cliente!.rg.isNotEmpty,
                  child: SelectableText(
                    cliente != null ? 'RG: ${cliente!.rg}' : '',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Visibility(
                  visible: cliente != null && cliente!.pis.isNotEmpty,
                  child: SelectableText(
                    cliente != null ? 'PIS: ${cliente!.pis}' : '',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Visibility(
                  visible:
                      cliente != null && cliente!.carteiraDeTrabalho.isNotEmpty,
                  child: SelectableText(
                    cliente != null
                        ? 'Carteira de Trabalho: ${cliente!.carteiraDeTrabalho}'
                        : '',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                const SizedBox(height: 20),
                Visibility(
                  visible: cliente != null &&
                      (cliente!.nomeDoPai.isNotEmpty ||
                          cliente!.nomeDaMae.isNotEmpty),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      SelectableText(
                        'Pais',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Visibility(
                        visible:
                            cliente != null && cliente!.nomeDoPai.isNotEmpty,
                        child: CardPessoaComponent(
                          nomeCompleto:
                              cliente != null ? cliente!.nomeDoPai : '',
                          documento: cliente != null ? cliente!.cpfDoPai : '',
                          tipo: PAIS.PAI,
                        ),
                      ),
                      Visibility(
                        visible:
                            cliente != null && cliente!.nomeDaMae.isNotEmpty,
                        child: CardPessoaComponent(
                          nomeCompleto:
                              cliente != null ? cliente!.nomeDaMae : '',
                          documento: cliente != null ? cliente!.cpfDaMae : '',
                          tipo: PAIS.MAE,
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: cliente != null && cliente!.telefones.isNotEmpty,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      SelectableText(
                        'Telefones',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount:
                              cliente != null ? cliente!.telefones.length : 0,
                          itemBuilder: (context, index) {
                            return Wrap(
                              alignment: WrapAlignment.start,
                              spacing: 10,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(cliente != null
                                    ? cliente!.telefones[index]
                                    : ''),
                                TextButton.icon(
                                  onPressed: () {
                                    Clipboard.setData(
                                      ClipboardData(
                                          text: cliente!.telefones[index]),
                                    );

                                    SnackBarComponent().showSuccess(
                                      'Telefone copiado para a área de transferência.',
                                    );
                                  },
                                  label: const Text('Copiar telefone'),
                                  icon: const Icon(Icons.copy),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: cliente != null && cliente!.emails.isNotEmpty,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      SelectableText(
                        'E-mails',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount:
                              cliente != null ? cliente!.emails.length : 0,
                          itemBuilder: (context, index) {
                            return SelectableText(
                              cliente != null ? cliente!.emails[index] : '',
                              style: Theme.of(context).textTheme.bodyLarge,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: cliente != null && cliente!.enderecos.isNotEmpty,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      SelectableText(
                        'Endereços',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount:
                            cliente != null ? cliente!.enderecos.length : 0,
                        itemBuilder: (context, index) {
                          EnderecoSimplesModel endereco =
                              cliente!.enderecos[index];
                          return Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SelectableText(
                                  'Rua: ${endereco.logradouro}',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                SelectableText(
                                  'Número: ${endereco.numero}',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                SelectableText(
                                  'Complemento: ${endereco.complemento}',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                SelectableText(
                                  'Bairro: ${endereco.bairro}',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                SelectableText(
                                  'Cidade: ${endereco.cidade}',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                SelectableText(
                                  'Estado: ${endereco.estado}',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                SelectableText(
                                  'CEP: ${endereco.cep}',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: cliente != null && cliente!.familiares.isNotEmpty,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      SelectableText(
                        'Familiares',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount:
                            cliente != null ? cliente!.familiares.length : 0,
                        itemBuilder: (context, index) {
                          FamiliarModel familiar = cliente!.familiares[index];

                          if (clientesStore.clientes.isNotEmpty) {
                            if (clientesStore.clientes.any((element) =>
                                element.documento == familiar.documento)) {
                              ClienteListagemModel cliente =
                                  clientesStore.clientes.firstWhere((element) =>
                                      element.documento == familiar.documento);

                              return Column(
                                children: [
                                  ListTile(
                                    leading: const CircleAvatar(
                                      child: Icon(Icons.person_2),
                                    ),
                                    title: Text(
                                        "${familiar.nome} - (${familiar.parentesco})"),
                                    subtitle: Text(familiar.documento),
                                    trailing: Column(
                                      children: [
                                        TextButton.icon(
                                          onPressed: () async {
                                            Modular.to.pushNamed(
                                              '/sistema/clientes/detalhes/${cliente.codigo}',
                                            );
                                          },
                                          label: const Text('Ver'),
                                          icon: const Icon(Icons.search),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              );
                            }
                          }

                          return Column(
                            children: [
                              ListTile(
                                leading: const CircleAvatar(
                                  child: Icon(Icons.person_2),
                                ),
                                title: Text(
                                    "${familiar.nome} - (${familiar.parentesco})"),
                                subtitle: familiar.documento.isNotEmpty
                                    ? Text(familiar.documento)
                                    : null,
                                trailing: familiar.documento.isNotEmpty
                                    ? BotaoConsultarOuVisualizarClienteComponent(
                                        documento: familiar.documento,
                                      )
                                    : null,
                              )
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: cliente != null && cliente!.processos.isNotEmpty,
                  child: TextButton.icon(
                    onPressed: () =>
                        clientesDetalhesAcoesStore.obterProcessosCliente(
                      cliente!,
                    ),
                    label: const Text('Consultar processos'),
                    icon: const Icon(Icons.menu_book_outlined),
                  ),
                ),
                Visibility(
                  visible: cliente != null,
                  child: ScopedBuilder<ClientesDetalhesAcoesStore, int>(
                    store: clientesDetalhesAcoesStore,
                    onError: (context, erro) => Center(
                      child: Text(
                        erro.toString(),
                      ),
                    ),
                    onLoading: (context) => const Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                    onState: (context, state) {
                      if (clientesDetalhesAcoesStore.processos.isEmpty) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Processos',
                                style: Theme.of(context).textTheme.bodyLarge),
                            const Text('Nenhum processo encontrado.'),
                          ],
                        );
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Text('Processos',
                                style: Theme.of(context).textTheme.bodyLarge),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: clientesDetalhesAcoesStore
                                          .processos.length >
                                      3
                                  ? 3
                                  : clientesDetalhesAcoesStore.processos.length,
                              itemBuilder: (context, index) {
                                ProcessoListagemModel processo =
                                    clientesDetalhesAcoesStore.processos[index];
                                return CardProcessoComponent(
                                    processoListagem: processo);
                              },
                            ),
                            Visibility(
                              visible:
                                  clientesDetalhesAcoesStore.processos.length >
                                      3,
                              child: Align(
                                alignment: Alignment.center,
                                child: TextButton.icon(
                                  onPressed: () {
                                    Modular.to.pushNamed(
                                        '/sistema/clientes/detalhes/processos/${cliente!.codigo}');
                                  },
                                  label: Text(
                                      "Ver todos os ${clientesDetalhesAcoesStore.processos.length} processos"),
                                  icon: const Icon(Icons.search),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SelectableText(
                        'Ações',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Visibility(
                        visible: cliente != null,
                        child: ScopedBuilder<ClientesDetalhesAcoesStore, int>(
                          store: clientesDetalhesAcoesStore,
                          onError: (context, erro) => Center(
                            child: Text(
                              erro.toString(),
                            ),
                          ),
                          onLoading: (context) => const Center(
                            child: CircularProgressIndicator.adaptive(),
                          ),
                          onState: (context, state) => widgetAcoes(cliente!),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
