import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spear_ui/layouts/home_screen.dart';
import 'package:spear_ui/modules/Welcome/welcome_screen.dart';
import 'package:spear_ui/modules/login/login_screen.dart';
import 'package:spear_ui/modules/sign%20up/signup_screen.dart';
import 'package:spear_ui/shared/logic/text_to_speech.dart';
import 'package:spear_ui/shared/models/auth.dart';

import 'modules/chat/conversation_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('email');
  print(email);
  runApp(MyApp(home: email==null?LoginPage():WelcomeScreen()));
}

class MyApp extends StatelessWidget {
  Widget home;
  MyApp({Key? key, required this.home}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (ctx) => Auth(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: home,
      ),
    );
  }
}

