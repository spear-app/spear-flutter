class User {
  int _id;
  String _name;
  String _email;
  String _gender;
  //String _password;
  User.withId(
      this._id, this._name, this._gender, this._email);

  //users(this._EmployeName, this._phone, this._email, this._username);

  int get id => _id;

  //String get password => _password;

  String get name => _name;

  String get gender => _gender;
  String get email => _email;

  set id(int id) => _id = id;


  set name(String value) {
    _name = value;
  }

  set email(String value) {
    _email = value;
  }

  set gender(String value) {
    _gender = value;
  }


  factory User.fromJson(dynamic json) {
    return User.withId(
        json["id"] as int,
        json["name"] as String,
        json["gender"] as String,
        json["email"] as String,

    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'gender':gender,
    'email': email,
  };


}
