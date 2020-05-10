import 'package:flutter/material.dart';
import 'package:bar_card_new/AppTheme.dart';
import 'package:bar_card_new/BCard.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:bar_card_new/screens/services/Database.dart';
import 'package:provider/provider.dart';
import 'package:bar_card_new/models/User.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geo_firestore/geo_firestore.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CardTab extends StatefulWidget {
  @override
  _CardTabState createState() => _CardTabState();
}

class _CardTabState extends State<CardTab> with AutomaticKeepAliveClientMixin {
  Color currentBGColor = Color(0xff233c67);

  void changeBGColor(Color color) => setState(() => currentBGColor = color);

  Color currentFontColor = Color(0xfff5f5f5);

  void changeFontColor(Color color) => setState(() => currentFontColor = color);

  bool publicSwitchValue = false;

  void changePublicSwitch(bool b) => setState(() => publicSwitchValue = b);

  @override
  void initState() {
    super.initState();
    //String uid;
    FirebaseAuth.instance.currentUser().then((value) {
      //uid = value.uid;

      var db = DatabaseService(uid: value.uid);

      db.getUserBColor().then((value) {
        String valueString = value.split('(0x')[1].split(')')[0];
        //print(valueString);
        int x = int.parse(valueString, radix: 16);
        //print(Color(value).toString());
        changeBGColor(Color(x));
      });

      db.getUserFColor().then((value) {
        String valueString = value.split('(0x')[1].split(')')[0];
        //print(valueString);
        int x = int.parse(valueString, radix: 16);
        //print(Color(value).toString());
        changeFontColor(Color(x));
      });

      db.getUserPublic().then((value) {
        changePublicSwitch(value);
      });
    });

    // print(uid);
  }

  Future<void> showPubDial() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              "Do you want to make your card public and set your current location as the cards location?"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    "This will make your card visible to users in your vicinity!")
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
                changePublicSwitch(false);
              },
            ),
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
              Center(child: Text('Preferences Saved!')),
              SizedBox(
                height: 20,
              ),
              Center(
                  child: Icon(Icons.check_circle,
                      color: AppTheme.nearlyGreen, size: 50.0)),
            ]),
          );
        });
  }

  Future _saveLocation(uid) async {
    DatabaseService data = DatabaseService(uid: uid);
    GeoFirestore geoFirestore = GeoFirestore(data.userCollection);
    Location location = new Location();
    var pos = await location.getLocation();
    //GeoFirePoint point = geo.point(latitude: pos.latitude, longitude: pos.longitude);
    await geoFirestore.setLocation(uid, GeoPoint(pos.latitude, pos.longitude));
    //return data.updateLocation(point.data);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    super.build(context);
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(243, 245, 248, 1),
      ),
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        //controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 24,
            ),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "My Card",
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 24,
                        color: AppTheme.darkText),
                  ),
                ],
              ),
            ),
            BCard(
              uid: user.uid,
              margin: 25,
              bgColor: currentBGColor,
              fontColor: currentFontColor,
            ),
            SizedBox(
              height: 16,
            ),
            Center(
              child: Text(
                "Card Style",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: AppTheme.darkText),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      titlePadding: const EdgeInsets.all(0.0),
                      contentPadding: const EdgeInsets.all(0.0),
                      content: SingleChildScrollView(
                        child: ColorPicker(
                          pickerColor: currentBGColor,
                          onColorChanged: changeBGColor,
                          colorPickerWidth: 300.0,
                          pickerAreaHeightPercent: 0.7,
                          enableAlpha: false,
                          displayThumbColor: true,
                          showLabel: true,
                          paletteType: PaletteType.hsv,
                          pickerAreaBorderRadius: const BorderRadius.only(
                            topLeft: const Radius.circular(2.0),
                            topRight: const Radius.circular(2.0),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              child: Container(
                decoration: BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                          color: AppTheme.black.withOpacity(0.1),
                          offset: const Offset(1.1, 4.0),
                          blurRadius: 8.0)
                    ]),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                margin: EdgeInsets.symmetric(horizontal: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.format_paint,
                          color: AppTheme.darkBlue,
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Text(
                          "Change Background Color",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: AppTheme.lightText),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    CircleAvatar(
                      backgroundColor: currentBGColor,
                      radius: 15,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      titlePadding: const EdgeInsets.all(0.0),
                      contentPadding: const EdgeInsets.all(0.0),
                      content: SingleChildScrollView(
                        child: ColorPicker(
                          pickerColor: currentFontColor,
                          onColorChanged: changeFontColor,
                          colorPickerWidth: 300.0,
                          pickerAreaHeightPercent: 0.7,
                          enableAlpha: false,
                          displayThumbColor: true,
                          showLabel: true,
                          paletteType: PaletteType.hsv,
                          pickerAreaBorderRadius: const BorderRadius.only(
                            topLeft: const Radius.circular(2.0),
                            topRight: const Radius.circular(2.0),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              child: Container(
                decoration: BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                          color: AppTheme.black.withOpacity(0.1),
                          offset: const Offset(1.1, 4.0),
                          blurRadius: 8.0)
                    ]),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                margin: EdgeInsets.symmetric(horizontal: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.text_fields,
                          color: AppTheme.darkBlue,
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Text(
                          "Change Font Color",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: AppTheme.lightText),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    CircleAvatar(
                      backgroundColor: currentFontColor,
                      radius: 15,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                        color: AppTheme.black.withOpacity(0.1),
                        offset: const Offset(1.1, 4.0),
                        blurRadius: 8.0)
                  ]),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              margin: EdgeInsets.symmetric(horizontal: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.credit_card,
                        color: AppTheme.darkBlue,
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Text(
                        "Make Card Public?",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: AppTheme.lightText),
                      )
                    ],
                  ),
                  Switch(
                    value: publicSwitchValue,
                    activeColor: Color.fromRGBO(50, 172, 121, 1),
                    onChanged: (_) {
                      changePublicSwitch(!publicSwitchValue);
                      if (publicSwitchValue) {
                        showPubDial();
                      }
                    },
                  )
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Center(
              child: ButtonTheme(
                minWidth: 200,
                height: 50,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0)),
                  color: AppTheme.nearlyGreen,
                  onPressed: () {
                    var db = DatabaseService(uid: user.uid);
                    db.setUserPref(currentBGColor.toString(),
                        currentFontColor.toString(), publicSwitchValue);
                    if (publicSwitchValue) {
                      _saveLocation(user.uid);
                    }
                    _openCustomDialog();
                  },
                  child: Text('Save Preferences',
                      style:
                          TextStyle(fontSize: 20, color: AppTheme.whiteText)),
                ),
              ),
            ),
            SizedBox(
              height: 100,
            ),
            SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }
}
