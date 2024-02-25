class Student {
  int? id;
  String? registrationTag;
  String? name;
  String? lastName;
  String? group;

  Student(
      {this.id, this.registrationTag, this.name, this.lastName, this.group});

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    if (id != null) {
      map["id"] = id;
    }
    map["registration_tag"] = registrationTag;
    map["name"] = name;

    map["last_name"] = lastName;
    map["student_group"] = group;

    return map;
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
        id: map['id'],
        registrationTag: map['registration_tag'],
        name: map['name'],
        lastName: map['last_name'],
        group: map['student_group']);
  }
}
