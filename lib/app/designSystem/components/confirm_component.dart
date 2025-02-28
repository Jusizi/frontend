import 'package:flutter/material.dart';

class ConfirmComponent extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback
      onConfirm; // Callback a ser chamado quando o usuário confirmar
  final VoidCallback
      onCancel; // Callback a ser chamado quando o usuário cancelar

  const ConfirmComponent({
    super.key,
    required this.title,
    required this.description,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(description),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            // Chama o callback de cancelamento
            onCancel();
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            // Chama o callback de confirmação
            onConfirm();
            Navigator.of(context).pop();
          },
          child: const Text('Confirmar'),
        ),
      ],
    );
  }
}
