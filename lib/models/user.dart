class User {
  final String? id;
  final String username;
  final String password;
  int isLoggedIn = 0;

  User(this.id, this.isLoggedIn, {required this.username, required this.password});

  User copyWith({
    String? id,
    int? isLoggedIn,
    String? username,
    String? password,
  }) {
    return User(
      id ?? this.id,
      isLoggedIn ?? this.isLoggedIn,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      map['id'],
      map['isLoggedIn'],
      username: map['username'],
      password: map['password'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'isLoggedIn': isLoggedIn,
    };
  }
}
