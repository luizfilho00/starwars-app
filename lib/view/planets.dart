import 'package:flutter/material.dart';
import 'package:star_wars/helpers/page_elements.dart';
import 'package:star_wars/model/logic.dart';

class Planets extends StatefulWidget {
  final List _planetsUrlList;

  Planets(this._planetsUrlList);

  @override
  _PlanetsState createState() => _PlanetsState();
}

class _PlanetsState extends State<Planets> {
  List _planetsList;
  bool _loaded;

  @override
  void initState() {
    super.initState();

    _planetsList = List();
    _populateplanetsMap().then((loaded) {
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
        _planetsList.length < widget._planetsUrlList.length) {
      return PageElements.scaffoldLoading('Planetas');
    }
    //Lista está carregada
    else {
      return PageElements.scaffoldLoaded(
          context, 'Planetas', _createPlanetsTable);
    }
  }

  /*
  * Após retornar Futures contendo as informações de cada planeta, add na lista de planetas
  */
  Future<bool> _populateplanetsMap() async {
    var url;
    for (url in widget._planetsUrlList) {
      Logic.getData(url).then((map) {
        if (mounted)
          setState(() {
            _planetsList.add(map);
          });
      });
    }
    return true;
  }

  /*
  * Cria grid responsável por exibir detalhes sobre os planetas
  */
  _createPlanetsTable(context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: ListView.builder(
          padding: EdgeInsets.all(4.0),
          itemCount: widget._planetsUrlList.length,
          itemBuilder: (context, index) {
            return Column(
              children: <Widget>[
                PageElements.rowWithTwoTexts(_planetsList[index]['name'],
                    color: Colors.yellowAccent, fontSize: 18.0),
                PageElements.rowWithTwoTexts("Período de Rotação: ",
                    data: _planetsList[index]['rotation_period']),
                PageElements.rowWithTwoTexts("Período orbital: ",
                    data: _planetsList[index]['orbital_period']),
                PageElements.rowWithTwoTexts("diameter: ",
                    data: _planetsList[index]['orbital_period']),
                PageElements.rowWithTwoTexts("Clima: ",
                    data: _planetsList[index]['climate']),
                PageElements.rowWithTwoTexts("Gravidade: ",
                    data: _planetsList[index]['gravity']),
                PageElements.rowWithTwoTexts("Terreno: ",
                    data: _planetsList[index]['terrain']),
                PageElements.rowWithTwoTexts("Superfície de água: ",
                    data: _planetsList[index]['surface_water']),
                PageElements.rowWithTwoTexts("População: ",
                    data: _planetsList[index]['population']),
                Divider(),
                // PageElements.rowWithTwoTexts("População: ",
                //     data: _planetsList[index]['population']),
                // ## FAZER REQUEST EM "PEOPLE"
              ],
            );
          }),
    );
  }
}
