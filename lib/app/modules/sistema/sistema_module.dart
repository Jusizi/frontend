import 'package:flutter_modular/flutter_modular.dart';

import '../../app_module.dart';
import '../../repositories/agenda/agenda_repository.dart';
import '../../repositories/agenda/agenda_repository_implementation.dart';
import '../../repositories/boletos/boletos_repository.dart';
import '../../repositories/boletos/boletos_repository_implementacao.dart';
import '../../repositories/clientes/clientes_repository.dart';
import '../../repositories/clientes/clientes_repository_implementation.dart';
import '../../repositories/cobrancas/cobrancas_repository.dart';
import '../../repositories/cobrancas/cobrancas_repository_implementation.dart';
import '../../repositories/contasBancarias/contasbancarias_repository.dart';
import '../../repositories/contasBancarias/contasbancarias_repository_implementation.dart';
import '../../repositories/contratos/contratos_repository.dart';
import '../../repositories/contratos/contratos_repository_implementation.dart';
import '../../repositories/financeiro/financeiro_repository.dart';
import '../../repositories/financeiro/financeiro_repository_implementation.dart';
import '../../repositories/minhasinformacoes/minhasinformacoes_repository.dart';
import '../../repositories/minhasinformacoes/minhasinformacoes_repository_implementation.dart';
import '../../repositories/modelos/modelos_repository.dart';
import '../../repositories/modelos/modelos_repository_implementation.dart';
import '../../repositories/planodecontas/planodecontas_repository.dart';
import '../../repositories/planodecontas/planodecontas_repository_implementation.dart';
import '../../repositories/processos/processos_repository.dart';
import '../../repositories/processos/processos_repository_implementation.dart';
import 'notfound_page.dart';
import 'pages/agenda/agenda_atualizar_compromisso_page.dart';
import 'pages/agenda/agenda_novo_compromisso_page.dart';
import 'pages/agenda/agenda_page.dart';
import 'pages/agenda/agenda_store.dart';
import 'pages/boletos/boletos_store.dart';
import 'pages/caixamovimentacoes/caixamovimentacoes_store.dart';
import 'pages/caixamovimentacoes/pages/caixamovimentacoes_conta_nova_page.dart';
import 'pages/caixamovimentacoes/pages/caixamovimentacoes_conta_page.dart';
import 'pages/caixamovimentacoes/pages/caixamovimentacoes_page.dart';
import 'pages/clientes/cliente_por_cpf.dart';
import 'pages/clientes/clientes_detalhes_page.dart';
import 'pages/clientes/clientes_detalhes_processos_page.dart';
import 'pages/clientes/clientes_historico_page.dart';
import 'pages/clientes/clientes_novo_page.dart';
import 'pages/clientes/clientes_page.dart';
import 'pages/clientes/clientes_store.dart';
import 'pages/boletos/cobranca_boleto_detalhes_page.dart';
import 'pages/cobrancas/cobrancas_store.dart';
import 'pages/cobrancas/pages/cobranca_historico_page.dart';
import 'pages/cobrancas/pages/cobranca_nova_page.dart';
import 'pages/cobrancas/pages/cobrancas_detalhes_page.dart';
import 'pages/cobrancas/pages/cobrancas_page.dart';
import 'pages/configuracoes/pages/configuracoes_page.dart';
import 'pages/contasbancarias/contasbancarias_store.dart';
import 'pages/contasbancarias/pages/contabancaria_detalhes_page.dart';
import 'pages/contasbancarias/pages/contabancaria_historico_page.dart';
import 'pages/contasbancarias/pages/contasbancarias_page.dart';
import 'pages/contratos/contratos_store.dart';
import 'pages/contratos/pages/contrato_detalhes_page.dart';
import 'pages/contratos/pages/contrato_novo_page.dart';
import 'pages/contratos/pages/contratos_page.dart';
import 'pages/empresa/empresa_page.dart';
import 'pages/financeiro/financeiro_store.dart';
import 'pages/financeiro/pages/financeiro_page.dart';
import 'pages/home_page.dart';
import 'pages/modelos/modelos_store.dart';
import 'pages/modelos/pages/modelo_gerar_documento_cliente_page.dart';
import 'pages/modelos/pages/modelo_novo_detalhes.dart';
import 'pages/modelos/pages/modelo_novo_page.dart';
import 'pages/modelos/pages/modelos_page.dart';
import 'pages/planodecontas/planodecontas_store.dart';
import 'pages/processos/pages/processo_detalhes_page.dart';
import 'pages/processos/pages/processo_movimentacoes_page.dart';
import 'pages/processos/pages/processos_page.dart';
import 'pages/processos/processos_store.dart';

