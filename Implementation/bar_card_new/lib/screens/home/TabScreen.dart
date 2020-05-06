import 'package:flutter/material.dart';
import 'package:bar_card_new/screens/home/CardTab.dart';
import 'package:bar_card_new/screens/home/HomeTab.dart';
import 'package:bar_card_new/screens/home/MapTab.dart';
import 'package:bar_card_new/screens/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:bar_card_new/models/user.dart';
import 'package:bar_card_new/screens/services/database.dart';


class TabScreen extends StatefulWidget {
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

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    //var userDat = DatabaseService(uid: user.uid).getUserName();

    DatabaseService(uid: user.uid).getUserName().then((value) {
      setState(() {
        userName = value;
        email = user.email;
      });
    });

    return Scaffold(
      backgroundColor: Color.fromRGBO(38, 81, 158, 1),
      appBar: AppBar(title: Text('BarCard'), centerTitle: true),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(userName),
              accountEmail: Text(email),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.orange,
                child: Text(
                  '${userName[0]}',
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Home"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text("Sign Out"),
              onTap: () async {
                await _auth.signOut();
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
