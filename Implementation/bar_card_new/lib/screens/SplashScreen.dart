import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:bar_card_new/AppTheme.dart';

//Class to create the logic and UI for the SplashScreen
class SplashScreen extends StatefulWidget {

  //variable to specify where to navigate to after
  final dynamic navigateTo;

  SplashScreen({
    this.navigateTo,
  });

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  //initState always runs before building the widget, so initialization and data retrieval can take place before drawing UI to the screen
  //in this case it is used to specify how long the splashscreen should be shown
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 4),
        () => Navigator.of(context).pushReplacement(new MaterialPageRoute(
            builder: (BuildContext context) => widget.navigateTo)));
  }

  //the build function draws the UI to the screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Container(
            decoration: new BoxDecoration(
              color: AppTheme.nearlyBlue,
            ),
          ),
          new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Expanded(
                flex: 2,
                child: new Container(
                    child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: new Container(
                        child: Image.asset('assets/appIcon2.png', width: 250.0),
                      ),
                      radius: 100.0,
                    ),
                    new Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                    ),
                    Text(
                      'BarCard',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 40.0,
                          color: AppTheme.nearlyWhite),
                    )
                  ],
                )),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SpinKitFadingCube(
                      color: AppTheme.nearlyWhite,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
