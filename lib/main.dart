import 'package:akawo/mainpage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _horizontal = 30;
  double _vertical = 15;

  @override
  void initState() {
    super.initState();
    _animationFunction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            child: Column(
              children: [
                Text(
                  'MICRO ',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                      fontFamily: "Tourney",
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3),
                ),
                Text(
                  'FINANCE ',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                      fontFamily: "Tourney",
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3),
                ),
                Text(
                  'SAVINGS',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                      fontFamily: "Tourney",
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3),
                ),
              ],
            ),
          ),
          Center(
            child: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(18)),
              child: MaterialButton(
                padding: EdgeInsets.symmetric(
                    horizontal: _horizontal, vertical: _vertical),
                elevation: 15,
                color: Colors.white,
                animationDuration: Duration(milliseconds: 300),
                child: Text('Next'),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MainPage()));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  _animationFunction() {
    setState(() {
      _horizontal += 10;
      _vertical += 5;
      if (_horizontal == 20) {
        _horizontal = 10;
        _vertical = 5;
      }
    });
  }
}
