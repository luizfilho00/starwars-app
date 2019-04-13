import 'dart:convert';
import 'package:http/http.dart' as http;

class Logic {
  /// Faz uma requisição http para a url informada
  /// @return Future<Map> Contendo resposta da requisição

  static Future<Map> getData(url) async {
    http.Response response;
    response = await http.get(url);
    return json.decode(response.body);
  }

  ///Traduz o texto passado por argumento de Inglês para Português e retorna o texto traduzido
  ///@return Future<String> com o texto traduzido
  static Future<String> textToPtBr(String text) async {
    var txtTmp = '';
    var response = await http.get(
        'https://translate.googleapis.com/translate_a/single?client=gtx&sl=en&tl=pt&dt=t&q=' +
            text);
    var map = json.decode(response.body);
    var arrayTexts = map[0];
    for (int i = 0; i < arrayTexts.length; i++) {
      txtTmp += arrayTexts[i][0];
    }
    return txtTmp;
  }
}
