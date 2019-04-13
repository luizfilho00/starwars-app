import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:star_wars/model/logic.dart';
import 'package:star_wars/view/movies.dart';
import 'package:star_wars/helpers/page_elements.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search;
  Map _mapMovies;
  final String _urlMovies = 'https://swapi.co/api/films/';
  final String _urlSearch = 'https://swapi.co/api/films/?search=';

  @override
  void initState() {
    super.initState();

    if (_mapMovies == null) {
      Logic.getData(_urlMovies).then((map) {
        if (mounted) {
          setState(() {
            _mapMovies = map;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_mapMovies == null) {
      return _scaffoldLoading(context);
    } else {
      return _scaffoldLoaded(context);
    }
  }

  _scaffoldLoading(context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Image.asset('lib/assets/logo.png'),
          centerTitle: true,
        ),
        backgroundColor: Colors.black,
        body: _loadingView(context));
  }

  _scaffoldLoaded(context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Image.asset('lib/assets/logo.png'),
          centerTitle: true,
        ),
        backgroundColor: Colors.black,
        body: _loadedView(context));
  }

  _searchBar() {
    return Padding(
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
          Logic.getData(_urlSearch + _search).then((map) {
            setState(() {
              _mapMovies = map;
            });
          });
        },
      ),
    );
  }

  _loadingView(context) {
    return Column(
      children: <Widget>[
        _searchBar(),
        Expanded(child: PageElements.loading()),
      ],
    );
  }

  _loadedView(context) {
    return Column(
      children: <Widget>[
        _searchBar(),
        Expanded(child: _createMoviesTable(context)),
      ],
    );
  }

  _createMoviesTable(BuildContext context) {
    var count = _mapMovies["count"];
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
              "lib/assets/" + _mapMovies["results"][index]["title"] + ".jpg";
          return GestureDetector(
              child: Image(
                image: AssetImage(imgPath),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MoviePage(_mapMovies["results"][index])));
              });
        });
  }
}
