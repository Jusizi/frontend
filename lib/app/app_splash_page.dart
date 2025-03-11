import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'shared/stores/auth/auth_store.dart';

class AppSplashPage extends StatefulWidget {
  const AppSplashPage({super.key});

  @override
  State<AppSplashPage> createState() => _AppSplashPageState();
}

class _AppSplashPageState extends State<AppSplashPage> {
  @override
  void initState() {
    super.initState();
    //   checkLoggin();
  }

  Future<void> checkLoggin() async {
    AuthStore authStore = Modular.get<AuthStore>();

    if (!authStore.isLoggedIn && authStore.accessToken.isEmpty) {
      Modular.to.navigate('/auth/');
      return;
    }

    Modular.to.navigate('/sistema/');
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
