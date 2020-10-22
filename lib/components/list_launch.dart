import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spending_control/components/add_launch.dart';
import 'package:spending_control/components/months_calendar.dart';
import 'package:spending_control/database/launch.dart';
import 'package:spending_control/models/launch.dart';

class ListLaunchs extends StatefulWidget {
  final String type;
  _ListLaunchsState __listLaunchsState;

  ListLaunchs(this.type);

  void superLoadList() {
    this.__listLaunchsState.loadList();
  }

  @override
  _ListLaunchsState createState() {
    return this.__listLaunchsState = _ListLaunchsState(this.type);
  }
}

class _ListLaunchsState extends State<ListLaunchs> {
  SharedPreferences sharedPreferences;
  List<Launch> listLaunchs = List();
  final formatCurrency = new NumberFormat.currency(locale: "pt_BR", symbol: "R\$");
  String type;

  _ListLaunchsState(this.type);

  @override
  void initState() {
    this.loadList();
    super.initState();
  }

  void loadList() async {
    SharedPreferences.getInstance().then((prefs) async {
      this.sharedPreferences = prefs;
      int monthPref = prefs.getInt("calendarMonth");
      int yearPref = prefs.getInt("calendarYear");
      this.listLaunchs = await getLaunchs(monthPref, yearPref, this.type);
      setState(() {});
    });
  }

  String sumTotalValue() {
    double sum = this.listLaunchs.fold(0, (sum, element) => sum + (element.value != null ? element.value : 0));
    return this.formatCurrency.format(sum);
  }

  Widget getActionReceive(Launch launch) {
    if (launch.receive) {
      return Container(
        child: IconSlideAction(
          caption: 'Desconfirmar',
          color: Colors.red,
          icon: Icons.cancel,
          onTap: () async {
            launch.setReceive(!launch.receive);
            await updateReceiveLaunchDb(launch);
            setState(() {});
          },
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey),
          ),
        ),
      );
    } else {
      return Container(
        child: IconSlideAction(
          caption: 'Confirmar',
          color: Colors.green,
          icon: Icons.check,
          onTap: () async {
            launch.setReceive(!launch.receive);
            await updateReceiveLaunchDb(launch);
            setState(() {});
          },
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: MonthsCalendar(
            onChangeMonth: () {
              this.loadList();
            },
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 56.0),
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              ...this.listLaunchs.map((launch) {
                return Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  child: Container(
                    child: ListTile(
                      leading: Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Icon(
                          launch.receive ? Icons.check_circle_outline : Icons.cancel,
                        ),
                      ),
                      title: Text(launch.description),
                      subtitle: Text(this.formatCurrency.format((launch.value != null ? launch.value : 0))),
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                  actions: <Widget>[
                    this.getActionReceive(launch),
                  ],
                  secondaryActions: <Widget>[
                    Container(
                      child: IconSlideAction(
                        caption: 'Editar',
                        color: (launch.receive ? Colors.grey : Colors.blue),
                        icon: Icons.edit,
                        onTap: (() {
                          if (launch.receive) {
                            return;
                          }
                          openAddLaunch(context, this.type, launch: launch).then((value) {
                            this.loadList();
                          });
                        }),
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                    Container(
                      child: IconSlideAction(
                        caption: 'Remover',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () async {
                          if (launch.receive) {
                            return;
                          }
                          await deleteLaunchDb(launch.id);
                          this.loadList();
                        },
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                );
              }),
              Container(
                padding: EdgeInsets.only(bottom: 66.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Total",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                          Text(
                            this.sumTotalValue(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
