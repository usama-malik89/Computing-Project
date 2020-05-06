import 'package:flutter/material.dart';
import 'package:bar_card_new/screens/home/TabScreen.dart';
import 'package:bar_card_new/screens/authenticate/authenticate.dart';
import 'package:provider/provider.dart';
import 'package:bar_card_new/models/user.dart';
import 'package:bar_card_new/screens/getting_started.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    //print(user);
    //return home or authenticate
    if(user == null){
      return WelcomeScreen();
    }
    else {
      return TabScreen();
    }
  //return Authenticate();
  }
}
