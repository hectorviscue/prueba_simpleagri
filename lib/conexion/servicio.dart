import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:prueba_simpleagri/controlador/shared_preferences.dart';

class CallService {
  

  Future callMethod(  String classname,String method, Map parameters) async {

    try {
      late var response;
      String url ='https://${Preferences.prefs_http_host}/${Preferences.prefs_http_start}';

      response = await http.post(Uri.parse(url),
            headers: {
                'class': classname,
                'method': method,
                'cookie': 'sess=${Preferences.prefs_authentication}; sess_type=M; lang=spa'
            },
            body: jsonEncode(parameters));
      if (response.statusCode != 200) {
        throw Exception(utf8.decode(base64Url.decode(response.reasonPhrase)));
      }

      var eee = jsonDecode(response.body);
      return eee;

    } catch (exception) {
      print(exception);
      throw Exception(exception.toString().substring(11));
    }

  }
}