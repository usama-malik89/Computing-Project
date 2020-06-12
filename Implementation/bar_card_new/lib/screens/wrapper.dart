import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bar_card_new/models/User.dart';
import 'package:bar_card_new/screens/GettingStarted.dart';
import 'package:bar_card_new/NavigationDrawer.dart';

//Class to handle the authentication check
class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    //return homescreen if a user is logged in, otherwise show the welcome screen where login will required
    if (user == null) {
      return WelcomeScreen();
    } else {
      return NavigationHomeScreen();
    }
  }
}

