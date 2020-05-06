import 'package:flutter/material.dart';
import 'package:bar_card_new/b_card.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:bar_card_new/screens/services/database.dart';
import 'package:provider/provider.dart';
import 'package:bar_card_new/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:geo_firestore/geo_firestore.dart';




class MapTab extends StatefulWidget {
  @override
  _MapTabState createState() => _MapTabState();
}

class _MapTabState extends State<MapTab>
    with AutomaticKeepAliveClientMixin {

  bool get wantKeepAlive => true;

  int dropdownValue = 2;

  Future<void> showDial(lat, long) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Your Location!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Lat: " + lat.toString()),
                Text("Long: " + long.toString()),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Show in Map'),
              onPressed: () {
                openMap(lat, long);
              },
            ),
          ],
        );
      },
    );
  }

  showSnackbar(text){
    final snackBar = SnackBar(
        content: Text(text),
        duration: Duration(days: 1),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {
            Scaffold.of(context).hideCurrentSnackBar();
          },
        ),
    );

// Find the Scaffold in the widget tree and use it to show a SnackBar.
    Scaffold.of(context).showSnackBar(snackBar);
  }


  _mapTest() async {
    Location location = new Location();

    var pos = await location.getLocation();

    //showSnackbar('Lat: ' + pos.latitude.toString() + ", Long: " + pos.longitude.toString());
    showDial(pos.latitude, pos.longitude);
  }

  Future<void> openMap(double latitude, double longitude) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

//  Future _saveLocation(uid) async {
//    Geoflutterfire geo = Geoflutterfire();
//    Location location = new Location();
//
//    var pos = await location.getLocation();
//    GeoFirePoint point = geo.point(latitude: pos.latitude, longitude: pos.longitude);
//    DatabaseService data = DatabaseService(uid: uid);
//    return data.updateLocation(point.data);
//  }

  Future getLat() async {
    Location location = new Location();

    var pos = await location.getLocation();
    return pos.latitude;
  }

  Future getLong() async {
    Location location = new Location();

    var pos = await location.getLocation();
    return pos.longitude;
  }

  void _openCustomDialog() {
    showDialog(
        context: context,
        builder: (context) {
          Future.delayed(Duration(milliseconds: 350), () {
            Navigator.of(context).pop(true);
          });
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            title: Column(children: <Widget>[
              Center(child: Text('Style Saved!')),
              SizedBox(
                height: 20,
              ),
              Center(
                  child: Icon(Icons.check_circle,
                      color: Colors.green, size: 50.0)),
            ]),
          );
        });
  }

  Stream mapQuery(r) async* {
    DatabaseService data = DatabaseService();
    GeoFirestore geoFirestore = GeoFirestore(data.userCollection);

    Location location = new Location();
    var pos = await location.getLocation();

    final queryLocation = GeoPoint(pos.latitude, pos.longitude);
    //List<Widget> s = [];
// creates a new query around [37.7832, -122.4056] with a radius of 0.6 kilometers
    final List<DocumentSnapshot> documents = await geoFirestore.getAtLocation(queryLocation, r*0.6214);
    documents.forEach((document) {
      print(document.data);
    });
    yield documents;
  }

//  Future <List<Widget>> _startQuery() async {
//    // Get users location
//    DatabaseService data = DatabaseService();
//    Geoflutterfire geo = Geoflutterfire();
//    Location location = new Location();
//
//    var pos = await location.getLocation();
//    double lat = pos.latitude;
//    double lng = pos.longitude;
//
//
//    // Make a referece to firestore
//    var ref = data.userCollection;
//    GeoFirePoint center = geo.point(latitude: lat, longitude: lng);
//
//    List<Widget> s = [];
//
//    Stream<List<DocumentSnapshot>> stream = geo.collection(collectionRef: ref).within(
//        center: center,
//        radius: 200,
//        field: 'location',
//        strictMode: true
//    );
//
//    stream.listen((List<DocumentSnapshot> documentList) {
//      documentList.forEach((f){
//        if(f.data['isPublic'] == true){
//          s.add(BCard(uid: f.documentID, margin: 10));
//        }
//      });
//    });
//
//    return s;
//  }

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
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
              Text("Show Cards within: ", style: TextStyle(fontSize: 20),),
              DropdownButton<int>(

                value: dropdownValue,
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(
                    color: Colors.deepPurple
                ),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (int newValue) {
                  setState(() {
                    dropdownValue = newValue;
                  });
                  //mapQuery(dropdownValue);
                },
                items: <int>[2, 5, 10, 25]
                    .map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString(), style: TextStyle(fontSize: 20),),
                  );
                })
                    .toList(),
              ),
              Text(" Miles", style: TextStyle(fontSize: 20),),

              ],),

            StreamBuilder(
                stream: mapQuery(dropdownValue/0.6214),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  List<Widget> s = [];
                  //print(snapshot.toString());
                  if(snapshot.hasData){
                    //print(snapshot.data);
                    snapshot.data.forEach((document) {
                      print(document.data);
                      if(user.uid != document.documentID){
                        if(document.data['isPublic']){
                          s.add(BCard(uid: document.documentID, margin: 10,));
                        }
                      }
                    });
                  } else if(snapshot.hasError){
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
                        color: Colors.red,
                        size: 60,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Error Loading Cards!",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2.0),
                      ),
                    ];
                  }
                  else{
                    s = [
                      SizedBox(height: 50,),
                      Center(
                          child: Text(
                            "Loading",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 2.0),
                          )),
                      SizedBox(height: 30),
                      Center(
                        child: SizedBox(
                          child: CircularProgressIndicator(),
                          width: 60,
                          height: 60,
                        ),
                      ),
                    ];
                  }
                  return Column(
                    children: s);
                }
            ),
          ],
        ),
      )
    );

  }
}
