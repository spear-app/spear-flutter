import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:http/http.dart' as http;
import 'package:spear_ui/layouts/home_screen.dart';

class Auth with ChangeNotifier {
  late String _token;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_token != null) {
      return _token;
    }
    return null;
  }

  Future<int> login(
      String email, String password, BuildContext context) async {
    //  print("helloww " + username + "   " + password);
    //var authHeader = '${base64.encode(utf8.encode('$email:$password'))}';

    //print('Bearer $authHeader');
    final url = Uri.parse(
        'http://172.18.160.1:8000/api/login');
    final response = await http.post(url,
        /*headers: {
          "Content-Type": "application/json",
          HttpHeaders.authorizationHeader: "Bearer $authHeader"
        },*/
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
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    }
    return response.statusCode;
  }


  Future<int> signUp(
      String email, String password, String name, String gender,BuildContext context) async {
    //  print("helloww " + username + "   " + password);
    //var authHeader = '${base64.encode(utf8.encode('$email:$password'))}';

    //print('Bearer $authHeader');
    final url = Uri.parse(
        'http://172.18.160.1:8000/api/signup');
    final response = await http.post(url,
        /*headers: {
          "Content-Type": "application/json",
          HttpHeaders.authorizationHeader: "Bearer $authHeader"
        },*/
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
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    }
    return response.statusCode;
  }
}