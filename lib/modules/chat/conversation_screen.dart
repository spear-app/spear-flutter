import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spear_ui/layouts/home_screen.dart';
import 'package:spear_ui/modules/Chat/message_widget.dart';
import 'package:spear_ui/modules/Welcome/welcome_screen.dart';
import 'package:spear_ui/shared/costant.dart';
import 'package:spear_ui/shared/logic/text_to_speech.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'dart:async';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:permission_handler/permission_handler.dart';

import 'message.dart';

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
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      initLanguages();
    });
    //_initSpeech();

    _mPlayer!.openPlayer().then((value) {
      setState(() {
        //_mPlayerIsInited = true;
      });
    });
    openTheRecorder().then((value) {
      dorecord();
    });


    super.initState();
  }


  void _initSpeech() async {
    _speechEnabled = await speech.initialize();
    setState(() {});
    startListening();
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
    _mPlayer!.closePlayer();
    _mPlayer = null;

    super.dispose();
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
                                  onTap: push(context,HomeScreen())))
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


  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
      final message = Message(
          content: _lastWords,
          time: DateTime.now().microsecondsSinceEpoch,
          senderName: "Person 1",
          sent: false,
          language: language
      );
      messagesList.add(message);
    });
  }
 void startListening() async{
    // _logEvent('start listening');
    _lastWords = '';
    // lastError = '';
    // Note that `listenFor` is the maximum, not the minimun, on some
    // recognition will be stopped before this value is reached.
    // Similarly `pauseFor` is a maximum not a minimum and may be ignored
    // on some devices.
    while (true) {
      await speech.listen(
          onResult: _onSpeechResult,
          listenFor: Duration(seconds: 60),
          pauseFor: Duration(seconds: 60),
          partialResults: true,
          localeId: 'ar-EG',
          //onSoundLevelChange:  soundLevelListener,
          cancelOnError: true,
          listenMode: ListenMode.confirmation);

      setState(() {

      });
    }

  }
/*
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }
  void startListening() async {
    await speech.listen(onResult: _onSpeechResult);
    setState(() {});
  }*/

  void _stopListening() async {
    await speech.stop();
    setState(() {});
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



  Codec _codec = Codec.pcm16WAV;
  var x = 1;
  FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();
  FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();

  Future<void> openTheRecorder() async {
    //downloadDirectory= (await getDownloadsDirectory())!;
    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
    }
    await _mRecorder!.openRecorder();
    /*if (!await _mRecorder!.isEncoderSupported(_codec) && kIsWeb) {
      //_codec = Codec.opusWebM;
      //_mPath = 'tau_file.webm';
      if (!await _mRecorder!.isEncoderSupported(_codec) && kIsWeb) {
        _mRecorderIsInited = true;
        return;
      }
    }*/
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

    //_mRecorderIsInited = true;
  }

  void record() async{
    _mRecorder!
        .startRecorder(
      toFile: '/data/user/0/spearapp.com.spear_ui/cache/${x}.wav',
      // codec: _codec,
      audioSource: theSource,
    )
        .then((value) {
      setState(() {});
    });
  }
  late Timer timer;
  void dorecord()async {
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
        //var url = value;
        //_mplaybackReady = true;
        print("reeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee  ");
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
      print("reeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee     ${x}");
    }

    play();
  }

  Future<void> play() async {

    _mPlayer!
        .startPlayer(
        fromURI: "/data/user/0/spearapp.com.spear_ui/cache/${i}.wav",
        //codec:Codec.aacADTS,
        whenFinished: () {
          setState(() async {
            //await deleteFile("/data/user/0/spearapp.com.spear_ui/cache/${i}.wav");
            i++;
          });
        })
        .then((value) {
      setState(() {});
    });
  }

  Future<void> deleteFile(String path) async {
    try {
      File file = new File(path);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print("Error in getting access to the file.");
    }
  }

// }
//
// class RoomDetailsArgs {
//   Room room;
//   RoomDetailsArgs(this.room);
//
}
