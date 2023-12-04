import 'dart:convert';

import 'package:http/http.dart' as http;

class HttpHelper {
  String baseUrl = "https://fcm.googleapis.com/";
  static HttpHelper instance = HttpHelper._();

  factory HttpHelper() {
    return instance;
  }

  HttpHelper._();

  Future<dynamic> getHttp(String endPoint) async {
    Uri uri = Uri.parse("$baseUrl$endPoint");
    http.Response future = await http.get(uri);
    return future.body;
  }

  Future<dynamic> postHttp(String endPoint, Map map) async {
    Uri uri = Uri.parse("$baseUrl$endPoint");
    print(uri);
    print(json.encode(map));

    http.Response future = await http.post(
      uri,
      body: json.encode(map),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':'key=AAAAbn_aJvg:APA91bFvQ8D7pVGvvyCcmMQSM7R71sO1gK-a_7qiRZpdM-r_AVSnk_jHBQTUL4pA-PKG7F0OgkimlTI3kiz6358CeSz0DebBT3uAompJIYi1MTiuryjAkAOXHy51dWdkzSyh1cPmhc-V'
      }
    );
    return future.body;
  }
}
