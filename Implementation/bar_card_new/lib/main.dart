import 'package:flutter/material.dart';
import 'screens/Wrapper.dart';
import 'package:bar_card_new/screens/services/Auth.dart';
import 'package:provider/provider.dart';
import 'package:bar_card_new/models/User.dart';
import 'package:bar_card_new/screens/SplashScreen.dart';

void main() => runApp(MyApp());

// This class is the root of your application and runs first
class MyApp extends StatelessWidget {
  @override

  //the build function draws the card on the screen
  Widget build(BuildContext context) {
    //Returns the function StreamProvider which is provided by flutter
    //Allows the logged in user object to be accessed globally anywhere in the app
    return StreamProvider<User>.value(
    value: AuthService().user,
    child: MaterialApp( //Material App widget is needed to have access to basic navigation systems
        debugShowCheckedModeBanner: false, //needs to be false otherwise a red banner gets shown in the corner of the app when testing
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        //sets the home property to the splash screen widget, meaning when the app is first opened the splash screen gets shown
        home: SplashScreen(navigateTo: Wrapper(),), //then it navigates to the wrapper class
      ),
    );
  }
}
