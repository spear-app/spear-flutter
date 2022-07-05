import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'dart:async';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:permission_handler/permission_handler.dart';

const theSource = AudioSource.microphone;
/*class Record{

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
      toFile: '/data/user/0/com.example.recorder2/cache/${x}.wav',
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
        _mplaybackReady = true;
        print("reeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee  ");
        print('${x}.wav');
      });
    });
  }

  void dostopRecorder()
  async{
    timer.cancel();

    if (!_mRecorder!.isStopped)
    {
      await stopRecorder();
    }
    print("reeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee     ${x}");



    //play();
  }

}*/