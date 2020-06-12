import 'package:flutter/material.dart';
import 'package:bar_card_new/bCards/nearbyBCard.dart';
import 'package:location/location.dart';
import 'package:bar_card_new/screens/services/Database.dart';
import 'package:provider/provider.dart';
import 'package:bar_card_new/models/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:geo_firestore/geo_firestore.dart';
import 'package:bar_card_new/AppTheme.dart';

//Class to create the logic and UI for the Nearby Tab
class MapTab extends StatefulWidget {
  @override
  _MapTabState createState() => _MapTabState();
}

class _MapTabState extends State<MapTab> with AutomaticKeepAliveClientMixin {
  //Used to keep the tab active even if the user changes tabs
  @override
  bool get wantKeepAlive => true;

  //The value for the dropdown menu, for the map radius
  int dropdownValue = 2;

  DatabaseService data = DatabaseService();

  //function to query the database for the cards within the specified radius
  Stream mapQuery(radius, uid) async* {
    //Initialises GeoFirestore package with the userCollection being taken in as a parameter
    GeoFirestore geoFirestore = GeoFirestore(data.userCollection);

    //Initialises location package
    Location location = new Location();

    //getting devices location
    var pos = await location.getLocation();

    //Using the devices coordinates to set the center of the query location
    final queryLocation = GeoPoint(pos.latitude, pos.longitude);

    //gets all the cards within the radius and adds to the list
    final List<DocumentSnapshot> documents =
        //uses getAtLocation method with the devices location being the center,
        //and input radius to query all the cards in the database within this radius
        await geoFirestore.getAtLocation(queryLocation, radius * 0.6214);
    //filters the list to make sure the users own card doesn't get shown
    List<DocumentSnapshot> filtered = documents.where((doc) {
      return doc.documentID != uid;
    }).toList();
    //filters the list again to make sure cards that aren't public don't get shown
    List<DocumentSnapshot> secondFilter = filtered.where((doc) {
      return doc.data['isPublic'] == true;
    }).toList();

    //returns list with the cards
    yield secondFilter;
  }

  //the build function draws the UI to the screen
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final user = Provider.of<User>(context);

    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(243, 245, 248, 1),
      ),
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Show Cards ",
                  style: TextStyle(fontSize: 20),
                ),
                DropdownButton<int>(
                  value: dropdownValue,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  elevation: 16,
                  underline: Container(
                    height: 2,
                    color: AppTheme.nearlyBlue,
                  ),
                  onChanged: (int newValue) {
                    setState(() {
                      dropdownValue = newValue;
                    });
                  },
                  items: [
                    DropdownMenuItem<int>(
                      child: Text(
                        'Within 2 Miles',
                        style: TextStyle(fontSize: 20),
                      ),
                      value: 2,
                    ),
                    DropdownMenuItem<int>(
                      child: Text(
                        'Within 5 Miles',
                        style: TextStyle(fontSize: 20),
                      ),
                      value: 5,
                    ),
                    DropdownMenuItem<int>(
                      child: Text(
                        'Within 10 Miles',
                        style: TextStyle(fontSize: 20),
                      ),
                      value: 10,
                    ),
                    DropdownMenuItem<int>(
                      child: Text(
                        'Within 25 Miles',
                        style: TextStyle(fontSize: 20),
                      ),
                      value: 25,
                    ),
                    DropdownMenuItem<int>(
                      child: Text(
                        'Nationwide',
                        style: TextStyle(fontSize: 20),
                      ),
                      value: 2500,
                    ),
                  ],
                ),
              ],
            ),

            //uses the StreamBuilder function which Flutter provides to be able to access the data in the userData list
            StreamBuilder(
              stream: mapQuery(dropdownValue / 0.6214, user.uid),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                List<Widget> s = [];

                //if the snapshot has returned some data, the card gets made with the necessary data from the userData list
                if (snapshot.hasData) {
                  if (snapshot.data.length == 0) {
                    s.add(
                      SizedBox(
                        height: 50,
                      ),
                    );
                    s.add(Text("No Nearby Cards Found!"));
                  }
                  snapshot.data.forEach(
                    (document) {
                      s.add(
                        NearbyBCard(
                          uid: document.documentID,
                          margin: 10,
                          myUID: user.uid,
                        ),
                      );
                    },
                  );

                  //if the snapshot has an error, an error message gets shown
                } else if (snapshot.hasError) {
                  s = [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Icon(
                      Icons.error_outline,
                      color: AppTheme.veryRed,
                      size: 60,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Error Loading Cards!",
                      style: TextStyle(
                          fontSize: 20,
                          color: AppTheme.black,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2.0),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Please make sure location permission is granted!",
                    ),
                  ];
                }

                //if the snapshot data is still loading, the loading animation gets shown
                if (snapshot.connectionState == ConnectionState.waiting) {
                  s = [
                    SizedBox(
                      height: 50,
                    ),
                    Center(
                      child: Text(
                        "Loading",
                        style: TextStyle(
                            fontSize: 20,
                            color: AppTheme.darkText,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2.0),
                      ),
                    ),
                    SizedBox(height: 30),
                    Center(
                      child: SizedBox(
                        child: CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(
                              AppTheme.nearlyBlue),
                        ),
                        width: 60,
                        height: 60,
                      ),
                    ),
                  ];
                }

                return Column(children: s);
              },
            ),
          ],
        ),
      ),
    );
  }
}
