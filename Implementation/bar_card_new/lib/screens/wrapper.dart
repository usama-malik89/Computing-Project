import 'package:flutter/material.dart';
import 'package:bar_card_new/screens/home/TabController.dart';
import 'package:bar_card_new/screens/authenticate/Authenticate.dart';
import 'package:provider/provider.dart';
import 'package:bar_card_new/models/User.dart';
import 'package:bar_card_new/screens/GettingStarted.dart';
import 'package:bar_card_new/NavigationDrawer.dart';
import 'package:bar_card_new/screens/services/Auth.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    //return home or authenticate
    if (user == null) {
      return WelcomeScreen();
    } else {
      return NavigationHomeScreen();
    }

  }
}
