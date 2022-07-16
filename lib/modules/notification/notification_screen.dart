

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spear_ui/modules/Welcome/welcome_screen.dart';
import 'package:spear_ui/shared/constant.dart';
import 'package:spear_ui/shared/models/api_services.dart';
import 'package:spear_ui/shared/models/notification.dart';

class NotificationScreen extends StatefulWidget {

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Notificationn> notificationsList = [];


  fetchNotification()async{
    SmartDialog.showLoading();
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    int? id = pref.getInt("id");
    try{
      ApiServices api = ApiServices(token!);
      List<Notificationn> l =  await api.fetchNotification(id);
      setState(() {

        notificationsList.addAll(l);
        print(notificationsList[2].NotififcationBody);
        print(notificationsList[2].NotificationTitle);
      },);

      SmartDialog.dismiss();

    }catch(e)
    {
      SmartDialog.dismiss();
      print (e);
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    fetchNotification();
    super.initState();
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
          text: notification.NotificationTitle,
          style: TextStyle(
              fontSize: textSize,
              color: Colors.black,
              fontWeight: FontWeight.bold),
          children: [
            TextSpan(
              text: notification.NotififcationBody,
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
          Text(DateFormat('yyyy-MM-dd').format(notificationsList[index].time),
              style: TextStyle(
                fontSize: 10,
              )),
          Text(
            DateFormat('kk:mm').format(notificationsList[index].time),
            style: TextStyle(
              fontSize: 10,
            ),
          )
        ]));
  }
}