class SistemaModule extends Module {
  @override
  List<Module> get imports => [
        AppModule(),
      ];

  @override
  void binds(i) {
    i.addSingleton<PlanodecontasRepository>(
        PlanodecontasRepositoryImplementation.new);
    i.addSingleton<PlanoDeContasStore>(PlanoDeContasStore.new);

    i.addSingleton<CobrancasRepository>(CobrancasRepositoryImplementation.new);

    i.addSingleton<CobrancasStore>(CobrancasStore.new);

    i.addSingleton<BoletosStore>(BoletosStore.new);
    i.addSingleton<BoletosRepository>(BoletosRepositoryImplementacao.new);

    i.addSingleton<AgendaRepository>(AgendaRepositoryImplementation.new);
    i.addSingleton<AgendaStore>(AgendaStore.new);

    i.addSingleton<ModelosRepository>(ModelosRepositoryImplementation.new);
    i.addSingleton<ModelosStore>(ModelosStore.new);

    i.addSingleton<FinanceiroRepository>(
        FinanceiroRepositoryImplementation.new);
    i.addSingleton<FinanceiroStore>(FinanceiroStore.new);

    i.addSingleton<MinhasinformacoesRepository>(
        MinhasinformacoesRepositoryImplementation.new);

    i.addSingleton<ClientesRepository>(ClientesRepositoryImplementation.new);
    i.addSingleton<ClientesStore>(ClientesStore.new);

    i.addSingleton<ProcessosRepository>(ProcessosRepositoryImplementation.new);
    i.addSingleton<ProcessosStore>(ProcessosStore.new);

    i.addSingleton<ContratosRepository>(ContratosRepositoryImplementation.new);
    i.addSingleton<ContratosStore>(ContratosStore.new);

    i.addSingleton<CaixamovimentacoesStore>(CaixamovimentacoesStore.new);

    i.addSingleton<ContasBancariasRepository>(
        ContasBancariasRepositoryImplementation.new);
    i.addSingleton<ContasBancariasStore>(ContasBancariasStore.new);
  }

