class LocalUser {
  static final LocalUser _singleton = LocalUser._internal();
  factory LocalUser() => _singleton;
  LocalUser._internal();
  static LocalUser get userData => _singleton;

  String firstName;
  String lastName;
  String email;
  String gender;
  String phone;
  int walletAmount;
}
