class User {
  static final User _singleton = User._internal();
  factory User() => _singleton;
  User._internal();
  static User get userData => _singleton;

  String name;
  String phone;
  String city;
  String gender;
  String address;
  String email;
}
