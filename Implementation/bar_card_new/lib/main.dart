import 'package:flutter/material.dart';
import 'screens/Wrapper.dart';
import 'package:bar_card_new/screens/services/Auth.dart';
import 'package:provider/provider.dart';
import 'package:bar_card_new/models/User.dart';
import 'package:bar_card_new/screens/SplashScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
    value: AuthService().user,
    child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen(navigateAfterSeconds: Wrapper(),),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
