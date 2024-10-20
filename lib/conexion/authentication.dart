import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:prueba_simpleagri/controlador/shared_preferences.dart';

class Authentication {

  String lang = Platform.localeName.split('_')[0] == 'es' ? 'spa' : 'eng';

  Future login( String user, String password) async {
    late var response;
    try {
      String url ='https://${Preferences.prefs_http_host}/${Preferences.prefs_http_index}';

        response = await http.post(Uri.parse(url), headers: {
          'user': user,
          'password': password,
          'type': 'M',
          'language': 'spa'
        });
        if (response.statusCode == 200)
          return response.headers['set-cookie'];
        else
          throw Exception(utf8.decode(base64Url.decode(response.reasonPhrase)));

    } catch (exception) {
      throw Exception(utf8.decode(base64Url.decode(response.reasonPhrase)));
    }
  }

}