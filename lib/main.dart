import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spear_ui/modules/Forward/forward_screen.dart';
import 'package:spear_ui/modules/Welcome/welcome_screen.dart';
import 'package:spear_ui/modules/login/login_screen.dart';
import 'package:spear_ui/shared/models/auth.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  String? name = prefs.getString('name');
  var forward = prefs.getBool("forward");

  runApp(MyApp(home:token==null?LoginPage():WelcomeScreen(name!)));
}

class MyApp extends StatelessWidget {
  MyApp({Key? key, required this.home}) : super(key: key);
  final Widget home;

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
        navigatorObservers: [FlutterSmartDialog.observer],
        builder: FlutterSmartDialog.init(),
      ),
    );
  }
}

