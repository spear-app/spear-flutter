import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spear_ui/modules/Chat/message_widget.dart';
import 'package:spear_ui/modules/Welcome/welcome_screen.dart';
import 'package:spear_ui/shared/constant.dart';
import 'package:spear_ui/shared/logic/text_to_speech.dart';
import 'package:spear_ui/shared/models/api_services.dart';
import 'package:spear_ui/shared/models/message.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:permission_handler/permission_handler.dart';


class ConversationScreen extends StatefulWidget {
  static const routeName = "RoomDetailsScreen";

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

const theSource = AudioSource.microphone;

class _ConversationScreenState extends State<ConversationScreen> {
  String typedMessage = '';
  List<Message> messagesList = [];
  final String defaultLanguage = 'en-US';
  SpeechToText speech = SpeechToText();
  String _lastWords = '';
  int gender = 1;
  late String language;
  String? currentLang;
  String? languageCode;
  List<String> languages = <String>[];
  List<String> languageCodes = <String>[];
  String? voice;
  ScrollController _scrollController = ScrollController();
  bool _speechEnabled = false;


  late TextEditingController messageController;
  @override
  void initState() {
    // TODO: implement initState

    messageController = TextEditingController(text: typedMessage);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initLanguages();
    });

    openTheRecorder().then((value) {
      start();
    });


    super.initState();
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

  void dispose() {
    _mRecorder!.stopRecorder();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {_scrollController.jumpTo(_scrollController.position.maxScrollExtent);});

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
                                  onTap:()async
                                  {
                                    dostopRecorder();
                                    timer1.cancel();
                                    await endConversation(context);
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    String? name = prefs.getString('name');
                                    Navigator.pushAndRemoveUntil(context,
                                      MaterialPageRoute(builder: (context)=>WelcomeScreen(name!)),
                                          (Route<dynamic> route) =>false,
                                    );
                                  }
                              ))
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
                        onTap: dostopRecorder,
                        child: Icon(speech.isNotListening ? Icons.mic_off : Icons.mic),
                      ),
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

    speak(typedMessage, gender, language).then((value) {
      setState(() {
        messageController.clear();
        messagesList.add(message);
        typedMessage="";

      });
    });
  }



  var x = 1;
  FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();
  FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();

  Future<void> openTheRecorder() async {
    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
    }
    await _mRecorder!.openRecorder();

    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
      AVAudioSessionCategoryOptions.allowBluetooth |
      AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
      AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));

  }

  void record() async{
    _mRecorder!
        .startRecorder(
      toFile: '/data/user/0/spearapp.com.spear_ui/cache/${x}.wav',
      audioSource: theSource,
    )
        .then((value) {
      setState(() {});
    });
  }
  late Timer timer;
  Future<void>dorecord()async {
    record();
    timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      await stopRecorder();
      setState((){
        x++;
      });
      record();
    });
  }

  Future<void> stopRecorder() async {
    await _mRecorder!.stopRecorder().then((value) {
      setState(() {
        print('${x}.wav');
      });
    });
  }

  int i = 1;
  void dostopRecorder()
  async{

    if (i ==1) {
      timer.cancel();

      if (!_mRecorder!.isStopped) {
        await stopRecorder();
      }
    }
  }


  int count = 1;
  late Timer timer1 ;
  Future <void> getMessageFromApi()
  async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    ApiServices api = ApiServices.getinstance(token!);

    sleep(Duration(seconds: 15));
    timer1 = Timer.periodic(Duration(seconds: 5), (timer) async {
      final uri = Uri.parse("/data/user/0/spearapp.com.spear_ui/cache/${count}.wav");
      File file = File(uri.path);
      api.sendAudio(file, "$count.wav").then((value){
        setState((){
          count ++;
          if (value.senderName != "no speaker found")
            messagesList.add(value);
        });
      });


    });
  }
  
  
  start ()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    gender = prefs.getInt("gender")!;
    Future.wait([dorecord(), getMessageFromApi()]);
  }


  endConversation(context)
  async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    SmartDialog.showLoading();
    try{
      ApiServices api = ApiServices(token!);
      final responce = api.endConversation();
      if (responce != 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('error in ending conversation')));
      }
      SmartDialog.dismiss();
    }catch(e)
    {
      SmartDialog.dismiss();
      print(e);
    }
  }

}
