import 'package:flutter/material.dart';
import 'package:bar_card_new/BCard.dart';
import 'package:location/location.dart';
import 'package:bar_card_new/screens/services/Database.dart';
import 'package:provider/provider.dart';
import 'package:bar_card_new/models/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:geo_firestore/geo_firestore.dart';
import 'package:bar_card_new/AppTheme.dart';

class MapTab extends StatefulWidget {
  @override
  _MapTabState createState() => _MapTabState();
}

class _MapTabState extends State<MapTab> with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;

  int dropdownValue = 2;

  Stream mapQuery(r, uid) async* {
    DatabaseService data = DatabaseService();
    GeoFirestore geoFirestore = GeoFirestore(data.userCollection);

    Location location = new Location();
    var pos = await location.getLocation();

    final queryLocation = GeoPoint(pos.latitude, pos.longitude);
    final List<DocumentSnapshot> documents =
        await geoFirestore.getAtLocation(queryLocation, r * 0.6214);
    List<DocumentSnapshot> filtered = documents.where((doc) {
      return doc.documentID != uid;
    }).toList();
    List<DocumentSnapshot> secondFilter = filtered.where((doc) {
      return doc.data['isPublic'] == true;
    }).toList();
    //documents.remove(uid);
    secondFilter.forEach((document) {
      print(document.data);
    });
    yield secondFilter;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final user = Provider.of<User>(context);
    //_saveLocation(user.uid);

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
                      //mapQuery(dropdownValue);
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
              StreamBuilder(
                  stream: mapQuery(dropdownValue / 0.6214, user.uid),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    List<Widget> s = [];

                    //print(snapshot.toString());
                    if (snapshot.hasData) {
                      //print(snapshot.data);
                      snapshot.data.forEach((document) {
                        //print(document.data);
                        s.add(BCard(
                          uid: document.documentID,
                          margin: 10,
                        ));
                      });
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
                        )),
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
                  }),
            ],
          ),
        ));
  }
}
