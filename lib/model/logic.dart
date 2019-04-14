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
    var urlYandex =
        'https://translate.yandex.net/api/v1.5/tr.json/translate?key=trnsl.1.1.20190414T003546Z.04df31d9affd0aff.26abc6da8a51de886ca71d753b28c671f810b6d2&text=' +
            text +
            '&lang=pt';
    var urlGoogle =
        'https://translate.googleapis.com/translate_a/single?client=gtx&sl=en&tl=pt&dt=t&q=' +
            text;
    var response = await http.get(urlYandex);
    if (response.statusCode == 200)
      return translateYandex(response);
    else {
      response = await http.get(urlGoogle);
      if (response.statusCode == 200) return translateGoogle(response);
      return 'Servidor de tradução indisponível...';
    }
  }

  static String translateGoogle(resp) {
    var txtTmp = '';
    var map = json.decode(resp.body);
    var arrayTexts = map[0];
    for (int i = 0; i < arrayTexts.length; i++) {
      txtTmp += arrayTexts[i][0];
    }
    return txtTmp;
  }

  static String translateYandex(resp) {
    var map = json.decode(resp.body);
    return map['text'][0];
  }
}
