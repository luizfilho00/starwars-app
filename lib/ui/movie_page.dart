import 'package:flutter/material.dart';

class MoviePage extends StatelessWidget {
  final Map _movieData;

  //Construtor
  MoviePage(this._movieData);

  @override
  Widget build(BuildContext context) {
    final _title = _movieData["title"];
    final _director = _movieData["director"];
    final _producer = _movieData["producer"];
    final _releaseDate = _movieData["release_date"];
    var tmpSinopse = _movieData["opening_crawl"];
    final _sinopse = tmpSinopse.replaceAll("\r\n", " ");
    return Scaffold(
      appBar: AppBar(
        title: Text("Star Wars: " + _movieData["title"]),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Column(
            children: <Widget>[
              Image(
                image: AssetImage("lib/assets/" + _movieData["title"] + ".jpg"),
                width: 200.0,
                height: 300.0,
              ),
              Divider(),
              _textField("Título Original: ", _title),
              _textField("Data de lançamento: ", _releaseDate),
              _textField("Diretor: ", _director),
              _textField("Produtores: ", _producer),
              Divider(),
              Text(
                "Sinópse: ",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
              Flexible(
                child: Text(
                  _sinopse,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _textField(String info, String data) {
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
