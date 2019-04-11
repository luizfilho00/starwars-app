import 'package:flutter/material.dart';
import 'package:star_wars/ui/character_page.dart';
import 'package:star_wars/ui/species_page.dart';
import 'package:star_wars/ui/tools.dart';

class MoviePage extends StatefulWidget {
  final Map _movieData;

  MoviePage(this._movieData);

  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  String _title, _director, _producer, _releaseDate, _sinopse;
  List _listCharacters,
      _listStarships,
      _listPlanets,
      _listVehicles,
      _listSpecies;

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
    this._listStarships = List.from(widget._movieData["starships"]);
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
          Row(
            children: <Widget>[
              Expanded(
                child: RaisedButton(
                    child: Text('Personagens'),
                    color: Colors.yellow[600],
                    textColor: Colors.black,
                    onPressed: () {
                      _callCharacters(context);
                    }),
              ),
            ],
          ),
          Tools.rowWithTwoBottons(
              context, 'Planetas', 'Espécies', _callPlanets, _callSpecies),
          Tools.rowWithTwoBottons(
              context, 'Naves', 'Veículos', _callShips, _callVehicles),
          Divider(),
          Tools.myTextField("Título Original: ", data: _title),
          Tools.myTextField("Data de lançamento: ", data: _releaseDate),
          Tools.myTextField("Diretor: ", data: _director),
          Tools.myTextField("Produtores: ", data: _producer),
          Divider(),
          Text(
            "Sinopse: ",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.start,
          ),
          Text(
            _sinopse,
            style: TextStyle(
              color: Colors.white,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  /*
  * As funções abaixo são responsáveis por chamar a view de cada tela
  */

  void _callCharacters(context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CharacterPage(_listCharacters)));
  }

  void _callSpecies(context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => SpeciesPage(_listSpecies)));
  }

  void _callVehicles(context) {}

  void _callShips(context) {}

  void _callPlanets(context) {}
}
