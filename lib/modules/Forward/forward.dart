import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'dart:async';

import 'package:receive_sharing_intent/receive_sharing_intent.dart';

/*void main() => runApp(MyApp());*/

class MyApp2 extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp2> {
  late StreamSubscription _intentDataStreamSubscription;
  List<SharedMediaFile>? _sharedFiles;
  String? _sharedText;

  @override
  void initState() {
    super.initState();

    // For sharing images coming from outside the app while the app is in the memory
    _intentDataStreamSubscription = ReceiveSharingIntent.getMediaStream()
        .listen((List<SharedMediaFile> value) {
      setState(() {
        _sharedFiles = value;
        print("Shared:" + (_sharedFiles?.map((f) => f.path).join(",") ?? ""));
        print("Shared:" + (_sharedFiles?.map((f) => f.type).join(",") ?? ""));
      });
    }, onError: (err) {
      print("getIntentDataStream error: $err");
    });

    // For sharing images coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile> value) {
      setState(() {
        _sharedFiles = value;
        final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();

        _flutterFFmpeg.execute("-i ${_sharedFiles?.map((f) => f.path)} output.wav").then((rc) => print("FFmpeg process exited with rc $rc"));
        //print("Shared:" + (_sharedFiles?.map((f) => f.path).join(",") ?? ""));
      });
    });

    /*// For sharing or opening urls/text coming from outside the app while the app is in the memory
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
      setState(() {
        _sharedText = value;
        print("Shared: $_sharedText");
      });
    }, onError: (err) {
      print("getLinkStream error: $err");
    });

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then((String? value) {
      setState(() {
        _sharedText = value;
        print("Shared: $_sharedText");*/
    /* });*/
    /*});*/
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const textStyleBold = const TextStyle(fontWeight: FontWeight.bold);
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage("assets/images/background.png"))),
            child: Center(
              child: Column(
                children: <Widget>[
                  Text("Shared files:", style: textStyleBold),
                  Text(_sharedFiles
                      ?.map((f) =>
                  "{Path: ${f.path}, Type: ${f.path.toString().replaceFirst("SharedMediaType.", "")}}\n")
                      .join(",\n") ??
                      ""),

                  const Text("Shared urls/text:", style: textStyleBold),
                  Text(_sharedText ?? "")
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
