import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:spear_ui/modules/Welcome/welcome_screen.dart';
import 'package:spear_ui/shared/components.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spear_ui/shared/components.dart';
import 'package:spear_ui/shared/models/api_services.dart';

class ForwardScreen extends StatefulWidget {
  const ForwardScreen({Key? key}) : super(key: key);

  @override
  State<ForwardScreen> createState() => _ForwardScreenState();
}

class _ForwardScreenState extends State<ForwardScreen> {

  late StreamSubscription _intentDataStreamSubscription;
  TextEditingController textController = new TextEditingController();
  List<SharedMediaFile>? _sharedFiles;
  String fileName = "File Name";
  String _sharedText = "";
  String path = "";
  void initState() {
    super.initState();

    // For sharing images coming from outside the app while the app is in the memory
    _intentDataStreamSubscription = ReceiveSharingIntent.getMediaStream()
        .listen((List<SharedMediaFile> value) {
      setState(() {
        _sharedFiles = value;
        print("Shared:" + (_sharedFiles?.map((f) => f.path).join(",") ?? ""));
        print("Shared:" + (_sharedFiles?.map((f) => f.type).join(",") ?? ""));
        print(_sharedFiles?.first.path);
      });
    }, onError: (err) {
      print("getIntentDataStream error: $err");
    });

    // For sharing images coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile> value) {
      setState(() async{
        _sharedFiles = value;
        fileName = "${_sharedFiles?.first.path}";
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool("forward", true);
      });
    });

  }

  end()
  async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("forward");
  }
  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    textController.dispose();
    end();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading:IconButton(icon:Icon( Icons.arrow_back),onPressed:()async {
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
          Container(color: Colors.white),
          Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/background.png"),
                    fit: BoxFit.fill)),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: height / 4, right: width/7, left: width/7),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    customRoundedButton("View text", Size(width / 2, 50), () async{
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      var token = prefs.getString('token');
                      ApiServices api = ApiServices.getinstance(token!);
                      path ="${_sharedFiles?.first.path}";
                      final uri = Uri.parse(path);
                      File file = File(uri.path);
                      api.forwardAudio(file, _sharedFiles?.first.path).then((value){
                        setState((){
                          _sharedText = value;
                          textController.text = _sharedText;
                        });
                      });
                      //_sharedFiles?.clear();
                    }),
                    //Text(fileName),
                    SizedBox(
                      height: height / 10,
                    ),
                    TextField(
                      controller: textController,
                      /*onChanged: (text) {
                        typedMessage = text;
                      },*/
                      minLines: 10,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 8, horizontal: 8),
                          hintText: "typed message",
                          enabled: false,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(15)))),
                      maxLines: null,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
