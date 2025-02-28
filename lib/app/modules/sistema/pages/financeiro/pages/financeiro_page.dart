import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../../designSystem/layout/drawermenuComponent.dart';
import '../../cobrancas/cobrancas_store.dart';
import '../../contasbancarias/contasbancarias_store.dart';

class FinanceiroPage extends StatefulWidget {
  const FinanceiroPage({super.key});

  @override
  State<FinanceiroPage> createState() => _FinanceiroPageState();
}

class _FinanceiroPageState extends State<FinanceiroPage> {
  late ContasBancariasStore contasBancariasStore;
  late CobrancasStore cobrancasStore;

  @override
  void initState() {
    super.initState();

    contasBancariasStore = Modular.get<ContasBancariasStore>();
  }

  Widget cardOption({
    required void Function() onTap,
    required String title,
  }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context,
      {required String title,
      required IconData icon,
      required void Function() destination,
      required Color color}) {
    return GestureDetector(
      onTap: destination,
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: color,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.grey),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Financeiro'),
      ),
      drawer: drawerORleading(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // Colocando os cards em duas colunas
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.1, // Aumenta a área clicável do card
          children: [
            _buildCard(
              context,
              title: 'Cobranças',
              icon: Icons.money,
              destination: () => Modular.to.pushNamed('/sistema/cobrancas'),
              color: Colors.white,
            ),
            _buildCard(
              context,
              title: 'Conta Bancária',
              icon: Icons.account_balance,
              destination: () =>
                  Modular.to.pushNamed('/sistema/contasbancarias'),
              color: Colors.white,
            ),
            _buildCard(
              context,
              title: 'Movimentações do Caixa',
              icon: Icons.assignment,
              destination: () =>
                  Modular.to.pushNamed('/sistema/caixamovimentacoes'),
              color: Colors.white,
            ),
            // Pode adicionar mais cards se necessário
          ],
        ),
      ),
    );
  }
}
