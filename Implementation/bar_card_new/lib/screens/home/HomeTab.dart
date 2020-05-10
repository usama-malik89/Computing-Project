import 'package:flutter/material.dart';
import 'package:bar_card_new/BCard.dart';
import 'package:provider/provider.dart';
import 'package:bar_card_new/models/User.dart';
import 'package:bar_card_new/screens/services/BarcodeScanner.dart';
import 'package:bar_card_new/AppTheme.dart';
import 'package:bar_card_new/screens/services/Database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:progress_button/progress_button.dart';
import 'package:flutter/cupertino.dart';


import 'package:firebase_auth/firebase_auth.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Stream myStream;
  var bState = ButtonState.normal;

  void refresh(myUID) {
    setState(() {
      myStream = recentQuery(myUID); //refresh the// stream here
    });
}
  void _showDialog(value, myUID) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            children: <Widget>[
              Icon(
                Icons.drag_handle,
                size: 35,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Scan Result',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              BCard(
                uid: value,
                margin: 1,
                isMine: true,
              ),
              RaisedButton(
                textColor: AppTheme.white,
                color: AppTheme.nearlyBlue,
                child: Text("Scan QR CODE"),
                onPressed: () {
                  BarcodeScanner test = BarcodeScanner();
                  test.open().then((value) {
                    Navigator.pop(context);
                    _showDialog(value, myUID);
                  });
                },
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                ),
              ),
            ],
          );
        });
    refresh(myUID);
  }

  Future<void> showCamDial() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Camera Permission'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Camera Permission was denied"),
                SizedBox(
                  height: 2,
                ),
                Text("Cannot open QR Scanner!"),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('Grant Permission'),
              onPressed: () {
                BarcodeScanner bar = BarcodeScanner();
                bar.askCamPermission();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future saveToHistory(String myUID, scanUID) async {
    DatabaseService dat = DatabaseService(uid: myUID);
    dat.updateCardHistory(scanUID);
  }

  Stream recentQuery(uid) async* {
    DatabaseService data = DatabaseService(uid: uid);

    final dynamic documents = await data.getRecent();
    yield documents;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final user = Provider.of<User>(context);

    return Container(
      color: AppTheme.notWhite,
      //height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          //Text('Testing'),

          SliverList(
              delegate: SliverChildListDelegate([
            Column(children: <Widget>[
              SizedBox(
                height: 15,
              ),
              BCard(uid: user.uid, margin: 5, isMine: true,),
              SizedBox(height: 20,),
              CupertinoButton(
                color: AppTheme.nearlyBlue,
                child: Text("Scan A QR", style: TextStyle(color: AppTheme.nearlyWhite, fontSize: 18, fontWeight: FontWeight.w500),),
                onPressed: () async {
                  BarcodeScanner bar = BarcodeScanner();
                  bar.checkCamPermission().then((value) {
                    if (value == true) {
                      bar.open().then((value) {
                        saveToHistory(user.uid, value);
                        recentQuery(user.uid);
                        _showDialog(value, user.uid);
                      });
                    } else {
                      showCamDial();
                    }
                  });
                },
              ),
              SizedBox(
                height: 14,
              ),
            ])
          ])),
          SliverStickyHeader(
            header: Container(
              height: 60,
              color: AppTheme.notWhite,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Recent Cards",
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 24,
                        color: Colors.black),
                  ),
                ],
              ),
              //padding: EdgeInsets.symmetric(horizontal: 32),
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                //SizedBox(height: 50,),
                StreamBuilder(
                    stream: recentQuery(user.uid),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      List<Widget> s = [];
                      if (snapshot.hasData) {
                        if(snapshot.data.documents.length == 0){
                          s.add(SizedBox(height: 50,));
                          s.add(Text("Recently scanned cards will be shown here!"));
                          s.add(Text("Start scanning cards to add them here"));
                        }
                        snapshot.data.documents.forEach((document) {
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
                      return Column(
                        children: s,
                      );
                    }),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
