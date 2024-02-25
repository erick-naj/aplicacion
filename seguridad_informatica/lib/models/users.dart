import 'package:encrypt/encrypt.dart' as encrypt;

class User {
  int? id;
  String? name = "";
  String? userName;
  String? password;
  encrypt.Encrypted? data;

  User({this.name, this.userName, this.password, this.data});
  User.withId({this.id, this.name, this.userName, this.password, this.data});

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    if (id != null) {
      map["id"] = id;
    }
    map["name"] = name;
    map["user_name"] = userName;
    map["password"] = password;

    return map;
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User.withId(
      id: map['id'],
      userName: map['user_name'],
      name: map['name'],
      password: map['password'],
    );
  }
}
