import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:spear_ui/modules/Welcome/welcome_screen.dart';
import 'package:spear_ui/modules/sign%20up/verification_screen.dart';
import 'package:spear_ui/shared/models/user.dart';

class Auth with ChangeNotifier {
  late String _token;
  static User? _currentUser;


  bool get isAuth {
    return token != null;
  }

  String? get token {
      return _token;
  }
  User? get currentUser {
    if (_currentUser != null) {
      return _currentUser;
    }
    return null;
  }

  Future<int> login(
      String email, String password, BuildContext context) async {
    final url = Uri.parse(
        'http://100.68.80.20:8000/api/login');
    final response = await http.post(url,
        body: json.encode(<String, dynamic>{
          "email": email.trim(),
          "password": password.trim(),
        }));

    print(response.statusCode);
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      if (responseData['error'] != null) {
        print(responseData['error']['message'].toString());
      }
      _token = responseData['token'];
      Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context)=> WelcomeScreen(_currentUser!.name)),
            (Route<dynamic> route) =>false,
      );
      print(responseData['user']);
      _currentUser = User.fromJson(responseData['user']);
    }
    return response.statusCode;
  }


  Future<int> signUp(
      String email, String password, String name, String gender,BuildContext context) async {
    //  print("helloww " + username + "   " + password);
    //var authHeader = '${base64.encode(utf8.encode('$email:$password'))}';

    //print('Bearer $authHeader');
    final url = Uri.parse(
        'http://100.68.80.20:8000/api/signup');
    final response = await http.post(url,
        body: json.encode(<String, dynamic>{
          "name" : name,
          "email" : email,
          "password" : password,
          "gender" : gender
        }));

    print(response.statusCode);
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      if (responseData['error'] != null) {
        print(responseData['error']['message'].toString());
      }
      _token = responseData['token'];
      Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context)=> WelcomeScreen(name)),
            (Route<dynamic> route) =>false,
      );

      print(responseData['user']);
     _currentUser = User.fromJson(responseData['user']);
    }
    return response.statusCode;
  }

  Future<int> verify(String code, BuildContext context)
  async{
    String uri = 'http://100.68.80.20:8000/api/v1/confirmEmail/${_currentUser!.id}';
    print(uri);
    print(code);
    final url = Uri.parse(
        uri);

    final response = await http.post(url,
        body: json.encode(<String, dynamic>{
          "OTP" : code,
        }));

    if (response.statusCode == 200) {

      Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => WelcomeScreen(_currentUser!.name)),
            (Route<dynamic> route) => false,
      );
    }
    print(response.statusCode);
    return response.statusCode;
  }

}