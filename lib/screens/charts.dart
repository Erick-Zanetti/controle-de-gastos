import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spending_control/components/months_calendar.dart';
import 'package:spending_control/database/launch.dart';
import 'package:spending_control/models/launch.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Charts extends StatefulWidget {
  @override
  _ChartsState createState() => _ChartsState();
}

class _ChartsState extends State<Charts> {
  SharedPreferences sharedPreferences;
  List<Launch> listToPay = List();
  List<Launch> listToReceive = List();
  List<LaunchSum> allList = List();
  bool darkMode = true;
  final formatCurrency = new NumberFormat.currency(locale: "pt_BR", symbol: "R\$");
  List<charts.Color> colorsListPay = [
    charts.MaterialPalette.purple.shadeDefault,
    charts.MaterialPalette.red.shadeDefault,
    charts.MaterialPalette.gray.shadeDefault,
    charts.MaterialPalette.deepOrange.shadeDefault,
    charts.MaterialPalette.pink.shadeDefault,
    charts.MaterialPalette.yellow.shadeDefault,
  ];
  List colorsListReceive = [
    charts.MaterialPalette.blue.shadeDefault,
    charts.MaterialPalette.teal.shadeDefault,
    charts.MaterialPalette.indigo.shadeDefault,
    charts.MaterialPalette.lime.shadeDefault,
    charts.MaterialPalette.cyan.shadeDefault,
    charts.MaterialPalette.green.shadeDefault,
  ];

  @override
  void initState() {
    this.loadLists();
    super.initState();
  }

  void loadLists() async {
    SharedPreferences.getInstance().then((prefs) async {
      if (prefs.getBool("darkMode")) {
        this.darkMode = true;
      } else {
        this.darkMode = false;
      }
      this.sharedPreferences = prefs;
      int monthPref = prefs.getInt("calendarMonth");
      int yearPref = prefs.getInt("calendarYear");
      this.listToPay = await getLaunchs(monthPref, yearPref, "-");
      this.listToReceive = await getLaunchs(monthPref, yearPref, "+");

      this.allList = await getLaunchsGroupType(monthPref, yearPref);

      setState(() {});
    });
  }

  List<charts.Series> generateSeries(String title, List<Launch> list, List colors) {
    var series = [
      charts.Series(
        id: title,
        labelAccessorFn: (Launch launch, _) => '${formatCurrency.format(launch.value)}',
        domainFn: (Launch launch, _) => launch.description,
        measureFn: (Launch launch, _) => launch.value,
        colorFn: (Launch launch, _) {
          int index = _;
          while (index >= colors.length) {
            index = index - colors.length;
          }
          return colors[index];
        },
        data: list,
      ),
    ];
    return series;
  }

  Widget generatePieChart(String title, List<charts.Series> series) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: SizedBox(
        height: 400.0,
        child: charts.PieChart(
          series,
          animate: true,
          behaviors: [
            charts.ChartTitle(
              title,
              behaviorPosition: charts.BehaviorPosition.top,
              titleStyleSpec: charts.TextStyleSpec(
                color: (this.darkMode ? charts.MaterialPalette.white : charts.MaterialPalette.black),
              ),
            ),
            charts.DatumLegend(
              position: charts.BehaviorPosition.top,
              horizontalFirst: false,
              cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
            ),
          ],
          defaultRenderer: charts.ArcRendererConfig(
            arcWidth: 150,
            arcRendererDecorators: [
              charts.ArcLabelDecorator(
                labelPosition: charts.ArcLabelPosition.auto,
                outsideLabelStyleSpec: charts.TextStyleSpec(
                  fontSize: 12,
                  color: (this.darkMode ? charts.MaterialPalette.white : charts.MaterialPalette.black),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (this.listToPay.length == 0 || this.listToReceive.length == 0) {
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text("Sem informações"),
            ),
          ],
        ),
      );
    }
    var seriesPagar = this.generateSeries('Pagar', this.listToPay, this.colorsListPay);
    var seriesReceber = this.generateSeries('Receber', this.listToReceive, this.colorsListReceive);
    List<charts.Series<LaunchSum, String>> seriesList = [
      charts.Series(
        id: 'Resumo',
        domainFn: (LaunchSum launch, _) => launch.type,
        measureFn: (LaunchSum launch, _) => launch.value,
        data: this.allList,
        labelAccessorFn: (LaunchSum launch, _) {
          if (launch.type == "+") {
            return "Receber";
          } else {
            return "Pagar";
          }
        },
        colorFn: (LaunchSum launch, _) {
          if (launch.type == "+") {
            return charts.MaterialPalette.blue.shadeDefault;
          } else {
            return charts.MaterialPalette.red.shadeDefault;
          }
        },
      )
    ];
    return Stack(
      children: [
        MonthsCalendar(
          onChangeMonth: () {
            this.loadLists();
          },
        ),
        Container(
          padding: EdgeInsets.only(top: 56.0),
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  height: 400.0,
                  child: charts.BarChart(
                    seriesList,
                    animate: true,
                    barRendererDecorator: charts.BarLabelDecorator<String>(),
                    domainAxis: charts.OrdinalAxisSpec(),
                  ),
                ),
              ),
              Divider(),
              this.generatePieChart("Pagar", seriesPagar),
              Divider(),
              this.generatePieChart("Receber", seriesReceber),
            ],
          ),
        ),
      ],
    );
  }
}
