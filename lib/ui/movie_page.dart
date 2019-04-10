import 'package:flutter/material.dart';

class MoviePage extends StatelessWidget {
  final Map _movieData;
  String _title, _director, _producer, _releaseDate, _sinopse;

  //Construtor
  MoviePage(this._movieData);

  @override
  Widget build(BuildContext context) {
    this._title = _movieData["title"];
    this._director = _movieData["director"];
    this._producer = _movieData["producer"];
    this._releaseDate = _movieData["release_date"];
    this._sinopse = _movieData["opening_crawl"].replaceAll("\r\n", " ");

    return Scaffold(
      appBar: AppBar(
        title: Text("Star Wars: " + _movieData["title"]),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: SingleChildScrollView(child: _getDetailedList()),
            ),
          ),
        ],
      ),
    );
  }

  /*
   * Builda os itens da lista de detalhes do filme: 
   * img, data de lançamento, diretor, produtor e sinopse
   */
  _getDetailedList() {
    return Column(
      children: <Widget>[
        Image(
          image: AssetImage("lib/assets/" + _movieData["title"] + ".jpg"),
          width: 200.0,
          height: 300.0,
        ),
        Divider(),
        _rowWithTwoBottons('Personagens', 'Espécies'),
        _rowWithTwoBottons('Naves', 'Veículos'),
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

  _rowWithTwoBottons(firstBottomText, secondBottomText) {
    return Row(
      children: <Widget>[
        Expanded(
          child: RaisedButton(
              child: Text(firstBottomText),
              color: Colors.yellow[600],
              textColor: Colors.black,
              onPressed: () {}),
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

  /*
   * Formata os campos de texto de forma adequada
   */
  _textField(String info, String data) {
    print("AQUIIIIIIIIIII" + this._sinopse);
    return Row(
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
        ),
      ],
    );
  }
}
