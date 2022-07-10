import 'dart:convert';
import 'dart:html';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:spear_ui/modules/Welcome/welcome_screen.dart';
import 'package:spear_ui/modules/chat/conversation_screen.dart';
import 'package:spear_ui/shared/models/message.dart';

class ApiServices{

  String diarization = "";
  String forward = "";
  String startConv= "http://192.168.100.10:8000/api/audio/start_conversation";
  String endConv= "http://192.168.100.10:8000/api/audio/end_conversation";
  String sendAudioApi = "http://localhost:8000/api/audio/send_audio";

  Dio dio = new Dio();

  late String token;

  void initDio() {
    dio.options.headers["Authorization"] = 'bearer $token';
  }

  static final ApiServices _api = ApiServices._internal();
  factory ApiServices(String token) {
    _api.token = token;
    _api.initDio();
    return _api;
  }

  static ApiServices getinstance() {
    return _api;
  }

  ApiServices._internal();

  /*
  *  createDepartment(String depName) async {
    final response = await dio.post(
        "http://kerols3489-001-site1.btempurl.com/department/Insert",
        data: jsonEncode(<String, String>{
          'name': depName,
        }));
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('failed to create deprtment');
    }
  }

  * */


  startConversation (context) async{
    final response = await dio.post(startConv,
      data: jsonEncode(<String, bool>{
        "start_conversation":true,
      }));

    if (response.statusCode == 200)
      {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> ConversationScreen()));
        return response;
      }
    else{
      throw Exception('failed to start conversation');
    }
  }

  endConversation () async{
    final response = await dio.post(endConv,
        data: jsonEncode(<String, bool>{
          "end_conversation":true,
        }));

    if (response.statusCode == 200)
    {
      return response;
    }
    else{
      throw Exception('failed to start conversation');
    }
  }

  sendAudio (path, fileName) async
  {
    FormData formData = FormData.fromMap({
      "file":
      await MultipartFile.fromFile(path, filename:fileName),
    });
    final response = await Dio().post(sendAudioApi,
    options: Options(
      contentType: Headers.jsonContentType,
      //responseType: ResponseType.json,
      //headers:{"Authorization":'bearer $token'},
    ),
      data: formData
    );

    if (response.statusCode ==200)
      {
        return Message.fromJson(jsonDecode(response.data));
      }
    else {
      throw Exception("error in sending audio");
    }
  }
}