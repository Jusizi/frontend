// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:local_auth/local_auth.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

import '../main.dart';
import 'designSystem/snackbar_component.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

const kWindowsScheme = 'sample';

class _AppWidgetState extends State<AppWidget> {
  final LocalAuthentication auth = LocalAuthentication();

  late AppLinks _appLinks;

  @override
  void initState() {
    super.initState();
    setTripleResolver(tripleResolverCallback);

    initDeepLinks();

    initFirebase();
  }

  T tripleResolverCallback<T extends Object>() {
    return Modular.get<T>();
  }

  Future<void> initDeepLinks() async {
    _appLinks = AppLinks();

    _appLinks.uriLinkStream.listen((uri) {
      debugPrint('onAppLink: $uri');
      openAppLink(uri);
    });
  }

  void openAppLink(Uri uri) {
    Modular.to.pushNamed(uri.path);
  }

  int contadorNotifications = 0;

  Future<void> initFirebase() async {
    if (isTest) {
      return;
    }

    try {
      await FirebaseMessaging.instance.getInitialMessage();
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        if (message.data.isNotEmpty) {
          if (message.data['modularLink'] != null) {
            Modular.to.pushNamed(message.data['modularLink']);
          }
        } else {
          Modular.to.navigate('/notificacoes/');
        }
      });

      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    contadorNotifications += 1;

    // FlutterAppBadger.updateBadgeCount(contadorNotifications);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      key: navigatorKeyGlobal,
      scaffoldMessengerKey: scaffoldMessengerKey,
      title: 'Jusizi',
      debugShowCheckedModeBanner: false,
      routerDelegate: Modular.routerDelegate,
      routeInformationParser: Modular.routeInformationParser,
      darkTheme: FlexThemeData.dark(
        useMaterial3: true,
        fontFamily: 'Ubuntu',
        scheme: FlexScheme.greyLaw,
      ),
      theme: FlexThemeData.light(
        scheme: FlexScheme.greyLaw,
        useMaterial3: true,
        fontFamily: 'Ubuntu',
      ),
      themeMode: ThemeMode.light,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        SfGlobalLocalizations.delegate,
      ],
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],
    );
  }
}
