class Launch {
  final int id;
  String description;
  final int month;
  final int year;
  double value;
  final String type;
  bool receive;

  Launch(this.id, this.description, this.month, this.year, this.value, this.type, this.receive);

  setValue(newValue) {
    this.value = newValue;
  }

  setDescription(newDescription) {
    this.description = newDescription;
  }

  setReceive(newReceive) {
    this.receive = newReceive;
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> contactMap = Map();
    contactMap['id'] = this.id;
    contactMap['description'] = this.description;
    contactMap['month'] = this.month;
    contactMap['year'] = this.year;
    contactMap['value'] = this.value;
    contactMap['type'] = this.type;
    contactMap['receive'] = (this.receive ? 1 : 0);
    return contactMap;
  }
}

class LaunchSum {
  double value;
  String type;

  LaunchSum(this.value, this.type);
}
