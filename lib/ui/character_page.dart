import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:star_wars/ui/tools.dart';

class CharacterPage extends StatefulWidget {
  final List _charsUrlList;

  CharacterPage(this._charsUrlList);

  @override
  _CharacterPageState createState() => _CharacterPageState();
}

class _CharacterPageState extends State<CharacterPage> {
  List chars = List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personagens'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Expanded(
              child: Tools.loadingThenRun(
            context,
            _populateCharactersMap(),
            'loading_storm.gif',
            _createCharsTable,
          )),
        ],
      ),
    );
  }

  /*
  * Envia requisição http e retorna resposta como json
  */
  Future<Map> _getCharacterInfo(url) async {
    http.Response response;
    response = await http.get(url);
    return json.decode(response.body);
  }

  /*
  * Após retornar Futures contendo as informações de cada personagem, add na lista de chars
  */
  Future<bool> _populateCharactersMap() async {
    var url;
    for (url in widget._charsUrlList) {
      var charInfo = await _getCharacterInfo(url);
      if (charInfo != null) {
        chars.add(charInfo);
      }
    }
    return true;
  }

  /*
  * Cria grid responsável por exibir detalhes sobre os personagens
  */
  _createCharsTable(context, snap) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: GridView.builder(
          padding: EdgeInsets.all(4.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 5.0,
          ),
          itemCount: widget._charsUrlList.length,
          itemBuilder: (context, index) {
            var height = chars[index]['height'];
            if (height != 'unknown') height = (double.parse(height) / 100);
            return Column(
              children: <Widget>[
                Tools.myTextField(chars[index]['name'],
                    color: Colors.yellowAccent),
                Tools.myTextField("Altura: ", data: height.toString() + 'm'),
                Tools.myTextField("Peso: ", data: chars[index]['mass']),
                Tools.myTextField("Cor de pele: ",
                    data: chars[index]['skin_color']),
                Tools.myTextField("Cor do cabelo: ",
                    data: chars[index]['hair_color']),
                Tools.myTextField("Ano de aniversário: ",
                    data: chars[index]['birth_year']),
                Tools.myTextField("Gênero: ", data: chars[index]['gender']),
                //Tools.myTextField("Planeta Natal: ", _producer), ## FAZER REQUEST EM PLANETA ##
              ],
            );
          }),
    );
  }
}
