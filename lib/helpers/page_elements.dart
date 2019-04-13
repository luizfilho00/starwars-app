import 'package:flutter/material.dart';
import 'package:star_wars/model/logic.dart';

/*
 * Classe contendo Widgets personalizados que são utilizados repetidas vezes no código
 */
class PageElements {
  static Widget rowWithTwoTexts(String info,
      {String data = '',
      color = Colors.white,
      TextAlign alignment = TextAlign.left,
      double fontSize = 17.0}) {
    return Padding(
      padding: EdgeInsets.all(3.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              info,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            child: Text(
              data,
              style: TextStyle(color: color, fontSize: fontSize),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  static rowWithTwoBottons(context, txt1, txt2, func1, func2) {
    return Row(
      children: <Widget>[
        Expanded(
          child: RaisedButton(
              child: Text(
                txt1,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
              color: Colors.yellow[600],
              textColor: Colors.black,
              onPressed: () {
                func1(context);
              }),
        ),
        Container(
          margin: const EdgeInsets.only(left: 5.0, right: 5.0),
        ),
        Expanded(
          child: RaisedButton(
              child: Text(
                txt2,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
              color: Colors.yellow[600],
              textColor: Colors.black,
              onPressed: () {
                func2(context);
              }),
        ),
      ],
    );
  }

  static loading() {
    return Center(
      child: Container(
        width: 140.0,
        height: 140.0,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Image(image: AssetImage('lib/assets/loading_storm.gif')),
            ),
            Text(
              'Carregando...',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  static scaffoldLoading(title) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Center(child: loading()),
    );
  }

  static scaffoldLoaded(context, title, createTableFunction) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Expanded(child: createTableFunction(context)),
        ],
      ),
    );
  }

  static String dateFormat(String text) {
    var date = text.split('-');
    return date[2] + '/' + date[1] + '/' + date[0];
  }

  static translatedText(text) {
    return FutureBuilder(
      future: Logic.textToPtBr(text),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Container(
                width: 100.0,
                height: 100.0,
                child: Center(
                    child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 4.0,
                )));
          default:
            if (snapshot.hasError) return Container();
            return Text(
              snapshot.data,
              style: TextStyle(color: Colors.white, fontSize: 16.0),
              textAlign: TextAlign.justify,
            );
        }
      },
    );
  }
}
