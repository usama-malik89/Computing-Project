import 'package:flutter/material.dart';
import 'package:bar_card_new/custom_drawer/DrawerController.dart';
import 'package:bar_card_new/custom_drawer/HomeDrawer.dart';
import 'package:bar_card_new/screens/home/TabController.dart';
import 'package:bar_card_new/AppTheme.dart';

//class used to control which screen is shown from the HomeDrawer navigation system
class NavigationHomeScreen extends StatefulWidget {
  @override
  _NavigationHomeScreenState createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  Widget screenView;
  DrawerIndex drawerIndex;

  @override
  void initState() {
    //the initial screen shown is always the home screen
    drawerIndex = DrawerIndex.HOME;

    //the home screen is shown through the TabScreen class
    screenView = const TabScreen();
    super.initState();
  }

  //the build function draws the card on the screen
  @override
  Widget build(BuildContext context) {
    //Returns a container with a safeArea so flutter can automatically detect a phones notch and avoid drawing any UI that may get blocked by the notch
    return Container(
      color: AppTheme.white,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: AppTheme.white,
          body: DrawerUserController(
            screenIndex: drawerIndex,
            drawerWidth: MediaQuery.of(context).size.width * 0.75,
            onDrawerCall: (DrawerIndex drawerIndexdata) {
              changeIndex(drawerIndexdata);
            },
            screenView: screenView,
          ),
        ),
      ),
    );
  }

  //function to change the index if the screen is changed to a different screen
  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      if (drawerIndex == DrawerIndex.HOME) {
        setState(() {
          screenView = const TabScreen();
        });
      } else if (drawerIndex == DrawerIndex.ACCOUNT) {
        setState(() {
          //screenView = HelpScreen();
        });
      } else if (drawerIndex == DrawerIndex.ABOUT) {
        setState(() {
          //screenView = FeedbackScreen();
        });
      } else {
      }
    }
  }
}
