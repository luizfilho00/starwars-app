import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:star_wars/ui/tools.dart';

class SpeciesPage extends StatefulWidget {
  final List _speciesUrlList;

  SpeciesPage(this._speciesUrlList);

  @override
  _SpeciesPageState createState() => _SpeciesPageState();
}

class _SpeciesPageState extends State<SpeciesPage> {
  List _speciesList = List();
  bool _loaded;

  @override
  void initState() {
    super.initState();
    _populateSpeciesMap().then((loaded) {
      if (mounted)
        setState(() {
          _loaded = loaded;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loaded == null ||
        _speciesList.length < widget._speciesUrlList.length) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Espécies'),
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
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Espécies'),
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.black,
        body: Column(
          children: <Widget>[
            Expanded(child: _createSpeciesTable(context)),
          ],
        ),
      );
    }
  }

  /*
  * Envia requisição http e retorna resposta como json
  */
  Future<Map> _getSpeciesInfo(url) async {
    http.Response response;
    response = await http.get(url);
    return json.decode(response.body);
  }

  /*
  * Após retornar Futures contendo as informações de cada personagem, add na lista de chars
  */
  Future<bool> _populateSpeciesMap() async {
    var url;
    for (url in widget._speciesUrlList) {
      _getSpeciesInfo(url).then((map) {
        if (mounted)
          setState(() {
            _speciesList.add(map);
          });
      });
    }
    return true;
  }

  /*
  * Cria grid responsável por exibir detalhes sobre os personagens
  */
  _createSpeciesTable(context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: ListView.builder(
          padding: EdgeInsets.all(4.0),
          itemCount: widget._speciesUrlList.length,
          itemBuilder: (context, index) {
            var height = _speciesList[index]['average_height'];
            if (height != 'n/a' && height != 'unknown') {
              height =
                  double.parse(_speciesList[index]['average_height']) / 100;
              height = height.toString() + 'm';
            }

            return Column(
              children: <Widget>[
                myTextField(_speciesList[index]['name'],
                    color: Colors.yellowAccent, fontSize: 18.0),
                myTextField("Classificação: ",
                    data: _speciesList[index]['classification']),
                myTextField("Designação: ",
                    data: _speciesList[index]['designation']),
                myTextField("Altura média: ", data: height),
                myTextField("Cores de pele: ",
                    data: _speciesList[index]['skin_colors']),
                myTextField("Cores de cabelo: ",
                    data: _speciesList[index]['hair_colors']),
                myTextField("Cores dos olhos: ",
                    data: _speciesList[index]['eye_colors']),
                myTextField("Expectativa de vida: ",
                    data: _speciesList[index]['average_lifespan'] + ' years'),
                myTextField("Língua: ", data: _speciesList[index]['language']),
                Divider(),
                // myTextField("Planeta Natal: ",
                //     data: _speciesList[index]['gender']), ## FAZER REQUEST EM PLANETA ##
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
