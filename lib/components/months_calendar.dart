import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MonthsCalendar extends StatefulWidget {
  Function onChangeMonth;
  @override
  MonthsCalendar({Function onChangeMonth}) {
    this.onChangeMonth = onChangeMonth;
  }

  _MonthsCalendarState createState() => _MonthsCalendarState(onChangeMonth: this.onChangeMonth);
}

class _MonthsCalendarState extends State<MonthsCalendar> {
  Function onChangeMonth;
  int selectedMonth;
  int selectedYear;
  SharedPreferences sharedPreferences;
  final Map<int, String> months = {
    1: 'Jan',
    2: 'Fev',
    3: 'Mar',
    4: 'Mai',
    5: 'Abr',
    6: 'Jun',
    7: 'Jul',
    8: 'Ago',
    9: 'Set',
    10: 'Out',
    11: 'Nov',
    12: 'Dez',
  };

  _MonthsCalendarState({Function onChangeMonth}) {
    this.onChangeMonth = onChangeMonth;
  }

  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      this.sharedPreferences = prefs;
      int monthPref = this.sharedPreferences.getInt("calendarMonth");
      if (monthPref is int) {
        this.selectedMonth = monthPref;
      } else {
        this.selectedMonth = DateTime.now().month;
      }
      int yearPref = this.sharedPreferences.getInt("calendarYear");
      if (yearPref is int) {
        this.selectedYear = yearPref;
      } else {
        this.selectedYear = DateTime.now().year;
      }
      setState(() {});
    });
    super.initState();
  }

  void nextMonth() {
    this.selectedMonth++;
    if (this.selectedMonth >= 13) {
      this.selectedMonth = 1;
      this.selectedYear++;
    }
    if (this.sharedPreferences != null) {
      this.sharedPreferences.setInt("calendarMonth", this.selectedMonth);
      this.sharedPreferences.setInt("calendarYear", this.selectedYear);
    }
    this.onChangeMonth();
  }

  void previusMonth() {
    this.selectedMonth--;
    if (this.selectedMonth <= 0) {
      this.selectedMonth = 12;
      this.selectedYear--;
    }
    if (this.sharedPreferences != null) {
      this.sharedPreferences.setInt("calendarMonth", this.selectedMonth);
      this.sharedPreferences.setInt("calendarYear", this.selectedYear);
    }
    this.onChangeMonth();
  }

  String getTitleText() {
    return (this.selectedMonth is int ? this.months[this.selectedMonth] : "") + (this.selectedYear is int ? "/" + this.selectedYear.toString() : "");
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, -32),
      child: Container(
        height: 88.0,
        color: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  height: 32,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Material(
                  child: Ink(
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          width: 1,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      color: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
                    ),
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: IconButton(
                          icon: Icon(Icons.arrow_back_ios),
                          onPressed: () {
                            this.previusMonth();
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  this.getTitleText(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Material(
                  child: Ink(
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          width: 1,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      color: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
                    ),
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: IconButton(
                          icon: Icon(Icons.arrow_forward_ios),
                          onPressed: () {
                            this.nextMonth();
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
