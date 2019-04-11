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
  List speciesList = List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Espécies'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Expanded(
              child: Tools.loadingThenRun(
            context,
            _populateSpeciesMap(),
            'loading_storm.gif',
            _createSpeciesTable,
          )),
        ],
      ),
    );
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
      var speciesInfo = await _getSpeciesInfo(url);
      if (speciesInfo != null) {
        speciesList.add(speciesInfo);
        print(speciesInfo);
      }
    }
    return true;
  }

  /*
  * Cria grid responsável por exibir detalhes sobre os personagens
  */
  _createSpeciesTable(context, snap) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: ListView.builder(
          padding: EdgeInsets.all(4.0),
          itemCount: widget._speciesUrlList.length,
          itemBuilder: (context, index) {
            return Column(
              children: <Widget>[
                Tools.myTextField(speciesList[index]['name'],
                    color: Colors.yellowAccent),
                Tools.myTextField("Classificação: ",
                    data: speciesList[index]['classification']),
                Tools.myTextField("Designação: ",
                    data: speciesList[index]['designation']),
                Tools.myTextField("Altura média: ",
                    data: speciesList[index]['average_height']),
                Tools.myTextField("Cores de pele: ",
                    data: speciesList[index]['skin_colors']),
                Tools.myTextField("Cores de cabelo: ",
                    data: speciesList[index]['hair_colors']),
                Tools.myTextField("Cores dos olhos: ",
                    data: speciesList[index]['eye_colors']),
                Tools.myTextField("Expectativa de vida: ",
                    data: speciesList[index]['average_lifespan']),
                Tools.myTextField("Língua: ",
                    data: speciesList[index]['language']),
                Divider(),
                // Tools.myTextField("Planeta Natal: ",
                //     data: speciesList[index]['gender']), ## FAZER REQUEST EM PLANETA ##
              ],
            );
          }),
    );
  }
}
