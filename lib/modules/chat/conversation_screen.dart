import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spear_ui/layouts/home_screen.dart';
import 'package:spear_ui/modules/Chat/message_widget.dart';
import 'package:spear_ui/shared/costant.dart';

class ConversationScreen extends StatefulWidget {
  static const routeName = "RoomDetailsScreen";

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  String typedMessage = '';
  late TextEditingController messageController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    messageController = TextEditingController(text: typedMessage);
  }

  @override
  Widget build(BuildContext context) {
    //final args = ModalRoute.of(context)?.settings.arguments as RoomDetailsArgs;
    // final Stream<QuerySnapshot<Messages>> messagesStream =
    // messageRef.orderBy('time').snapshots();

    return Container(
      child: Stack(
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
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading: false,
              /*actions: [
                IconButton(onPressed: () => Navigator.pop(context) , icon: Icon(CupertinoIcons.clear_circled, size: 27,))
              ],*/

                leading: PopupMenuButton(itemBuilder:(context)=>
                [
                  PopupMenuItem(
                      child: InkWell(
                          child: const Text('End Conversation'),
                          onTap: push(context, HomeScreen())
                      )
                  )
                ]
                )
            ),
            body: Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(color: Colors.black12, offset: Offset(4, 4))
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  color: backgroundColor),
              child: Column(
                children: [
                  Expanded(
                      child: ListView.builder(

                        itemBuilder: (buildContext, index) {
                          var content="content";
                          //print(content);
                          var id="senderId";
                          var senderName="senderName";
                          var time=0;
                          //print(snapshot.data?.docs[index].get("senderName"));
                          return MessageWidget(content,id,senderName,time);
                        },
                        itemCount: 5,
                      )),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: messageController,
                          onChanged: (text) {
                            typedMessage = text;
                          },
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 4),
                              hintText: "type a message",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(12)))),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          //sendMessage();
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 12),
                          decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(12)),
                              color: blue),
                          child: Row(
                            children: [
                              Text(
                                "speak",
                                style: TextStyle(color: backgroundColor),
                              ),
                              Image.asset('assets/images/send.png')
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

//   void sendMessage() {
//     if (typedMessage.isEmpty) return;
//     final newMessageObj = messageRef.doc();
//     final message = Messages(
//         id: newMessageObj.id,
//         content: typedMessage,
//         time: DateTime.now().microsecondsSinceEpoch,
//         senderName:  "Name",
//         senderId: 'id');
//     newMessageObj.set(message).then((value) {
//       setState(() {
//         messageController.clear();
//       });
//     });
//   }
// }
//
// class RoomDetailsArgs {
//   Room room;
//   RoomDetailsArgs(this.room);
//
}