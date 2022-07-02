import 'package:dio/dio.dart';

class ApiServices{

  String diarization = "";
  String forward = "";

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

}