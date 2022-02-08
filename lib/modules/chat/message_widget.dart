import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spear_ui/shared/costant.dart';

class MessageWidget extends StatelessWidget {
  bool? sent;
  //String? senderName;
  String? content;
  String? senderName;
  int? time;
  MessageWidget({required this.content,required this.sent, required this.senderName, required this.time});

  @override
  Widget build(BuildContext context) {
    return content == null
        ? Container()
        : (sent == true
        ? sentMessage(content!, time!)
        : RecievedMessage(content!, senderName!, time!));
  }
}

class sentMessage extends StatelessWidget {
  String content;
  int time;
  sentMessage(this.content, this.time);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
              padding: EdgeInsets.all(12),
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: orange,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
              child: Text(content, style: TextStyle(color: Colors.white)))
        ],
      ),
    );
  }
}

class RecievedMessage extends StatelessWidget {
  String content;
  String senderName;
  int time;
  RecievedMessage(this.content, this.senderName, this.time);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            senderName,
            style: TextStyle(color: blue),
          ),
          Row(
            children: [
              Container(
                  padding: EdgeInsets.all(12),
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                          topLeft: Radius.circular(12))),

                  child: Text(content,style: TextStyle(color: blue))
              ),
            ],
          )
        ],
      ),
    );
  }
}

