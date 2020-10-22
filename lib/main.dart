import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spending_control/screens/home.dart';
import 'package:spending_control/screens/splash.dart';
import 'package:spending_control/theme/theme.control.dart';

void main() async {
  return runApp(
    ChangeNotifierProvider<ThemeNotifier>(
      create: (_) {
        return ThemeNotifier(lightTheme);
      },
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeData theme = lightTheme;
  bool loading = true;

  void startTheme(BuildContext context) {
    if (!this.loading) return;
    SharedPreferences.getInstance().then((prefs) {
      var brightness = SchedulerBinding.instance.window.platformBrightness;
      final themeNotifier = Provider.of<ThemeNotifier>(context);
      setState(() {
        if (prefs.getBool("darkMode") == true || (brightness == Brightness.dark)) {
          this.theme = darkTheme;
          prefs.setBool("darkMode", true);
        } else {
          prefs.setBool("darkMode", false);
        }
        themeNotifier.setTheme(this.theme);
        this.loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    this.startTheme(context);
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      title: 'Controle de Gastos',
      theme: themeNotifier.getTheme(),
      home: (this.loading ? Splash() : HomePage()),
    );
  }
}
