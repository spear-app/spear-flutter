import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spear_ui/modules/Welcome/welcome_screen.dart';
import 'package:spear_ui/modules/login/login_screen.dart';
import 'package:spear_ui/modules/sign%20up/signup_screen.dart';
import 'package:spear_ui/shared/costant.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'HomeScreen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchValue='';
  bool isSearching=false;

  late TabController _tabController;

  @override
  Widget build(BuildContext context) {
    List<Tab> screensTabs = [
      const Tab(text: "My Rooms"),
      const Tab(text:"Browse"),
    ];
    //provider = Provider.of<AppProvider>(context);
    List<Widget> screens = [
      WelcomeScreen(),
      const Text("My Rooms"),
    ];

    return
          Scaffold(
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
                        onTap: push(context,LoginPage())
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
              child: WelcomeScreen(),
            ),
          );
  }

  logout()
  {
    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=> LoginPage()));
  }
}