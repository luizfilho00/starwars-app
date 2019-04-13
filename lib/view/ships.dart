import 'package:flutter/material.dart';
import 'package:star_wars/helpers/page_elements.dart';
import 'package:star_wars/model/logic.dart';

class Ships extends StatefulWidget {
  final List _shipsUrlList;

  Ships(this._shipsUrlList);

  @override
  _ShipsState createState() => _ShipsState();
}

class _ShipsState extends State<Ships> {
  bool _loaded;
  List _shipsList;

  @override
  void initState() {
    super.initState();
    _shipsList = List();
    _populateShipsMap().then((loaded) {
      if (mounted)
        setState(() {
          _loaded = loaded;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    //Enquanto faz as requisições http exibe 'Carregando...'
    if (_loaded == null || _shipsList.length < widget._shipsUrlList.length) {
      return PageElements.scaffoldLoading('Naves');
    }
    //Lista está carregada
    else {
      return PageElements.scaffoldLoaded(context, 'Naves', _createshipsTable);
    }
  }

  /*
  * Após retornar Futures contendo as informações de cada nave, add na lista de naves
  */
  Future<bool> _populateShipsMap() async {
    var url;
    for (url in widget._shipsUrlList) {
      Logic.getData(url).then((map) {
        if (mounted)
          setState(() {
            _shipsList.add(map);
          });
      });
    }
    return true;
  }

  /*
  * Cria grid responsável por exibir detalhes sobre as naves
  */
  _createshipsTable(context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: ListView.builder(
          padding: EdgeInsets.all(4.0),
          itemCount: widget._shipsUrlList.length,
          itemBuilder: (context, index) {
            return Column(
              children: <Widget>[
                PageElements.rowWithTwoTexts(_shipsList[index]['name'],
                    color: Colors.yellowAccent, fontSize: 18.0),
                PageElements.rowWithTwoTexts("Modelo: ",
                    data: _shipsList[index]['model']),
                PageElements.rowWithTwoTexts("Fabricante: ",
                    data: _shipsList[index]['manufacturer']),
                PageElements.rowWithTwoTexts("Valor em créditos: ",
                    data: _shipsList[index]['cost_in_credits']),
                PageElements.rowWithTwoTexts("Comprimento: ",
                    data: _shipsList[index]['length']),
                PageElements.rowWithTwoTexts("Velocidade atmosférica máxima: ",
                    data: _shipsList[index]['max_atmosphering_speed']),
                PageElements.rowWithTwoTexts("Tripulação: ",
                    data: _shipsList[index]['crew']),
                PageElements.rowWithTwoTexts("Passageiros: ",
                    data: _shipsList[index]['passengers']),
                PageElements.rowWithTwoTexts("Capacidade de carga: ",
                    data: _shipsList[index]['cargo_capacity']),
                PageElements.rowWithTwoTexts("Consumíveis: ",
                    data: _shipsList[index]['consumables']),
                PageElements.rowWithTwoTexts("Taxa de hyperdrive: ",
                    data: _shipsList[index]['hyperdrive_rating']),
                PageElements.rowWithTwoTexts("MGLT: ",
                    data: _shipsList[index]['MGLT']),
                PageElements.rowWithTwoTexts("Class da nave: ",
                    data: _shipsList[index]['starship_class']),
                Divider(),
                //PageElements.rowWithTwoTexts("Pilots: ", data: pilots),
                //     data: _shipsList[index]['pilots']),
                // ## FAZER REQUEST EM "PEOPLE"
              ],
            );
          }),
    );
  }
}
