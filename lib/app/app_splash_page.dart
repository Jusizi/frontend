import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppSplashPage extends StatefulWidget {
  const AppSplashPage({super.key});

  @override
  State<AppSplashPage> createState() => _AppSplashPageState();
}

class _AppSplashPageState extends State<AppSplashPage> {
  @override
  void initState() {
    super.initState();

    Modular.to.navigate('/auth/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: GlobalKey(),
      body: const Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }
}