  @override
  void routes(r) {
    r.child('/', child: (context) => const HomePage());

    // CLIENTES
    r.child('/clientes', child: (context) => const ClientesPage());
    r.child('/clientes/cadastrar',
        child: (context) => const ClientesNovoPage());
    r.child(
      '/clientes/detalhes/:clienteCodigo',
      child: (context) => ClientesDetalhesPage(
        clienteCodigo: r.args.params['clienteCodigo'],
      ),
    );
    r.child('/clientes/cadastrar_por_cpf',
        child: (context) => const ClientePorCPFPage());
    r.child('/clientes/historico',
        child: (context) => ClientesHistoricoPage(cliente: r.args.data!));

    r.child(
      '/clientes/detalhes/processos/:clienteCodigo',
      child: (context) => ClientesDetalhesProcessosPage(
        clienteCodigo: r.args.params['clienteCodigo'],
      ),
    );

    /// CONTRATOS
    r.child('/contratos', child: (context) => const ContratosPage());
    r.child('/contrato/novo', child: (context) => const ContratoNovoPage());
    r.child(
      '/contratos/detalhes/:contratoCodigo',
      child: (context) => ContratoDetalhesPage(
        contratoCodigo: r.args.params['contratoCodigo'],
      ),
    );

    // MODELOS

    r.child('/modelos', child: (context) => const ModelosPage());
    r.child('/modelo/novo', child: (context) => const ModeloNovoPage());
    r.child(
      '/modelo/detalhes/:modeloCodigo',
      child: (context) => ModeloDetalhesPage(
        modeloCodigo: r.args.params['modeloCodigo'],
      ),
    );
    r.child(
      '/modelo/gerardocumentocliente/:modeloCodigo/:clienteCodigo',
      child: (context) => ModeloGerarDocumentoClientePage(
        modeloCodigo: r.args.params['modeloCodigo'],
        clienteCodigo: r.args.params['clienteCodigo'],
      ),
    );

    // PROCESSOS
    r.child('/processos', child: (context) => const ProcessosPage());
    r.child(
      '/processos/detalhe/:processoCodigo',
      child: (context) =>
          ProcessoDetalhesPage(processoCodigo: r.args.params['processoCodigo']),
    );
    r.child('/processos/detalhe/:processoCodigo/movimentacoes',
        child: (context) => ProcessoMovimentacoesPage(processo: r.args.data!));

    // EMPRESA
    r.child('/empresa', child: (context) => const EmpresaPage());

    // CONFIGURAÇÕES
    r.child('/configuracoes', child: (context) => const ConfiguracoesPage());

    // FINANCEIRO
    r.child('/financeiro', child: (context) => const FinanceiroPage());

    // AGENDA
    r.child('/agenda', child: (context) => const AgendaPage());
    // AGENDA
    r.child(
      '/agenda/compromisso/:compromissoCodigo',
      child: (context) => AgendaAtualizarCompromissoPage(
        compromissoCodigo: r.args.params['compromissoCodigo'],
      ),
    );

    r.child(
      '/agenda/novocompromisso/:data/:hora',
      child: (context) => AgendaNovoCompromissoPage(
        data: r.args.params['data'] ?? '',
        hora: r.args.params['hora'] ?? '',
      ),
    );

    // CONTAS BANCÁRIAS
    r.child('/contasbancarias',
        child: (context) => const ContasBancariasPage());
    r.child(
      '/contabancaria/detalhes/:contaBancariaId',
      child: (context) => ContaBancariaDetalhesPage(
        contaBancariaCodigo: r.args.params['contaBancariaId'],
      ),
    );
    r.child(
      '/contabancaria/historico',
      child: (context) => ContabancariaHistoricoPage(
        contaBancaria: r.args.data!,
      ),
    );

    // CAIXA MOVIMENTACOES
    r.child('/caixamovimentacoes',
        child: (context) => const CaixaMovimentacoesPage());

    r.child(
      '/caixamovimentacoes/conta',
      child: (context) => CaixaMovimentacoesContaPage(
        contaBancaria: r.args.data!,
      ),
    );

    r.child(
      '/caixamovimentacoes/nova',
      child: (context) => CaixaMovimentacoesContaNovaPage(
        contaBancaria: r.args.data!,
      ),
    );

    /// COBRANCAS
    r.child('/cobrancas', child: (context) => const CobrancasPage());
    r.child('/cobranca/nova', child: (context) => const CobrancaNovaPage());
    r.child(
      '/cobranca/detalhes/:cobrancaCodigo',
      child: (context) => CobrancasDetalhesPage(
        cobrancaCodigo: r.args.params['cobrancaCodigo'],
      ),
    );
    r.child(
      '/boleto/detalhes/:boletoCodigo',
      child: (context) => CobrancaBoletoDetalhesPage(
        boletoCodigo: r.args.params['boletoCodigo'],
      ),
    );

    r.child('/cobranca/historico',
        child: (context) => CobrancaHistoricoPage(cobranca: r.args.data!));

    // NOT FOUND
    r.wildcard(child: (context) => const NotFoundPage());
  }
}
