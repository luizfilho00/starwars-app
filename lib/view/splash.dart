import 'package:flutter/material.dart';
import 'package:star_wars/view/home.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3)).then((_) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Image(
            image: AssetImage('lib/assets/logo.png'),
            width: 150.0,
            height: 150.0,
          ),
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
