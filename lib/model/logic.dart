import 'dart:convert';
import 'package:http/http.dart' as http;

class Logic {
  /**
   * Faz uma requisição http para a url informada
   * @return Future<Map> Contendo resposta da requisição
   */
  static Future<Map> getData(url) async {
    http.Response response;
    response = await http.get(url);
    return json.decode(response.body);
  }
}
