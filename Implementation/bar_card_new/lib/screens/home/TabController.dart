import 'package:flutter/material.dart';
import 'package:bar_card_new/screens/home/CardTab.dart';
import 'package:bar_card_new/screens/home/HomeTab.dart';
import 'package:bar_card_new/screens/home/NearbyTab.dart';
import 'package:provider/provider.dart';
import 'package:bar_card_new/models/User.dart';
import 'package:bar_card_new/screens/services/Database.dart';
import 'package:bar_card_new/AppTheme.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({Key key}) : super(key: key);

  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  var screens = [
    HomeTab(),
    CardTab(),
    MapTab(),
  ]; //screens for each tab

  int selectedTab = 0;
  String userName = "Name";
  String email = "Email";

  void changeTab(int index) {
    setState(() {
      selectedTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    DatabaseService(uid: user.uid).getUserName().then((value) {
      setState(() {
        userName = value;
        email = user.email;
      });
    });

    return Scaffold(
      backgroundColor: Color.fromRGBO(38, 81, 158, 1),
      appBar: AppBar(
          backgroundColor: AppTheme.white,
          title: Text(
            'BarCard',
            style: TextStyle(color: AppTheme.darkText),
          ),
          centerTitle: true),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppTheme.notWhite,
        unselectedItemColor: AppTheme.nearlyBlack,
        currentIndex: selectedTab,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Home")),
          BottomNavigationBarItem(
              icon: Icon(Icons.credit_card), title: Text("Card")),
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
      body: screens[selectedTab],
    );
  }
}
