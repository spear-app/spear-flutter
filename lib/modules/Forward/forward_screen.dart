import 'package:flutter/material.dart';
import 'package:spear_ui/shared/components.dart';

class ForwardScreen extends StatefulWidget {
  const ForwardScreen({Key? key}) : super(key: key);

  @override
  State<ForwardScreen> createState() => _ForwardScreenState();
}

class _ForwardScreenState extends State<ForwardScreen> {

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    TextEditingController textController = new TextEditingController();
    return Scaffold(
      body: Stack(
        children: [
          Container(color: Colors.white),
          Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/background.png"),
                    fit: BoxFit.fill)),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: height / 4, right: width/7, left: width/7),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    customRoundedButton("Choose Audio", Size(width / 2, 50), () => null),
                    SizedBox(
                      height: height / 10,
                    ),
                    TextField(
                      controller: textController,
                      /*onChanged: (text) {
                        typedMessage = text;
                      },*/
                      minLines: 10,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 8, horizontal: 8),
                          hintText: "typed message",
                          enabled: false,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(15)))),
                      maxLines: null,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
