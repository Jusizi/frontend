import 'package:flutter/material.dart';

import '../../../designSystem/layout/appbarComponent.dart';

class TermosDeUsoPage extends StatefulWidget {
  const TermosDeUsoPage({super.key});

  @override
  State<TermosDeUsoPage> createState() => _TermosDeUsoPageState();
}

class _TermosDeUsoPageState extends State<TermosDeUsoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: GlobalKey(),
      appBar: AppBarComponent(
        title: 'Termos de uso',
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              // Listar termos de uso
              Text("Cancelamento", style: TextStyle(fontSize: 20)),
              Text(
                  "O cancelamento da assinatura pode ser feito a qualquer momento, sem custo adicional, através do painel de controle do cliente. O cancelamento não implica na devolução de valores já pagos."),

              SizedBox(height: 20),

              Text("Suporte", style: TextStyle(fontSize: 20)),
              Text(
                  "O suporte técnico é oferecido via e-mail, de segunda a sexta-feira, das 9h às 18h, exceto em feriados nacionais. O tempo de resposta pode variar de acordo com a demanda. O suporte técnico não inclui a criação de sites, blogs, lojas virtuais ou qualquer outro tipo de conteúdo. O suporte técnico não inclui a criação de sites, blogs, lojas virtuais ou qualquer outro tipo de conteúdo."),
              SizedBox(height: 20),
              Text("Disponiblidade", style: TextStyle(fontSize: 20)),
              Text(
                  "O serviço é oferecido com uma disponibilidade de 99,9%, o que significa que o serviço pode ficar indisponível por até 8 horas e 45 minutos por ano. A disponibilidade é medida mensalmente e é calculada com base no tempo de indisponibilidade total do serviço no período."),
            ],
          ),
        ),
      ),
    );
  }
}
