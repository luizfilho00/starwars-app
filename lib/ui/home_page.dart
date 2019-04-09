import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<Map> _getMovies() async {
    http.Response response;
    response = await http.get("https://swapi.co/api/films/");
    return json.decode(response.body);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getMovies().then((map) {
      print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
