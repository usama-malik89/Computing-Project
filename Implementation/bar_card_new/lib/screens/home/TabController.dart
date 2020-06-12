import 'package:flutter/material.dart';
import 'package:bar_card_new/screens/home/CardTab.dart';
import 'package:bar_card_new/screens/home/HomeTab.dart';
import 'package:bar_card_new/screens/home/NearbyTab.dart';
import 'package:bar_card_new/screens/home/FavouriteTab.dart';
import 'package:provider/provider.dart';
import 'package:bar_card_new/models/User.dart';
import 'package:bar_card_new/screens/services/Database.dart';
import 'package:bar_card_new/AppTheme.dart';

//Class to create the logic and UI for the bottom tab navigation
class TabScreen extends StatefulWidget {
  const TabScreen({Key key}) : super(key: key);

  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {

  //list of each screen in the tabs
  var screens = [
    HomeTab(),
    CardTab(),
    FavouriteTab(),
    MapTab(),
  ];

  //index for the initial screen
  int selectedTab = 0;

  //function to handle when tab changes take place, when a different tab is pressed
  void changeTab(int index) {
    setState(() {
      selectedTab = index;
    });
  }

  //the build function draws the UI to the screen
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color.fromRGBO(38, 81, 158, 1),
      appBar: AppBar(
          backgroundColor: AppTheme.appBarBG,
          title: Text(
            'BarCard',
            style: TextStyle(color: AppTheme.appBarText),
          ),
          centerTitle: true),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppTheme.tabBG,
        unselectedItemColor: AppTheme.tabUnselected,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w700),
        selectedItemColor: AppTheme.tabSelected,
        currentIndex: selectedTab,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Home")),
          BottomNavigationBarItem(
              icon: Icon(Icons.credit_card), title: Text("Card")),
          BottomNavigationBarItem(
              icon: Icon(Icons.star_border), title: Text("Favourite")),
          BottomNavigationBarItem(icon: Icon(Icons.map), title: Text("Nearby")),
        ],
        onTap: (index) {
          setState(() {
            selectedTab = index;
          });
        },
        showUnselectedLabels: true,
        iconSize: 30,
      ),

      //returns the body with the correct screen
      body: screens[selectedTab],
    );
  }
}
