import 'package:flutter/material.dart';
import 'package:sorted/core/theme/theme.dart';
final _themeGlobalKey = new GlobalKey(debugLabel: 'app_theme');

class AppTheme extends StatefulWidget {
  final child;

  AppTheme({
    this.child,
  }) : super(key: _themeGlobalKey);

  @override
  AppThemeState createState() => new AppThemeState();
}

class AppThemeState extends State<AppTheme> {
  ThemeData _theme = appThemeLight;

  set theme(newTheme) {
    if (newTheme != _theme) {
      setState(() => _theme = newTheme);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new ThemeChanger(
      appThemeKey: _themeGlobalKey,
      child: new Theme(
        data: _theme,
        child: widget.child,
      ),
    );
  }
}

class ThemeChanger extends InheritedWidget {
  static ThemeChanger of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType();
  }

  final ThemeData theme;
  final GlobalKey _appThemeKey;

  ThemeChanger({appThemeKey, this.theme, child})
      : _appThemeKey = appThemeKey,
        super(child: child);

  set appTheme(ThemeData theme) {
    print(theme);
    print(_appThemeKey);
    print(_appThemeKey.currentState as AppThemeState);
    (_appThemeKey.currentState as AppThemeState)?.theme = theme;
  }

  @override
  bool updateShouldNotify(ThemeChanger oldWidget) {
    return oldWidget.theme == theme;
  }
}
