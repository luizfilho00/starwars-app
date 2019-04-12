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
  bool _loaded;

  @override
  void initState() {
    super.initState();
    _populateCharactersMap().then((loaded) {
      if (mounted)
        setState(() {
          _loaded = loaded;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    //Enquanto faz as requisições http exibe 'Carregando...'
    if (_loaded == null || chars.length < widget._charsUrlList.length) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Personagens'),
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.black,
        body: Center(
          child: Container(
            width: 140.0,
            height: 140.0,
            child: Column(
              children: <Widget>[
                Expanded(
                  child:
                      Image(image: AssetImage('lib/assets/loading_storm.gif')),
                ),
                Text(
                  'Carregando...',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      );
    }
    //Lista de personagens está carregada
    else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Personagens'),
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.black,
        body: Column(
          children: <Widget>[
            Expanded(child: _createCharsTable(context)),
          ],
        ),
      );
    }
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
      _getCharacterInfo(url).then((map) {
        if (mounted)
          setState(() {
            chars.add(map);
          });
      });
    }
    return true;
  }

  /*
  * Cria grid responsável por exibir detalhes sobre os personagens
  */
  _createCharsTable(context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: ListView.builder(
          padding: EdgeInsets.all(4.0),
          itemCount: widget._charsUrlList.length,
          itemBuilder: (context, index) {
            var height = chars[index]['height'];
            if (height != 'unknown') height = (double.parse(height) / 100);
            return Column(
              children: <Widget>[
                myTextField(chars[index]['name'],
                    color: Colors.yellowAccent, fontSize: 18.0),
                myTextField("Altura: ", data: height.toString() + 'm'),
                myTextField("Peso: ", data: chars[index]['mass']),
                myTextField("Cor de pele: ", data: chars[index]['skin_color']),
                myTextField("Cor do cabelo: ",
                    data: chars[index]['hair_color']),
                myTextField("Ano de aniversário: ",
                    data: chars[index]['birth_year']),
                myTextField("Gênero: ", data: chars[index]['gender']),
                Divider(),
              ],
            );
          }),
    );
  }

  myTextField(String info,
      {String data = '',
      color = Colors.white,
      TextAlign alignment = TextAlign.left,
      double fontSize = 17.0}) {
    return Padding(
      padding: EdgeInsets.all(3.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              info,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            child: Text(
              data,
              style: TextStyle(color: color, fontSize: fontSize),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}
