import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spear_ui/shared/components.dart';
import 'package:spear_ui/shared/constant.dart';
import 'package:spear_ui/shared/models/auth.dart';
import 'package:spear_ui/shared/models/user.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({Key? key }) : super(key: key);


  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {

  var verification;
  String code = "";
  final verificationKey = GlobalKey<FormState>();

  validate(BuildContext context) async {
    SmartDialog.showLoading();
    try {
      final signUpResponse = await verification.verify(code.trim(), context);
      if (signUpResponse != 200) {
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('email or password')));
        showErrorMessage('Something went wrong, please try again');
      } else {
        String? token = Provider
            .of<Auth>(
          context,
          listen: false,
        )
            .token;
        User? user = Provider
            .of<Auth>(
          context,
          listen: false,
        ).currentUser;

        print("doneeeeeeeeeeeeeeeeeeeeeeeee");

        SharedPreferences prefs = await SharedPreferences.getInstance();
        //prefs.setString('token', token);
        prefs.setString('token', token!.trim());
        prefs.setString('name', user!.name.trim());
        int gender = 1;
        if (user.gender.trim() == "MALE")
          gender = 0;
        prefs.setInt("gender", gender);
      }
      SmartDialog.dismiss();
    }
    catch(e)
    {
      print (e);
      SmartDialog.dismiss();
      showErrorMessage('Something went wrong, please try again');
    }
  }

  @override
  Widget build(BuildContext context) {
    verification = Provider.of<Auth>(
      context,
      listen: false,
    );
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
                  Text("You will get an OTP via email" , style: TextStyle(color: Colors.grey),),
                  SizedBox(
                    height: height/20,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width / 8),
                    child: Form(
                      key: verificationKey,
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
                          code = newValue;
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height/15,
                  ),
                  customRoundedButton("Verify", Size(width / 2, 12),(){
                    if (verificationKey.currentState?.validate()==true)
                      {
                        validate(context);
                      }
                  }),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Didn't receive the verificaion OTP? ", style: TextStyle(color: Colors.grey, fontSize: 12),),
                      InkWell(
                        onTap: () => null,
                        child: Text(
                          "Resend again",
                          style: TextStyle(
                            color: orange, fontSize: 12
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


  showErrorMessage(String message)
  {
    showDialog(context: context,
        builder: (buildContext) {
          return AlertDialog(
            content: Text(message),
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context);
              },
                  child: Text('OK'))
            ],

          );
        }
    );
  }
}
