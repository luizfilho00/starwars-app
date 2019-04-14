import 'package:flutter/material.dart';
import 'package:star_wars/model/logic.dart';
import 'package:star_wars/view/characters.dart';
import 'package:star_wars/view/planets.dart';
import 'package:star_wars/view/ships.dart';
import 'package:star_wars/view/species.dart';
import 'package:star_wars/helpers/page_elements.dart';
import 'package:star_wars/view/vehicles.dart';

class MoviePage extends StatefulWidget {
  final Map _movieData;

  MoviePage(this._movieData);

  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  String _title, _director, _producer, _releaseDate, _sinopse;
  List _listCharacters, _listShips, _listPlanets, _listVehicles, _listSpecies;

  @override
  void initState() {
    super.initState();
    this._title = widget._movieData["title"];
    this._director = widget._movieData["director"];
    this._producer = widget._movieData["producer"];
    this._releaseDate = widget._movieData["release_date"];
    this._sinopse = widget._movieData["opening_crawl"].replaceAll("\r\n", " ");
    this._listSpecies = List.from(widget._movieData["species"]);
    this._listCharacters = List.from(widget._movieData["characters"]);
    this._listShips = List.from(widget._movieData["starships"]);
    this._listPlanets = List.from(widget._movieData["planets"]);
    this._listVehicles = List.from(widget._movieData["vehicles"]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Star Wars: " + widget._movieData["title"]),
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.black,
        body: SingleChildScrollView(child: _getDetailedList(context)));
  }

  ///Cria lista com as informações sobre o filme
  ///Botões, título original, data de lançamento, diretor, produtor, sinopse e tradução da sinopse
  _getDetailedList(context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Image(
            image:
                AssetImage("lib/assets/" + widget._movieData["title"] + ".jpg"),
            width: 200.0,
            height: 300.0,
          ),
          Divider(),
          _characterButton(),
          PageElements.rowWithTwoBottons(
              context, 'Planetas', 'Espécies', _callPlanets, _callSpecies),
          PageElements.rowWithTwoBottons(
              context, 'Naves', 'Veículos', _callShips, _callVehicles),
          Divider(),
          PageElements.rowWithTwoTexts("Título Original: ", data: _title),
          PageElements.rowWithTwoTexts("Data de lançamento: ",
              data: PageElements.dateFormat(_releaseDate)),
          PageElements.rowWithTwoTexts("Diretor: ", data: _director),
          PageElements.rowWithTwoTexts("Produtores: ", data: _producer),
          Divider(),
          _sinopseWidget(),
          Divider(),
          Text(
            "Tradução: ",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
            textAlign: TextAlign.start,
          ),
          Divider(),
          PageElements.translatedText(_sinopse), // Sinopse traduzida
        ],
      ),
    );
  }

  ///Botão grande e esticado para page Personagens
  _characterButton() {
    return Row(
      children: <Widget>[
        Expanded(
          child: RaisedButton(
              child: Text(
                'Personagens',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
              color: Colors.yellow[600],
              onPressed: () {
                _callCharacters(context);
              }),
        ),
      ],
    );
  }

  /// Widget contendo a sinopse original
  _sinopseWidget() {
    return Column(
      children: <Widget>[
        Text(
          "Sinopse: ",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
          textAlign: TextAlign.start,
        ),
        Text(
          _sinopse,
          style: TextStyle(color: Colors.white, fontSize: 16.0),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }

  /*
  * As funções abaixo são responsáveis por chamar a view de cada tela
  */

  void _callCharacters(context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Characters(_listCharacters)));
  }

  void _callSpecies(context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Species(_listSpecies)));
  }

  void _callVehicles(context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Vehicles(_listVehicles)));
  }

  void _callShips(context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Ships(_listShips)));
  }

  void _callPlanets(context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Planets(_listPlanets)));
  }
}
