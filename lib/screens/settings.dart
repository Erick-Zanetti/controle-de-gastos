import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spending_control/theme/theme.control.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool darkMode = true;

  @protected
  @mustCallSuper
  void initState() {
    this.checkTheme();
  }

  void checkTheme() async {
    var prefs = await SharedPreferences.getInstance();
    setState(() {
      this.darkMode = prefs.getBool("darkMode");
    });
  }

  void onThemeChanged(bool value, ThemeNotifier themeNotifier) async {
    this.darkMode = value;
    (value) ? themeNotifier.setTheme(darkTheme) : themeNotifier.setTheme(lightTheme);
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool("darkMode", value);
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Tema escuro"),
                Switch.adaptive(
                  value: this.darkMode,
                  onChanged: (value) {
                    setState(() {
                      this.onThemeChanged(value, themeNotifier);
                    });
                  },
                ),
              ],
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
