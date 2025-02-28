import 'package:flutter/material.dart';

// Chave global para o ScaffoldMessenger
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class SnackBarComponent {
  // Singleton
  static final SnackBarComponent _instance = SnackBarComponent._internal();

  factory SnackBarComponent() => _instance;

  SnackBarComponent._internal();

  // Método para exibir SnackBars
  void _show(String message, IconData icon, Color color,
      {Color background = Colors.white, int seconds = 2}) {
    final messenger = _getMessenger();
    if (messenger == null) {
      debugPrint(
          'SnackBarComponent: ScaffoldMessenger não encontrado. Verifique se o scaffoldMessengerKey está corretamente configurado.');
      return;
    }

    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: background,
        duration: Duration(seconds: seconds),
        content: Row(
          children: [
            Icon(
              icon,
              color: color,
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontSize: 17, color: Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Métodos para diferentes tipos de mensagens
  void showError(String message) =>
      _show(message, Icons.warning_amber_rounded, Colors.red, seconds: 6);

  void showWarning(String message) =>
      _show(message, Icons.warning_amber_rounded, Colors.yellow, seconds: 5);

  void showSuccess(String message) =>
      _show(message, Icons.check_circle_outline, Colors.green,
          background: Colors.green[100] ?? Colors.green, seconds: 3);

  // Obtém o ScaffoldMessenger globalmente
  ScaffoldMessengerState? _getMessenger() {
    // Usando a chave global para acessar o ScaffoldMessenger
    return scaffoldMessengerKey.currentState;
  }
}
