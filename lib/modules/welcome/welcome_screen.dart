import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spear_ui/modules/Forward/forward_screen.dart';
import 'package:spear_ui/modules/chat/conversation_screen.dart';
import 'package:spear_ui/shared/components.dart';
import 'package:spear_ui/shared/costant.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(top: height / 4),
      child: Column(
        children: [
          Text("Welcome Ahmed!",
              style: TextStyle(
                  fontSize: 35, color: orange, fontWeight: FontWeight.bold)),
          SizedBox(
            height: height / 7,
          ),
          customRoundedButton(
              "Start A New Conversation", Size(width / 1.22, 50), push(context, ConversationScreen())),
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
    );
  }
}
