import 'package:flutter/material.dart';

import '../../designSystem/layout/drawermenuComponent.dart';

class NotFoundPage extends StatefulWidget {
  const NotFoundPage({super.key});

  @override
  State<NotFoundPage> createState() => _NotFoundPageState();
}

class _NotFoundPageState extends State<NotFoundPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: GlobalKey(),
      drawer: drawerORleading(),
      body: const Center(
        child: Column(
          children: [
            Text('Página não encontrada'),
          ],
        ),
      ),
    );
  }
}
