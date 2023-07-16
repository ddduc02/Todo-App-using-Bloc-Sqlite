class User {
  int? id;
  final String username;
  final String password;

  User(this.username, this.password);

  // User.fromMap(Map<String, dynamic> map, this.username, this.password) {
  //   username = map['username'];
  //   password = map['password'];
  // }

  String get getUsername => username;
  String get getPassword => password;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["username"] = username;
    map["password"] = password;
    return map;
  }
}
