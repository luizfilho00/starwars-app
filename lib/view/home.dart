import 'package:flutter/material.dart';
import 'package:star_wars/model/logic.dart';
import 'package:star_wars/view/movies.dart';
import 'package:star_wars/helpers/page_elements.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search = '';
  final String _urlMovies = 'https://swapi.co/api/films/';
  final String _urlSearch = 'https://swapi.co/api/films/?search=';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _scaffoldHome(context);
  }

  /// Faz uma requisição http para obter um JSON contendo os filmes
  /// Se o usuário está buscando um filme exibe loading
  /// Se o usuário não está buscando exibe a lista de filmes
  /// Se a busca do usuário retornou um resultado exibe o filme encontrado
  Future<Map> _getMovies() async {
    var url;
    if (_search.isEmpty)
      url = _urlMovies;
    else
      url = _urlSearch + _search;
    return Logic.getData(url);
  }

  /// Cria um Scaffold com a barra de pesquisa e alterna entre as telas de carregamento e exibição
  _scaffoldHome(context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.asset('lib/assets/logo.png'),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder(
          future: _getMovies(),
          builder: (context, snap) {
            switch (snap.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return _loadingView(context);
              default:
                if (snap.hasError || snap.data == null)
                  return Expanded(
                    child: Center(
                      child: Text(
                          'Servidor indisponível no momento, tente novamente mais tarde.'),
                    ),
                  );
                return _loadedView(context, snap.data);
            }
          }),
    );
  }

  /// Widget barra de pesquisa
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
          if (mounted)
            setState(() {
              _search = text;
            });
        },
      ),
    );
  }

  /// View contendo a barra de pesquisa e o widget de loading
  _loadingView(context) {
    return Column(
      children: <Widget>[
        _searchBar(),
        Expanded(child: PageElements.loading(txt: 'Buscando filmes...')),
      ],
    );
  }

  /// View contendo a barra de pesquisa e os filmes retornados pela api
  _loadedView(context, snap) {
    return Column(
      children: <Widget>[
        _searchBar(),
        Expanded(child: _createMoviesTable(context, snap)),
      ],
    );
  }

  /// Retorna um widget contendo o grid de filmes encontrados pela api
  /// Ou um Text dizendo que não foram encontrados filmes no servidor
  _createMoviesTable(context, _mapMovies) {
    var count = _mapMovies["count"];
    if (count == 0)
      return PageElements.notFoundWidget(
          'Infelizmente não encontramos esse filme :(');
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
