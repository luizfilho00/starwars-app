import 'package:flutter/material.dart';
import 'package:star_wars/helpers/page_elements.dart';
import 'package:star_wars/model/logic.dart';

class Characters extends StatefulWidget {
  final List _charsUrlList;

  Characters(this._charsUrlList);

  @override
  _CharactersState createState() => _CharactersState();
}

class _CharactersState extends State<Characters> {
  List _charsList;
  bool _loaded;

  @override
  void initState() {
    super.initState();

    _charsList = List();
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
    if (_loaded == null || _charsList.length < widget._charsUrlList.length) {
      return PageElements.scaffoldLoading('Personagens');
    }
    //Lista de personagens está carregada
    else {
      return PageElements.scaffoldLoaded(
          context, 'Personagens', _createCharsTable);
    }
  }

  /*
  * Após retornar Futures contendo as informações de cada personagem, add na lista de chars
  */
  Future<bool> _populateCharactersMap() async {
    var url;
    for (url in widget._charsUrlList) {
      Logic.getData(url).then((map) {
        if (mounted)
          setState(() {
            _charsList.add(map);
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
            var height = _charsList[index]['height'];
            if (height != 'unknown') height = (double.parse(height) / 100);
            return Column(
              children: <Widget>[
                PageElements.rowWithTwoTexts(_charsList[index]['name'],
                    color: Colors.yellowAccent, fontSize: 18.0),
                PageElements.rowWithTwoTexts("Altura: ",
                    data: height.toString() + 'm'),
                PageElements.rowWithTwoTexts("Peso: ",
                    data: _charsList[index]['mass']),
                PageElements.rowWithTwoTexts("Cor de pele: ",
                    data: _charsList[index]['skin_color']),
                PageElements.rowWithTwoTexts("Cor do cabelo: ",
                    data: _charsList[index]['hair_color']),
                PageElements.rowWithTwoTexts("Ano de aniversário: ",
                    data: _charsList[index]['birth_year']),
                PageElements.rowWithTwoTexts("Gênero: ",
                    data: _charsList[index]['gender']),
                Divider(),
              ],
            );
          }),
    );
  }
}
