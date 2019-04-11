import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CharacterPage extends StatelessWidget {
  final List _charsUrlList;
  final String _movieTitle;
  List chars = List();

  /* Construtor recebe List com characters do Filme */
  CharacterPage(this._movieTitle, this._charsUrlList);

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
          Image(
            image: AssetImage("lib/assets/storm_trooper.png"),
            width: 140.0,
            height: 140.0,
          ),
          Divider(),
          Expanded(
            child: FutureBuilder(
              future: _populateCharactersMap(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Center(
                      child: Container(
                        width: 300.0,
                        height: 300.0,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.yellowAccent),
                          strokeWidth: 5.0,
                        ),
                      ),
                    );
                  default:
                    if (snapshot.hasError)
                      return Container();
                    else
                      return _createCharsTable(context);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  /* Request no personagem da 'url' e retorna dados em json */
  Future<Map> _getCharacterInfo(url) async {
    http.Response response;
    response = await http.get(url);
    return json.decode(response.body);
  }

  /*
  * Pega cada informação sobre o personagem e passa para Map _charactersMap
  */
  Future<bool> _populateCharactersMap() async {
    var url;
    for (url in _charsUrlList) {
      var charInfo = await _getCharacterInfo(url);
      if (charInfo != null) {
        chars.add(charInfo);
      }
    }
    return true;
  }

  _textField(String info, {String data = '', color = Colors.white}) {
    return Padding(
      padding: EdgeInsets.all(3.0),
      child: Row(
        children: <Widget>[
          Text(
            info,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.left,
          ),
          Text(
            data,
            style: TextStyle(
              color: color,
            ),
            textAlign: TextAlign.left,
            overflow: TextOverflow.clip,
          ),
        ],
      ),
    );
  }

  _createCharsTable(context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: GridView.builder(
          padding: EdgeInsets.all(4.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 5.0,
          ),
          itemCount: _charsUrlList.length,
          itemBuilder: (context, index) {
            print('ALTURA: ' + chars[index]['height']);
            var height = chars[index]['height'];
            if (height != 'unknown') height = (double.parse(height) / 100);
            return Column(
              children: <Widget>[
                _textField(chars[index]['name'], color: Colors.yellowAccent),
                _textField("Altura: ", data: height.toString() + 'm'),
                _textField("Peso: ", data: chars[index]['mass']),
                _textField("Cor de pele: ", data: chars[index]['skin_color']),
                _textField("Cor do cabelo: ", data: chars[index]['hair_color']),
                _textField("Ano de aniversário: ",
                    data: chars[index]['birth_year']),
                _textField("Gênero: ", data: chars[index]['gender']),
                //_textField("Planeta Natal: ", _producer), ## FAZER REQUEST EM PLANETA ##
              ],
            );
          }),
    );
  }
}
