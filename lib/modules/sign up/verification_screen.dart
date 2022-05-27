import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spear_ui/layouts/home_screen.dart';
import 'package:spear_ui/shared/components.dart';
import 'package:spear_ui/shared/costant.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({Key? key}) : super(key: key);

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Stack(
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
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(top: height / 10),
              child: Column(
                children: [
                  Icon(Icons.email, size: 100,color: orange,),
                  Text(
                    "Verification",
                    style: TextStyle(
                        color: orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 40),
                  ),
                  Text("You will get an OPT via email" , style: TextStyle(color: Colors.grey),),
                  SizedBox(
                    height: height/8,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width / 8),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Enter Code',
                        labelStyle: TextStyle(
                            color: Colors.black54, fontSize: 15),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'please enter validation code';
                        }
                        return null;
                      },
                      onChanged: (newValue) {
                       // email = newValue;
                      },
                    ),
                  ),
                  SizedBox(
                    height: height/12,
                  ),
                  customRoundedButton("Verify", Size(width / 2, 12),push(context, HomeScreen()) ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Didn't receive the verificaion OPT? ", style: TextStyle(color: Colors.grey),),
                      InkWell(
                        onTap: () => null,
                        child: Text(
                          "Resend again",
                          style: TextStyle(
                            color: orange
                          ),
                        )
                      ),

                    ],
                  ),


                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
