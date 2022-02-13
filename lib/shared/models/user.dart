class User {
  String _id;
  String _name;
  String _email;
  String _gender;
  String _password;
  User.withId(
      this._id, this._name, this._gender, this._email, this._password);

  //users(this._EmployeName, this._phone, this._email, this._username);

  String get id => _id;

  String get password => _password;

  String get name => _name;

  String get gender => _gender;
  String get email => _email;

  set id(String id) => _id = id;


  set name(String value) {
    _name = value;
  }

  set email(String value) {
    _email = value;
  }

  set gender(String value) {
    _gender = value;
  }

  set password(String value) {
    _password = value;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["name"] = _name;
    map["password"] = _password;
    map["email"] = _email;
    map["gender"] = _gender;

    if (_id != null) {
      map["id"] = _id;
    }
    return map;
  }

  factory User.fromJson(dynamic json) {
    return User.withId(
        json["id"] as String,
        json["password"] as String,
        json["gender"] as String,
        json["email"] as String,
        json["name"] as String);
  }


}
