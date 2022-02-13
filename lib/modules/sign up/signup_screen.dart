import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spear_ui/layouts/home_screen.dart';
import 'package:spear_ui/modules/login/login_screen.dart';
import 'package:spear_ui/shared/components.dart';
import 'package:spear_ui/shared/costant.dart';
import 'package:spear_ui/shared/models/auth.dart';

class SignUpPage extends StatefulWidget {
  static const String routeName = 'signUp';

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final signUpFormKey = GlobalKey<FormState>();

  String email = '';
  String name= '';
  String password = '';
  String gender = '';
  String confirmPassword = '';
  bool isLoading = false;
  bool _isObscure = true;

  var signUp ;

  bool showPassword = false;
  bool obsecurePassword = true;

  //Auth auth = new Auth();
  validate(BuildContext context) async {
    final loginResponse = await signUp.login(
        email, password,name,gender, context);
    if (loginResponse != 200) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('email or password')));
    } else{
      String? token = Provider.of<Auth>(
        context,
        listen: false,
      ).token;

      print ("doneeeeeeeeeeeeeeeeeeeeeeeee");

      //SharedPreferences prefs = await SharedPreferences.getInstance();
      //prefs.setString('token', token);
      //prefs.setString('username', _authData['username']);
    }
  }

  @override
  Widget build(BuildContext context) {
    signUp = Provider.of<Auth>(
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
                  Text(
                    "Sign Up",
                    style: TextStyle(
                        color: orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 40),
                  ),
                  Form(
                    key: signUpFormKey,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width / 8),
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'name',
                              labelStyle: TextStyle(
                                  color: Colors.black54, fontSize: 15),
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'please enter your name';
                              }
                              return null;
                            },
                            onChanged: (newValue) {
                              name = newValue;
                            },
                          ),
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
                            decoration: const InputDecoration(
                              labelText: 'gender',
                              labelStyle: TextStyle(
                                  color: Colors.black54, fontSize: 15),
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'please enter your name';
                              }
                              return null;
                            },
                            onChanged: (newValue) {
                              gender = newValue;
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
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(top:20, bottom: 20, left:  width / 8),
                      child: InkWell(
                        onTap: push(context, LoginPage()) ,
                        child: Text(
                          "Already have an account? Login",
                          style: TextStyle(color: blue, fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                  isLoading
                      ? const Center(
                    child: CircularProgressIndicator(),
                  )
                      : customRoundedButton("Sign Up", Size(width / 10, 12), signUpFunc() ),
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

  signUpFunc ()
  {
    var f = signUpFormKey.currentState;
    var f1 = f?.validate();
    if (f1== null)
    {
      print("invalidddd");
    }
    else
    {
      f?.save();
      validate(context);
    }
  }
}
