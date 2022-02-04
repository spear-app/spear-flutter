import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spear_ui/layouts/home_screen.dart';
import 'package:spear_ui/modules/sign%20up/signup_screen.dart';
import 'package:spear_ui/shared/components.dart';
import 'package:spear_ui/shared/costant.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = 'login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final loginFormKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  bool isLoading = false;
  bool _isObscure = true;

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
                  Text(
                    "Login",
                    style: TextStyle(
                        color: orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 40),
                  ),
                  Form(
                    key: loginFormKey,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width / 8),
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'email',
                              labelStyle: TextStyle(
                                  color: Colors.black54, fontSize: 15),
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'please enter your email';
                              }
                              return null;
                            },
                            onChanged: (newValue) {
                              email = newValue;
                            },
                          ),
                          TextFormField(
                            obscureText: _isObscure,
                            decoration: InputDecoration(
                              labelText: "password",
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isObscure
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: orange,
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                },
                              ),
                              labelStyle: const TextStyle(
                                  color: Colors.black54, fontSize: 15),
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'please enter password';
                              }
                              return null;
                            },
                            onChanged: (newValue) {
                              password = newValue;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 20,right: width / 8 ),
                      child: InkWell(
                        onTap: () => null,
                        child: Text(
                          "Forget password?",
                          style: TextStyle(color: orange, fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 20, left:  width / 8),
                      child: InkWell(
                        onTap: push(context, SignUpPage()),
                        child: Text(
                          "Don't have an account? Sign up",
                          style: TextStyle(color: blue, fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                  isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : customRoundedButton("Login", Size(width / 10, 12),push(context, HomeScreen()) ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // LoginButton()
  // {
  //   if(loginFormKey.currentState?.validate()== true)
  //     loginUser();
  // }
  //
  // final database = FirebaseFirestore.instance;
  //
  // loginUser() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   try {
  //     UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
  //         email: email,
  //         password: password
  //     );
  //     if(userCredential.user == null)
  //       showErrorMessage('no user exists with this email and password');
  //     else{
  //       getUsersCollection().doc(userCredential.user!.uid).get().then((user){
  //         provider.updateUser(user.data());
  //         Navigator.pushReplacementNamed(context, HomeScreen.routeName);
  //       } );
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     showErrorMessage(e.message??'Something went wrong, please try again');
  //   }
  //   setState(() {
  //     isLoading = false;
  //   });
  // }
  //
  // showErrorMessage(String message)
  // {
  //   showDialog(context: context,
  //       builder: (buildContext) {
  //         return AlertDialog(
  //           content: Text(message),
  //           actions: [
  //             TextButton(onPressed: (){
  //               Navigator.pop(context);
  //             },
  //                 child: Text('OK'))
  //           ],
  //
  //         );
  //       }
  //   );
  // }
}
