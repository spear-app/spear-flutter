import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spear_ui/modules/sign%20up/signup_screen.dart';
import 'package:spear_ui/shared/components.dart';
import 'package:spear_ui/shared/constant.dart';
import 'package:spear_ui/shared/models/auth.dart';
import 'package:spear_ui/shared/models/user.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = 'loginPage';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final loginFormKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  bool isLoading = false;
  bool _isObscure = true;

  var login ;
  final Map<String, String> _authData = {
    'username': '',
    'password': '',
  };
  bool showPassword = false;
  bool obsecurePassword = true;
  validate(BuildContext context) async {
    SmartDialog.showLoading();
    try {
      final loginResponse = await login.login(
          email, password, context);

      if (loginResponse != 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('wrong email or password')));
      } else {
        String? token = Provider
            .of<Auth>(
          context,
          listen: false,
        ).token;

        User? user = Provider
            .of<Auth>(
          context,
          listen: false,
        ).currentUser;

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', token!.trim());
        prefs.setString('name', user!.name.trim());
        prefs.setInt("id", user!.id);
        int gender = 1;
        if (user!.gender.trim() == "MALE")
          gender = 0;
        prefs.setInt("gender", gender);
      }
      SmartDialog.dismiss();
    }
    catch(e)
    {
      print(e);
      SmartDialog.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    login = Provider.of<Auth>(
      context,
      listen: false,
    );
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

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
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: Container(),
            ),
            body:SingleChildScrollView(
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
                              onSaved: (value) {
                                _authData['email'] = value!;
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
                              onSaved: (value) {
                                _authData['password'] = value!;
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
                    customRoundedButton("Login", Size(width / 10, 12),()async{

                      if (loginFormKey.currentState?.validate()==true)
                      {
                        validate(context);

                      }
                      else
                      {
                        print("invalidddd");
                      }
                    }),
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
