import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:spear_ui/modules/Welcome/welcome_screen.dart';
import 'package:spear_ui/modules/chat/conversation_screen.dart';
import 'package:spear_ui/shared/models/message.dart';
import 'package:http_parser/http_parser.dart';

class ApiServices{

  String startConv= "http://100.68.80.20:8000/api/audio/start_conversation";
  String endConv= "http://100.68.80.20:8000/api/audio/end_conversation";
  String sendAudioApi = "http://100.68.80.20:8000/api/audio/send_audio";
  String forwardAudioApi = "http://100.68.80.20:8000/api/audio/recorded_audio";

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

  static ApiServices getinstance(String token) {
    _api.token = token;
    _api.initDio();
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

  sendAudio (File file, fileName) async
  {
    FormData formData = FormData.fromMap({
      "audio":
      await MultipartFile.fromFile(file.path, filename:fileName, contentType:new MediaType('audio', 'wav')),
    });
    final response = await dio.post(sendAudioApi, data: formData);
    /*Dio().post(sendAudioApi,
    options: Options(
      contentType: 'audio/wav',
      responseType: ResponseType.json,
      headers:{"Authorization":'bearer $token'},
    ),
      data: formData
    );*/
    print(response.data);
    if (response.statusCode ==200)
      {
        print ('reeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee');
        return Message(content: response.data['text'], language: "ss", sent: false, time: 122, senderName:response.data['speaker']);
      }
    else {
      final responseData = jsonDecode(response.data);
      print(responseData['error']);
      throw Exception("error in sending audio");
    }
  }


  forwardAudio (file, fileName) async
  {
    FormData formData = FormData.fromMap({
      "audio":
      await MultipartFile.fromFile(file.path, filename:fileName),
    });
    final response = await dio.post(forwardAudioApi, data: formData);
    /*Dio().post(sendAudioApi,
    options: Options(
      contentType: 'audio/wav',
      responseType: ResponseType.json,
      headers:{"Authorization":'bearer $token'},
    ),
      data: formData
    );*/

    print(response.data);
    if (response.statusCode ==200)
    {
      print ('reeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee');
      return response.data['text'];
      //return responseData['text'];
    }
    else {
      print(response.data);
      throw Exception("error in sending audio");
    }
  }

}