import 'package:flutter/material.dart';
import 'package:bar_card_new/bCards/myBCard.dart';
import 'package:bar_card_new/bCards/recentBCard.dart';
import 'package:provider/provider.dart';
import 'package:bar_card_new/models/User.dart';
import 'package:bar_card_new/screens/services/BarcodeScanner.dart';
import 'package:bar_card_new/AppTheme.dart';
import 'package:bar_card_new/screens/services/Database.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:progress_button/progress_button.dart';
import 'package:flutter/cupertino.dart';

//Class to create the logic and UI for the Home Tab
class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with AutomaticKeepAliveClientMixin {

  //Used to keep the tab active even if the user changes tabs
  @override
  bool get wantKeepAlive => true;

  //A stream is used to get a live stream of the database
  Stream myStream;

  //Using the progress button here for the "Scan a QR" button
  //however the state is always set to normal
  var bState = ButtonState.normal;

  //Function used to refresh the card list whenever a card is deleted from the recent section
  refresh(myUID) {
    setState(() {
      myStream = recentQuery(myUID); //refresh the stream here
    });
  }

  //To show the bottomModalSheet for when a QR code is scanned
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
              MyBCard(
                uid: value,
                margin: 1,
              ),
              //Another scan button in case the user wants to scan another QR code again
              RaisedButton(
                textColor: AppTheme.white,
                color: AppTheme.nearlyBlue,
                child: Text("Scan QR CODE"),
                onPressed: () {
                  //When the button is pressed it closes the current dialog and shows the new dialog after a QR code is scanned
                  BarcodeScanner test = BarcodeScanner();
                  test.openQRScanner().then((value) {
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
    //updates the recent history so the newly scanned card is shown on there
    refresh(myUID);
  }

  //Function to show the camera permission dialog
  Future<void> showCamDial() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Dialog cannot be dismissed by pressing outside the dialog, the user must tap a button
      builder: (BuildContext context) {
        //returns a alertDialog which is provided by flutter
        return AlertDialog(
          title: Text('Camera Permission'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[ //list that contains the two action buttons
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
                //if close is pressed it closes the dialog
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('Grant Permission'),
              onPressed: () {
                //if this button is pressed the OS's camera permission dialog will be shown again
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

  //function to save the scanned card to the history collection in the database
  Future saveToHistory(String myUID, scanUID) async {
    DatabaseService dat = DatabaseService(uid: myUID);
    dat.updateCardHistory(scanUID);
  }

  //function to query the database for getting the recently scanned cards in the cardHistory collection
  Stream recentQuery(uid) async* {
    DatabaseService data = DatabaseService(uid: uid);

    final dynamic documents = await data.getRecent();
    yield documents;
  }

  //the build function draws the UI to the screen
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
              MyBCard(
                uid: user.uid,
                margin: 5,
              ),
              SizedBox(
                height: 20,
              ),
              CupertinoButton(
                color: AppTheme.nearlyBlue,
                child: Text(
                  "Scan A QR",
                  style: TextStyle(
                      color: AppTheme.nearlyWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
                onPressed: () async {
                  BarcodeScanner bar = BarcodeScanner();
                  bar.checkCamPermission().then((value) {
                    if (value == true) {
                      bar.openQRScanner().then((value) {
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
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                //uses the StreamBuilder function which Flutter provides to be able to access the data in the userData list
                StreamBuilder(
                    stream: recentQuery(user.uid),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      List<Widget> s = [];

                      //if the snapshot has returned some data, the card gets made with the necessary data from the userData list
                      if (snapshot.hasData) {
                        if (snapshot.data.documents.length == 0) {
                          s.add(SizedBox(
                            height: 50,
                          ));
                          s.add(Text(
                              "Recently scanned cards will be shown here!"));
                          s.add(Text("Start scanning cards to add them here"));
                        }
                        snapshot.data.documents.forEach((document) {
                          s.add(RecentBCard(
                            uid: document.documentID,
                            margin: 10,
                            parentAction: refresh,
                            myUID: user.uid,
                          ));
                        });

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
