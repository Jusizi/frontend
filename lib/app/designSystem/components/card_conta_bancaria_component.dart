import 'package:flutter/material.dart';

import '../../models/conta_bancaria_model.dart';

class CardContaBancariaComponent extends StatelessWidget {
  final ContaBancariaModel contaBancaria;
  final void Function() onTap;
  const CardContaBancariaComponent({
    super.key,
    required this.contaBancaria,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              child: ClipOval(
                child: Image.asset(
                  'assets/icons/bancos/asaas.jpg',
                  cacheHeight: 50,
                  cacheWidth: 50,
                  scale: .5,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            title: Text(contaBancaria.nome),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Banco: ${contaBancaria.banco}'),
              ],
            ),
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}
