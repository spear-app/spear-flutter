import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spear_ui/layouts/home_screen.dart';
import 'package:spear_ui/modules/Chat/message_widget.dart';
import 'package:spear_ui/shared/costant.dart';
import 'package:spear_ui/shared/logic/text_to_speech.dart';

import 'message.dart';

class ConversationScreen extends StatefulWidget {
  static const routeName = "RoomDetailsScreen";

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  String typedMessage = '';
  List<Message> messagesList = [];
  final String defaultLanguage = 'en-US';

  late String language;
  String? currentLang;
  String? languageCode;
  List<String> languages = <String>[];
  List<String> languageCodes = <String>[];
  String? voice;
  ScrollController _scrollController = ScrollController();


  late TextEditingController messageController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    messageController = TextEditingController(text: typedMessage);
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      initLanguages();
    });
  }

  Future<void> initLanguages() async {
    /// populate lang code (i.e. en-US)
    languageCodes = await tts.getLanguages();

    /// populate displayed language (i.e. English)
    final List<String>? displayLanguages = await tts.getDisplayLanguages();
    if (displayLanguages == null) {
      return;
    }

    languages.clear();
    for (final dynamic lang in displayLanguages) {
      languages.add(lang as String);
    }

    final String? defaultLangCode = await tts.getDefaultLanguage();
    if (defaultLangCode != null && languageCodes.contains(defaultLangCode)) {
      languageCode = defaultLangCode;
    } else {
      languageCode = defaultLanguage;
    }
    language = (await tts.getDisplayLanguageByCode(languageCode!))!;

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {_scrollController.jumpTo(_scrollController.position.maxScrollExtent);});

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

                leading: PopupMenuButton(
                    itemBuilder: (context) => [
                          PopupMenuItem(
                              child: InkWell(
                                  child: const Text('End Conversation'),
                                  onTap: push(context, HomeScreen())))
                        ])),
            body: Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
              decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, offset: Offset(6, 6))
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  color: backgroundColor),
              child: Column(
                children: [
                  Expanded(
                      child: ListView.builder(
                        itemBuilder: (buildContext, index) {
                          return MessageWidget(
                            message: messagesList[index],
                          );
                        },
                        itemCount: messagesList.length,
                        controller: _scrollController,

                  )),
                  Row(
                    children: [
                      InkWell(
                          child: Icon(
                            Icons.language,
                            color: blue,
                            size: 25,
                          ),
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Language List',
                                      style: TextStyle(color: orange),
                                    ),
                                    content: ListView.builder(
                                      itemCount: languages.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return InkWell(
                                          onTap: () {
                                            language = languages[index];
                                            print(language);
                                            Navigator.pop(context);
                                          },
                                          child: Column(
                                            children: [
                                              Text(languages[index],
                                                  style:
                                                      TextStyle(color: blue)),
                                              const Divider(
                                                height: 20,
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                });
                          }),
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
                          maxLines: null,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          sendMessage();
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
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
                              Icon(
                                Icons.keyboard_voice,
                                size: 15,
                                color: backgroundColor,
                              )
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

  void sendMessage() {
    if (typedMessage=="") return;
    final message = Message(
        content: typedMessage,
        time: DateTime.now().microsecondsSinceEpoch,
        senderName: "You",
        sent: true,
        language: language
    );

    speak(typedMessage, 1, language).then((value) {
      setState(() {
        messageController.clear();
        messagesList.add(message);
        typedMessage="";

      });
    });
  }


// }
//
// class RoomDetailsArgs {
//   Room room;
//   RoomDetailsArgs(this.room);
//
}
