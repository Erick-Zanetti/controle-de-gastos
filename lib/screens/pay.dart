import 'package:flutter/material.dart';
import 'package:spending_control/components/add_launch.dart';
import 'package:spending_control/components/list_launch.dart';

class PayList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ListLaunchs listLaunchs = ListLaunchs("-");
    return Scaffold(
      body: listLaunchs,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openAddLaunch(context, "-").then((value) {
            listLaunchs.superLoadList();
          });
        },
        child: Icon(
          Icons.add,
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}
