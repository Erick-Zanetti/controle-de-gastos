import 'package:flutter/material.dart';
import 'package:spending_control/components/add_launch.dart';
import 'package:spending_control/components/list_launch.dart';

class ReceiveList extends StatefulWidget {
  @override
  _ReceiveListState createState() => _ReceiveListState();
}

class _ReceiveListState extends State<ReceiveList> {
  @override
  Widget build(BuildContext context) {
    ListLaunchs listLaunchs = ListLaunchs("+");
    return Scaffold(
      body: listLaunchs,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openAddLaunch(context, "+").then((value) {
            listLaunchs.superLoadList();
          });
        },
        child: Icon(
          Icons.add,
        ),
        backgroundColor: Colors.green,
      ),
    );
  }
}
