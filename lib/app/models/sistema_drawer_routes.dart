import 'package:flutter/material.dart';

import 'route_data.dart';

class SistemaDrawerRoutes {
  SistemaDrawerRoutes();
  final RouteData inicio = RouteData(
    icon: const Icon(Icons.home_outlined),
    title: 'Início',
    subtitle: 'Pagina inicial',
    route: '/sistema/',
  );

  final RouteData agenda = RouteData(
    icon: const Icon(Icons.calendar_month_outlined),
    title: "Agenda",
    subtitle: "Meus compromissos",
    route: '/sistema/agenda',
  );

  final RouteData contratos = RouteData(
    icon: const Icon(Icons.business_center_outlined),
    title: "Contratos",
    subtitle: "Meus contratos",
    route: '/sistema/contratos',
  );

  final RouteData modelos = RouteData(
    icon: const Icon(Icons.picture_as_pdf_outlined),
    title: "Modelos",
    subtitle: "Gerenciar modelos",
    route: '/sistema/modelos',
  );

  final RouteData processos = RouteData(
    icon: const Icon(Icons.list_alt_outlined),
    title: "Processos",
    subtitle: "Todos os processos",
    route: '/sistema/processos',
  );

  final RouteData clientes = RouteData(
    icon: const Icon(Icons.people_outline),
    title: "Clientes",
    subtitle: "Gerenciar clientes",
    route: '/sistema/clientes',
  );

  final RouteData contasBancarias = RouteData(
    icon: const Icon(Icons.attach_money),
    title: "Financeiro",
    subtitle: "Gerenciar finanças",
    route: '/sistema/financeiro',
  );

  final RouteData minhaempresa = RouteData(
    icon: const Icon(Icons.business),
    title: "Minha Empresa",
    subtitle: "Informações da empresa",
    route: '/sistema/empresa',
  );

  final RouteData configuracoes = RouteData(
    icon: const Icon(Icons.settings_outlined),
    title: "Configurações",
    subtitle: "Configurações do sistema",
    route: '/sistema/configuracoes',
  );

  final RouteData sair = RouteData(
    icon: const Icon(Icons.exit_to_app),
    title: "sair",
    subtitle: "fechar o software",
    route: "/auth/sair",
  );

  List<RouteData> get props => [
        inicio,
        agenda,
        contratos,
        contasBancarias,
        processos,
        clientes,
        //modelos,
        minhaempresa,
        //configuracoes,
        sair,
      ];
}
