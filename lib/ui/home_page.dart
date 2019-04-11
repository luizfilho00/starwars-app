import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:star_wars/ui/movie_page.dart';
import 'package:star_wars/ui/tools.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search;
  Map _mapResponse;

  _getMovies() async {
    http.Response response;
    if (_search == null)
      response = await http.get("https://swapi.co/api/films/");
    else {
      response =
          await http.get("https://swapi.co/api/films/?search=" + _search);
    }
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();

    if (_mapResponse == null)
      _getMovies().then((map) {
        _mapResponse = map;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.asset('lib/assets/logo.png'),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                  labelText: "Pesquisar filme:",
                  labelStyle: TextStyle(color: Colors.yellowAccent),
                  border: OutlineInputBorder()),
              style: TextStyle(color: Colors.yellowAccent, fontSize: 18.0),
              textAlign: TextAlign.center,
              onChanged: (text) {
                setState(() {
                  _search = text;
                });
              },
            ),
          ),
          Expanded(
            child: Tools.loadingThenRun(
                context, _getMovies(), 'loading_vader.gif', _createMovieTable),
          ),
        ],
      ),
    );
  }

  _createMovieTable(BuildContext context, AsyncSnapshot snapshot) {
    var count = snapshot.data["count"];
    return GridView.builder(
        padding: EdgeInsets.all(5.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 5.0,
        ),
        itemCount: count,
        itemBuilder: (context, index) {
          var imgPath =
              "lib/assets/" + snapshot.data["results"][index]["title"] + ".jpg";
          return GestureDetector(
              child: Image(
                image: AssetImage(imgPath),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MoviePage(snapshot.data["results"][index])));
              });
        });
  }
}
