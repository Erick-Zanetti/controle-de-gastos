abstract class LaunchDao {
  static String create =
      "CREATE TABLE IF NOT EXISTS launch(id INTEGER PRIMARY KEY, description TEXT, month INTEGER, year INTEGER, value DOUBLE, type TEXT, receive INTEGER)";
}
