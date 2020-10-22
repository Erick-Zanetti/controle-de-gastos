import 'package:flutter/material.dart';
import 'package:spending_control/screens/charts.dart';
import 'package:spending_control/screens/pay.dart';
import 'package:spending_control/screens/receive.dart';
import 'package:spending_control/screens/settings.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    PayList(),
    ReceiveList(),
    Charts(),
    Settings(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  BottomNavigationBarItem getMenuItem(IconData icon, String text) {
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        size: 26,
      ),
      title: Text(
        text,
        style: TextStyle(
          fontSize: 10.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finanças'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(32),
          ),
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          this.getMenuItem(Icons.payment, "Pagar"),
          this.getMenuItem(Icons.attach_money, "Receber"),
          this.getMenuItem(Icons.show_chart, "Graficos"),
          this.getMenuItem(Icons.settings, "Ajustes"),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
