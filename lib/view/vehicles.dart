import 'package:flutter/material.dart';
import 'package:star_wars/helpers/page_elements.dart';
import 'package:star_wars/model/logic.dart';

class Vehicles extends StatefulWidget {
  final List _vehiclesUrlList;

  Vehicles(this._vehiclesUrlList);

  @override
  _VehiclesState createState() => _VehiclesState();
}

class _VehiclesState extends State<Vehicles> {
  List _vehiclesList;
  bool _loaded;

  @override
  void initState() {
    _vehiclesList = List();
    super.initState();

    _vehiclesList = List();
    _populateVehiclesMap().then((loaded) {
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
        _vehiclesList.length < widget._vehiclesUrlList.length) {
      return PageElements.scaffoldLoading('Veículos');
    }
    //Lista está carregada
    else {
      return PageElements.scaffoldLoaded(
          context, 'Veículos', _createVehiclesTable);
    }
  }

  /*
  * Após retornar Futures contendo as informações de cada veículo, add na lista de veículos
  */
  Future<bool> _populateVehiclesMap() async {
    var url;
    for (url in widget._vehiclesUrlList) {
      Logic.getData(url).then((map) {
        if (mounted)
          setState(() {
            _vehiclesList.add(map);
          });
      });
    }
    return true;
  }

  /*
  * Cria grid responsável por exibir detalhes sobre os veículos
  */
  _createVehiclesTable(context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: ListView.builder(
          padding: EdgeInsets.all(4.0),
          itemCount: widget._vehiclesUrlList.length,
          itemBuilder: (context, index) {
            return Column(
              children: <Widget>[
                PageElements.rowWithTwoTexts(_vehiclesList[index]['name'],
                    color: Colors.yellowAccent, fontSize: 18.0),
                PageElements.rowWithTwoTexts("Modelo: ",
                    data: _vehiclesList[index]['model']),
                PageElements.rowWithTwoTexts("Fabricante: ",
                    data: _vehiclesList[index]['manufacturer']),
                PageElements.rowWithTwoTexts("Valor em créditos: ",
                    data: _vehiclesList[index]['cost_in_credits']),
                PageElements.rowWithTwoTexts("Comprimento: ",
                    data: _vehiclesList[index]['length']),
                PageElements.rowWithTwoTexts("Velocidade atmosférica máxima: ",
                    data: _vehiclesList[index]['max_atmosphering_speed']),
                PageElements.rowWithTwoTexts("Tripulação: ",
                    data: _vehiclesList[index]['crew']),
                PageElements.rowWithTwoTexts("Passageiros: ",
                    data: _vehiclesList[index]['passengers']),
                PageElements.rowWithTwoTexts("Capacidade de carga: ",
                    data: _vehiclesList[index]['cargo_capacity']),
                PageElements.rowWithTwoTexts("Consumíveis: ",
                    data: _vehiclesList[index]['consumables']),
                PageElements.rowWithTwoTexts("Class do veículo: ",
                    data: _vehiclesList[index]['vehicle_class']),
                Divider(),
                //PageElements.rowWithTwoTexts("Pilots: ", data: pilots),
                //     data: _vehiclesList[index]['pilots']),
                // ## FAZER REQUEST EM "PEOPLE"
              ],
            );
          }),
    );
  }
}
