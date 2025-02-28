// ignore_for_file: must_be_immutable, file_names

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../shared/stores/app/app_store.dart';
import 'appbarComponent.dart';
import 'drawermenuComponent.dart';
import 'layout_conf.dart';

class LayoutComponent extends StatefulWidget {
  late String title;
  late Widget body;
  late bool esconderAppBar;
  late bool esconderDrawer;
  late List<Widget>? actions = [Container()];

  bool useNavigationRail;
  Widget? navigationRailLeading;
  Widget? navigationRailTrailing;
  Color? navigationRailBackgroundColor;
  List<NavigationRailDestination>? navigationRailDestinations;
  NavigationRailLabelType selectedRailLabelType;
  void Function(int)? onDestinationSelected;

  LayoutComponent({
    super.key,
    required this.title,
    required this.body,
    this.useNavigationRail = false,
    this.navigationRailDestinations,
    this.esconderAppBar = true,
    this.esconderDrawer = false,
    this.actions,
    this.navigationRailLeading,
    this.navigationRailTrailing,
    this.selectedRailLabelType = NavigationRailLabelType.none,
    this.onDestinationSelected,
  }) : assert(selectedRailLabelType != NavigationRailLabelType.selected);

  @override
  State<LayoutComponent> createState() => _LayoutComponentState();
}

class _LayoutComponentState extends State<LayoutComponent> {
  NavType navigationType = NavType(LayoutConf.alternate);
  NavigationRailLabelType labelType = NavigationRailLabelType.none;
  bool extended = false;
  double groupAlignment = -1.0;
  late AppStore appStore;
  String? currentRoute;

  @override
  void initState() {
    super.initState();
    appStore = Modular.get<AppStore>();
  }

  @override
  Widget build(BuildContext context) {
    double widthMax = MediaQuery.of(context).size.width;
    if (widthMax > 1024) {
      widthMax = 1024;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        navigationType.fromConstraints(constraints);
        return Scaffold(
          appBar: widget.esconderAppBar
              ? null
              : PreferredSize(
                  preferredSize: navigationType.sizeForAppBar,
                  child: AppBarComponent(
                    title: widget.title,
                    actions: widget.actions ?? [Container()],
                  ),
                ),
          drawer: widget.esconderDrawer
              ? null
              : navigationType.showDrawer
                  ? DrawerMenuComponent()
                  : null,
          body: Visibility(
            visible: widget.useNavigationRail,
            replacement: Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: widthMax,
                child: widget.body,
              ),
            ),
            child: Row(
              children: [
                Visibility(
                  visible: !navigationType.hiddenNavigationRail,
                  child: MouseRegion(
                    onEnter: (_) {
                      setState(() {
                        labelType = NavigationRailLabelType.none;
                        extended = true;
                      });
                    },
                    onExit: (_) {
                      setState(() {
                        labelType = widget.selectedRailLabelType;
                        extended = false;
                      });
                    },
                    child: NavigationRail(
                      selectedIndex: appStore.selectedRouteSistema,
                      groupAlignment: groupAlignment,
                      extended: extended,
                      backgroundColor: widget.navigationRailBackgroundColor,
                      onDestinationSelected: widget.onDestinationSelected ??
                          (idx) {
                            setState(() {
                              appStore.selectedRouteSistema = idx;
                            });
                            Modular.to.pushNamed(
                                appStore.routeSistema.props[idx].route);
                          },
                      labelType: labelType,
                      leading: widget.navigationRailLeading,
                      trailing: widget.navigationRailTrailing,
                      destinations: widget.navigationRailDestinations ??
                          appStore.routeSistema.props.map(
                            (rotaData) {
                              return NavigationRailDestination(
                                icon: rotaData.icon,
                                label: Text(rotaData.title),
                              );
                            },
                          ).toList(),
                    ),
                  ),
                ),
                const VerticalDivider(thickness: 1, width: 1),
                widget.body,
              ],
            ),
          ),
        );
      },
    );
  }
}
