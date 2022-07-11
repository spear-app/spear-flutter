import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spear_ui/modules/Forward/forward_screen.dart';
import 'package:spear_ui/modules/chat/conversation_screen.dart';
import 'package:spear_ui/shared/components.dart';
import 'package:spear_ui/shared/constant.dart';
import 'package:spear_ui/shared/models/api_services.dart';
import 'package:spear_ui/shared/models/auth.dart';

import '../login/login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen(this.name) ;

  final String name;

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  startConversation(context)
  async {
    SmartDialog.showLoading();
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    try{
      ApiServices api = ApiServices.getinstance(token!);
      final responce = await api.startConversation(context);
      if (responce != 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('error in starting conversation')));
      }
      SmartDialog.dismiss();
    }catch(e)
    {
      SmartDialog.dismiss();
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading:PopupMenuButton(itemBuilder:(context)=>
          [
            PopupMenuItem(
                child: InkWell(
                    child: const Text('Log out'),
                    onTap: ()async{
                      Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (context)=> LoginPage()),
                            (Route<dynamic> route) =>false,
                      );
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.clear();                        }
                )
            )

          ]
          )
      ),
      // floatingActionButton: const FloatingActionButton(
      //   // onPressed: () {
      //   //   navigateTo(context, AddRooms());
      //   // },
      //   child: Icon(Icons.add),
      // ),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/background.png"),
                fit: BoxFit.fill)),
        child:Padding(
          padding: EdgeInsets.only(top: height / 4),
          child: Column(
            children: [
              Text("Welcome ${widget.name.trim()} !",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 35, color: orange, fontWeight: FontWeight.bold)),
              SizedBox(
                height: height / 7,
              ),
              customRoundedButton(
                  "Start A New Conversation", Size(width / 1.22, 50), ()async{
                    await startConversation(context);
              }),
              const SizedBox(
                height: 15,
              ),
              customRoundedButton("My Notifications", Size(width / 1.22, 50), ()=>null),

              const SizedBox(
                height: 15,
              ),
              customRoundedButton("Forward Messages", Size(width / 1.22, 50), (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ForwardScreen() ));
              }),

            ],
          ),
        )
      ),
    );
  }
}
