

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spear_ui/modules/Welcome/welcome_screen.dart';
import 'package:spear_ui/shared/constant.dart';
import 'package:spear_ui/shared/models/api_services.dart';
import 'package:spear_ui/shared/models/notification.dart';

class NotificationScreen extends StatefulWidget {
  static const String title = "title";
  static const String body = "body";
  static DateTime dateTimee = DateTime(2000);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Notificationn> notificationsList = [new Notificationn(NotificationScreen.title,  NotificationScreen.body, NotificationScreen.dateTimee, 2),
    new Notificationn(NotificationScreen.title,  NotificationScreen.body, NotificationScreen.dateTimee, 2),
    new Notificationn(NotificationScreen.title,  NotificationScreen.body, NotificationScreen.dateTimee, 2),
    new Notificationn(NotificationScreen.title,  NotificationScreen.body, NotificationScreen.dateTimee, 2)];


  fetchNotification()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    int? id = pref.getInt("id");
    SmartDialog.showLoading();
    try{
      ApiServices api = ApiServices(token!);
      final responce = api.fetchNotification(id);
      if (responce != 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('error in getting notifications')));
      }
      SmartDialog.dismiss();

    }catch(e)
    {
      SmartDialog.dismiss();
      print (e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading:IconButton(icon:Icon( Icons.arrow_back,),onPressed:()async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String? name = prefs.getString('name');
            Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) => WelcomeScreen(name!)),
                  (Route<dynamic> route) => false,
            );
          } ,)
      ),
      body: Stack(
        children: [
          Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/background.png"), fit: BoxFit.fill),
              ),
              child: listView()),
        ],
      ),
    );
  }

  PreferredSizeWidget appBar() {
    return AppBar(
      title: Text("Notification Screen"),
    );
  }

  Widget listView() {
    return ListView.separated(
        itemBuilder: (context, index) {
          return listViewItem(notificationsList[index], index);
        },
        separatorBuilder: (context, index) {
          return Divider(height: 0);
        },
        itemCount: notificationsList.length);
  }

  Widget listViewItem(Notificationn notification, int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          prefixIcon(),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [message(notification, index), timeAndDate(index)],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget prefixIcon() {
    return Container(
        height: 50,
        width: 50,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey.shade300,
        ),
        child:
            Icon(Icons.notifications, size: 25, color: orange));
  }

  Widget message(Notificationn notification, int index) {
    double textSize = 14;
    return Container(
      child: RichText(
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          text: "NotificationTitle",
          style: TextStyle(
              fontSize: textSize,
              color: Colors.black,
              fontWeight: FontWeight.bold),
          children: [
            TextSpan(
              text: ' Notification description',
              style: TextStyle(
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget timeAndDate(int index) {
    return Container(
        margin: EdgeInsets.only(top: 5),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('23-3-2-2022',
              style: TextStyle(
                fontSize: 10,
              )),
          Text(
            '7:10 AM',
            style: TextStyle(
              fontSize: 10,
            ),
          )
        ]));
  }
}
