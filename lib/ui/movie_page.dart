import 'package:flutter/material.dart';
import 'package:star_wars/ui/character_page.dart';

class MoviePage extends StatefulWidget {
  final Map _movieData;

  MoviePage(this._movieData);

  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  String _title, _director, _producer, _releaseDate, _sinopse;
  List _listCharacters, _listStarships, _listPlanets, _listVehicles;

  @override
  void initState() {
    super.initState();
    this._title = widget._movieData["title"];
    this._director = widget._movieData["director"];
    this._producer = widget._movieData["producer"];
    this._releaseDate = widget._movieData["release_date"];
    this._sinopse = widget._movieData["opening_crawl"].replaceAll("\r\n", " ");
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
      body: Column(
        children: <Widget>[
          SingleChildScrollView(child: _getDetailedList(context)),
        ],
      ),
    );
  }

  _getDetailedList(context) {
    return Column(
      children: <Widget>[
        Image(
          image:
              AssetImage("lib/assets/" + widget._movieData["title"] + ".jpg"),
          width: 200.0,
          height: 300.0,
        ),
        Divider(),
        _rowWithTwoBottons(
            context, 'Personagens', 'Espécies', _callCharacters, _callSpecies),
        _rowWithTwoBottons(
            context, 'Naves', 'Veículos', _callShips, _callVehicles),
        Divider(),
        _textField("Título Original: ", _title),
        _textField("Data de lançamento: ", _releaseDate),
        _textField("Diretor: ", _director),
        _textField("Produtores: ", _producer),
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
        Divider(),
      ],
    );
  }

  void _callCharacters(context) {}

  void _callSpecies(context) {}

  void _callVehicles(context) {}

  void _callShips(context) {}

  _rowWithTwoBottons(context, firstBottomText, secondBottomText,
      _firstBottomFunc, _secondBottomFunc) {
    return Row(
      children: <Widget>[
        Expanded(
          child: RaisedButton(
              child: Text(firstBottomText),
              color: Colors.yellow[600],
              textColor: Colors.black,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CharacterPage(_listCharacters)));
              }),
        ),
        Container(
          margin: const EdgeInsets.only(left: 5.0, right: 5.0),
        ),
        Expanded(
          child: RaisedButton(
              child: Text(secondBottomText),
              color: Colors.yellow[600],
              textColor: Colors.black,
              onPressed: () {}),
        ),
        Container(
          margin: const EdgeInsets.only(left: 5.0, right: 5.0),
        ),
      ],
    );
  }

  _textField(String info, String data) {
    return Padding(
      padding: EdgeInsets.all(3.0),
      child: Row(
        children: <Widget>[
          Text(
            info,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.left,
          ),
          Text(
            data,
            style: TextStyle(
              color: Colors.white,
            ),
            textAlign: TextAlign.left,
            overflow: TextOverflow.clip,
          ),
        ],
      ),
    );
  }
}
