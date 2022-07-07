import 'package:flutter/material.dart';
import 'package:spear_ui/modules/chat/message.dart';
import 'package:spear_ui/shared/constant.dart';
import 'package:spear_ui/shared/logic/text_to_speech.dart';

class MessageWidget extends StatelessWidget {
  final Message message;

  MessageWidget({required this.message});


  @override
  Widget build(BuildContext context) {
    return message.content == null
        ? Container()
        : (message.sent == true
        ? sentMessage(message.content, message.time, message.language)
        : ReceivedMessage(message.content, message.senderName, message.time));
  }
}

class sentMessage extends StatelessWidget {
  final String content;
  final int time;
  final String language;
  sentMessage(this.content, this.time, this.language);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
                padding: EdgeInsets.all(12),
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: orange,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
                child:Text(content,
                  style: const TextStyle(color: Colors.white),
                  softWrap: true,
                )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                child: Icon(Icons.keyboard_voice, color: blue,),
                onTap: (){
                  speak(content, 1 , language);
                },

              )
            ],
          )
        ],
      ),
    );
  }
}

class ReceivedMessage extends StatelessWidget {
  final String content;
  final String senderName;
  final int time;
  ReceivedMessage(this.content, this.senderName, this.time);
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
              Flexible(
                child: Container(
                    padding: EdgeInsets.all(12),
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                            topLeft: Radius.circular(12))),

                    child: Text(content,style: TextStyle(color: blue),softWrap: true,)
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

