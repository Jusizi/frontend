// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, file_names

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

import '../../shared/stores/app/app_store.dart';
import '../../shared/stores/auth/auth_store.dart';

Widget? drawerORleading() {
  return Modular.to.navigateHistory.length > 2 ? null : DrawerMenuComponent();
}

class DrawerMenuComponent extends StatefulWidget {
  @override
  State<DrawerMenuComponent> createState() => _DrawerMenuComponentState();
}

class _DrawerMenuComponentState extends State<DrawerMenuComponent> {
  late AuthStore authStore;

  late AppStore appStore;

  @override
  void initState() {
    super.initState();
    authStore = Modular.get<AuthStore>();
    appStore = Modular.get<AppStore>();
  }

  Widget _buildError(erro) {
    return Center(
      child: Text(erro.toString()),
    );
  }

  Widget _buildLoading() {
    return _header();
  }

  Widget _header() {
    return Flex(
      direction: Axis.vertical,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/icons/2-preto.png"),
                fit: BoxFit.cover,
                alignment: Alignment.centerRight,
              ),
            ),
            accountName: Text(
              authStore.user.name,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            accountEmail: Text(
              authStore.user.email,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            currentAccountPicture: const FlutterLogo(),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccess() {
    return _header();
  }

  @override
  Widget build(BuildContext context) {
    double tamanhoDraw = 190.0;
    return Drawer(
      child: Column(
        children: [
          SizedBox(
            height: tamanhoDraw,
            child: ScopedBuilder<AuthStore, int>(
              onError: (context, erro) => _buildError(erro!),
              onLoading: (context) => _buildLoading(),
              onState: (context, state) => _buildSuccess(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: appStore.routeSistema.props.length,
              itemBuilder: (context, index) {
                final item = appStore.routeSistema.props[index];
                return ListTile(
                  leading: item.icon,
                  title: Text(item.title),
                  subtitle: Text(item.subtitle),
                  onTap: () {
                    appStore.selectedRouteSistema = index;
                    Modular.to
                      ..pop()
                      ..pushNamed(item.route);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
