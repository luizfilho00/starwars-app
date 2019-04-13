import 'package:flutter/material.dart';
import 'package:star_wars/helpers/page_elements.dart';
import 'package:star_wars/model/logic.dart';

class Species extends StatefulWidget {
  final List _speciesUrlList;

  Species(this._speciesUrlList);

  @override
  _SpeciesState createState() => _SpeciesState();
}

class _SpeciesState extends State<Species> {
  List _speciesList;
  bool _loaded;

  @override
  void initState() {
    super.initState();

    _speciesList = List();
    _populateSpeciesMap().then((loaded) {
      if (mounted)
        setState(() {
          _loaded = loaded;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    //Enquanto faz as requisições http exibe 'Carregando...'
    if (_loaded == null ||
        _speciesList.length < widget._speciesUrlList.length) {
      return PageElements.scaffoldLoading('Espécies');
    }
    //Lista está carregada
    else {
      return PageElements.scaffoldLoaded(
          context, 'Espécies', _createSpeciesTable);
    }
  }

  /*
  * Após retornar Futures contendo as informações de cada espécie, add na lista de espécies
  */
  Future<bool> _populateSpeciesMap() async {
    var url;
    for (url in widget._speciesUrlList) {
      Logic.getData(url).then((map) {
        if (mounted)
          setState(() {
            _speciesList.add(map);
          });
      });
    }
    return true;
  }

  /*
  * Cria grid responsável por exibir detalhes sobre as espécies
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
                PageElements.rowWithTwoTexts(_speciesList[index]['name'],
                    color: Colors.yellowAccent, fontSize: 18.0),
                PageElements.rowWithTwoTexts("Classificação: ",
                    data: _speciesList[index]['classification']),
                PageElements.rowWithTwoTexts("Designação: ",
                    data: _speciesList[index]['designation']),
                PageElements.rowWithTwoTexts("Altura média: ", data: height),
                PageElements.rowWithTwoTexts("Cores de pele: ",
                    data: _speciesList[index]['skin_colors']),
                PageElements.rowWithTwoTexts("Cores de cabelo: ",
                    data: _speciesList[index]['hair_colors']),
                PageElements.rowWithTwoTexts("Cores dos olhos: ",
                    data: _speciesList[index]['eye_colors']),
                PageElements.rowWithTwoTexts("Expectativa de vida: ",
                    data: _speciesList[index]['average_lifespan'] + ' years'),
                PageElements.rowWithTwoTexts("Língua: ",
                    data: _speciesList[index]['language']),
                Divider(),
                // myTextField("Planeta Natal: ",
                //     data: _speciesList[index]['gender']), ## FAZER REQUEST EM PLANETA ##
              ],
            );
          }),
    );
  }
}
