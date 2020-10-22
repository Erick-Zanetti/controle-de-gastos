import 'package:spending_control/database/app.database.dart';
import 'package:spending_control/models/launch.dart';
import 'package:sqflite/sqflite.dart';

Future<int> saveLaunchDb(Launch launch) async {
  final Database db = await getDatabase();
  return db.insert('launch', launch.toMap());
}

Future<int> updateLaunchDb(Launch launch) async {
  final Database db = await getDatabase();
  return db.rawUpdate('UPDATE launch SET description = ?, value = ? where id = ?', [launch.description, launch.value, launch.id]);
}

Future<int> deleteLaunchDb(int id) async {
  final Database db = await getDatabase();
  return db.delete('launch', where: "id = ?", whereArgs: [id]);
}

Future<int> updateReceiveLaunchDb(Launch launch) async {
  final Database db = await getDatabase();
  return db.rawUpdate('UPDATE launch SET receive = ? where id = ?', [(launch.receive ? 1 : 0), launch.id]);
}

Future<List<Launch>> getLaunchs(int month, int year, String type) async {
  final Database db = await getDatabase();
  final List<Map<String, dynamic>> result = await db.query(
    'launch',
    where: "month = ? and year = ? and type = ?",
    orderBy: "value desc",
    whereArgs: [month, year, type],
  );

  return _toList(result);
}

Future<List<LaunchSum>> getLaunchsGroupType(int month, int year) async {
  final Database db = await getDatabase();
  final List<Map<String, dynamic>> result = await db.rawQuery(
    'SELECT sum(value) as value, type FROM launch WHERE month = ? and year = ? GROUP BY type ORDER BY type desc',
    [month, year],
  );
  final List<LaunchSum> launchs = List();
  for (Map<String, dynamic> row in result) {
    final LaunchSum launchSum = LaunchSum(
      row['value'],
      row['type'],
    );
    launchs.add(launchSum);
  }
  return launchs;
}

List<Launch> _toList(List<Map<String, dynamic>> result) {
  final List<Launch> launchs = List();
  for (Map<String, dynamic> row in result) {
    final Launch launch = Launch(
      row['id'],
      row['description'],
      row['month'],
      row['year'],
      row['value'],
      row['type'],
      (row['receive'] == 1 ? true : false),
    );
    launchs.add(launch);
  }
  return launchs;
}
