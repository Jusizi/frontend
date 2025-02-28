import 'package:flutter/material.dart';

enum LayoutConf {
  onlyAppBar,
  onlyNavRail,
  alternate,
  bothFixed,
  bothNavRailHidden,
  bothAppBarHidden,
}

enum NavTypeDisplay {
  none,
  both,
  appBar,
  navigationRail;
}

class NavType {
  NavType(this.conf);

  final LayoutConf conf;

  NavTypeDisplay _typeDisplay = NavTypeDisplay.none;
  NavTypeDisplay get typeDisplay => _typeDisplay;

  bool get showDrawer {
    return _typeDisplay == NavTypeDisplay.appBar;
  }

  bool diffFrom(NavTypeDisplay newValue) => _typeDisplay == newValue;

  NavTypeDisplay fromConstraints(
    BoxConstraints constraints, {
    void Function(NavTypeDisplay oldValue, NavTypeDisplay newValue)? onChange,
  }) {
    switch (conf) {
      case LayoutConf.bothNavRailHidden:
        if (constraints.maxHeight > constraints.maxWidth) {
          const value = NavTypeDisplay.appBar;
          if (diffFrom(value)) {
            onChange?.call(_typeDisplay, value);
          }
          _typeDisplay = value;
          break;
        }
        const value = NavTypeDisplay.both;
        if (diffFrom(value)) {
          onChange?.call(_typeDisplay, value);
        }
        _typeDisplay = value;
        break;

      case LayoutConf.bothAppBarHidden:
        if (constraints.maxHeight > constraints.maxWidth) {
          const value = NavTypeDisplay.both;
          if (diffFrom(value)) {
            onChange?.call(_typeDisplay, value);
          }
          _typeDisplay = value;
          break;
        }
        const value = NavTypeDisplay.navigationRail;
        if (diffFrom(value)) {
          onChange?.call(_typeDisplay, value);
        }
        _typeDisplay = value;
        break;
      case LayoutConf.alternate:
        if (constraints.maxHeight > constraints.maxWidth) {
          const value = NavTypeDisplay.appBar;
          if (diffFrom(value)) {
            onChange?.call(_typeDisplay, value);
          }
          _typeDisplay = value;
          break;
        }

        const value = NavTypeDisplay.navigationRail;
        if (diffFrom(value)) {
          onChange?.call(_typeDisplay, value);
        }
        _typeDisplay = value;
        break;

      case LayoutConf.onlyAppBar:
        const value = NavTypeDisplay.appBar;
        if (diffFrom(value)) {
          onChange?.call(_typeDisplay, value);
        }
        _typeDisplay = value;
        break;

      case LayoutConf.onlyNavRail:
        const value = NavTypeDisplay.navigationRail;
        if (diffFrom(value)) {
          onChange?.call(_typeDisplay, value);
        }
        _typeDisplay = value;
        break;

      case LayoutConf.bothFixed:
        const value = NavTypeDisplay.both;
        if (diffFrom(value)) {
          onChange?.call(_typeDisplay, value);
        }
        _typeDisplay = value;
        break;
    }
    return _typeDisplay;
  }

  Size get sizeForAppBar {
    if (_typeDisplay == NavTypeDisplay.appBar ||
        _typeDisplay == NavTypeDisplay.both) {
      return const Size.fromHeight(kToolbarHeight);
    }
    return Size.zero;
  }

  bool get showNavigationRail => !hiddenNavigationRail;
  bool get hiddenNavigationRail {
    if (_typeDisplay == NavTypeDisplay.navigationRail ||
        _typeDisplay == NavTypeDisplay.both) {
      return false;
    }
    return true;
  }
}
