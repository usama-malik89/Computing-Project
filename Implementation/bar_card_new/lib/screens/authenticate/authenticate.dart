import 'package:flutter/material.dart';
import 'package:bar_card_new/screens/authenticate/SignIn.dart';
import 'package:bar_card_new/screens/authenticate/Register.dart';

//Class to show the register and sign in page and logic for toggling the pages
class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  //Shows the sign in page by default
  bool showSignIn = true;

  //Function to toggle the showSignIn variable
  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  //the build function draws the card on the screen
  @override
  Widget build(BuildContext context) {
    //logic to show signIn page or Register page according to the state of the showSignIn boolean
    //Also passes the toggleView function as a parameter so the screen can be toggled within the child widget
    if (showSignIn) {
      return SignIn(toggleView: toggleView);
    } else {
      return Register(toggleView: toggleView);
    }
  }
}
