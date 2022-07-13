

import 'package:flutter/material.dart';
import 'package:spear_ui/shared/models/notification.dart';

class NotificationScreen extends StatefulWidget {
  static const String title = "title";
  static const String body = "body";
  static DateTime dateTimee = DateTime(2000);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Notificationn> notificationsList = [new Notificationn(NotificationTitle: NotificationScreen.title, NotififcationBody: NotificationScreen.body, time: NotificationScreen.dateTimee),
    new Notificationn(NotificationTitle: NotificationScreen.title, NotififcationBody: NotificationScreen.body, time: NotificationScreen.dateTimee),
    new Notificationn(NotificationTitle: NotificationScreen.title, NotififcationBody: NotificationScreen.body, time: NotificationScreen.dateTimee),
    new Notificationn(NotificationTitle: NotificationScreen.title, NotififcationBody: NotificationScreen.body, time: NotificationScreen.dateTimee)];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/background.png"), fit: BoxFit.fill),
          ),
          child: listView()),
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
            Icon(Icons.notifications, size: 25, color: Colors.grey.shade700));
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
