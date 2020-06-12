import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bar_card_new/AppTheme.dart';
import 'package:bar_card_new/bCards/myBCard.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:bar_card_new/screens/services/Database.dart';
import 'package:provider/provider.dart';
import 'package:bar_card_new/models/User.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geo_firestore/geo_firestore.dart';
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//Class to create the logic and UI for the myCard Tab
class CardTab extends StatefulWidget {
  @override
  _CardTabState createState() => _CardTabState();
}

class _CardTabState extends State<CardTab> with AutomaticKeepAliveClientMixin {
  //Used to keep the tab active even if the user changes tabs
  @override
  bool get wantKeepAlive => true;

  //initialises the currentBGColor to a default of navy blue
  Color currentBGColor = Color(0xff233c67);

  //function to be able to change the value of the currentBGColor
  void changeBGColor(Color color) => setState(() => currentBGColor = color);

  //initialises the currentFontColor to a default of light Grey
  Color currentFontColor = Color(0xfff5f5f5);

  //function to be able to change the value of the currentFontColor
  void changeFontColor(Color color) => setState(() => currentFontColor = color);

  //initialises the public switch value to a default of false
  bool publicSwitchValue = false;

  //function to be able to change the value of the publicSwitchValue
  void changePublicSwitch(bool b) => setState(() => publicSwitchValue = b);

  //initialises the line1Text string value to a default of "Line1"
  String line1Text = "Line1";

  //function to be able to change the value of the line1Text string
  void changeline1Text(String b) => setState(() => line1Text = b);

  //initialises the line2Text string value to a default of "Line2"
  String line2Text = "Line2";

  //function to be able to change the value of the line2Text string
  void changeline2Text(String b) => setState(() => line2Text = b);

  //initialises the currentAddress string value to a default of an empty string
  String currentAddress = '';

  //function to be able to change the value of the currentAddress string
  void changeCurrentAddress(String b) => setState(() => currentAddress = b);

  //The text field controllers for the line1 and line2 input field
  TextEditingController line1 = TextEditingController();
  TextEditingController line2 = TextEditingController();

  //initState always runs before building the widget, so initialization and data retrieval can take place before drawing UI to the screen
  @override
  void initState() {
    super.initState();

    //Gets the data of the current logged in user from firebaseAuth
    FirebaseAuth.instance.currentUser().then((value) {

      //initialises DatabaseService class that takes in the current logged in user's UID
      var db = DatabaseService(uid: value.uid);

      //uses the getUserBColor function in the DatabaseService class to get the cards background color
      //and turns the string into a color object, which gets set to the global variable currentBGColor
      db.getUserBColor().then((value) {
        String valueString = value.split('(0x')[1].split(')')[0];
        int x = int.parse(valueString, radix: 16);
        changeBGColor(Color(x));
      });

      //uses the getUserFColor function in the DatabaseService class to get the cards font color
      //and turns the string into a color object, which gets set to the global variable currentFontColor
      db.getUserFColor().then((value) {
        String valueString = value.split('(0x')[1].split(')')[0];
        int x = int.parse(valueString, radix: 16);
        changeFontColor(Color(x));
      });

      //uses the getUserPublic function in the DatabaseService class to get the cards public status
      //and sets the global variable publicSwitchValue to the corresponding value in the database
      db.getUserPublic().then((value) {
        changePublicSwitch(value);
      });

      //uses the getLine1 function in the DatabaseService class to get the cards line1 string from the database
      //and sets the global variable line1 to the corresponding value in the database
      db.getLine1().then((value) {
        setState(() {
          line1.text = value;
          line1Text = value;
        });

      });

      //uses the getLine2 function in the DatabaseService class to get the cards line2 string from the database
      //and sets the global variable line2 to the corresponding value in the database
      db.getLine2().then((value) {
        setState(() {
          line2.text = value;
          line2Text = value;
        });

      });

      //uses the getLocation function in the DatabaseService class to get the cards location from the database
      //and sets the global variable currentAddress to the corresponding value in the database
      db.getLocation().then((value) {
        if (value == "") {
          changeCurrentAddress("Location not set!");
        } else {
          coordToAddress(value).then((value1) {
            changeCurrentAddress(value1);
          });
        }
      });
    });
  }

  //Function ot turn map coordinates into an address string
  Future coordToAddress(coord) async {
    //uses coordinates to create a Coordinate object
    final coordinates = new Coordinates(coord.latitude, coord.longitude);

    //uses the geocoder package to return a list of the probable addresses using the coordinates
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);

    //Uses the first address in the list which should be the most probable address
    var result = addresses.first;

    //returns the address line in string format
    return "${result.addressLine}";
  }

  //Function to save the location in the database
  Future _saveLocation(uid) async {
    //initialises DatabaseService class that takes in the current logged in user's UID
    DatabaseService data = DatabaseService(uid: uid);

    //Using the geaFirestore package here, and add the users collection as the parameter
    GeoFirestore geoFirestore = GeoFirestore(data.userCollection);

    //Get the current device loaction
    Location location = new Location();
    var pos = await location.getLocation();

    //turns the map coordinates as a GeoPoint object and stores it in the database using geoFirestore
    await geoFirestore.setLocation(uid, GeoPoint(pos.latitude, pos.longitude));
    return pos;
  }

  //function to show a popup dialog to confirm the user wants to make their card public
  Future<void> showPubDial() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, //Dialog cannot be dismissed by pressing outside the dialog, the user must tap a button
      builder: (BuildContext context) {
        //returns a alertDialog which is provided by flutter
        return AlertDialog(
          title: Text("Make Card Public?"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    "This will make your card visible to users in the Card location vicinity!")
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                //if cancel is pressed it closes the dialog
                Navigator.of(context).pop();

                //and changes the switch back to false
                changePublicSwitch(false);
              },
            ),
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                //if ok is pressed it just closes the dialog
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //function to show that an action has successfully happened, takes in a text string to show that message
  void _openCustomDialog(text) {
    showDialog(
        context: context,
        builder: (context) {
          //function to close the dialog automatically after 350 milliseconds
          Future.delayed(Duration(milliseconds: 350), () {
            Navigator.of(context).pop(true);
          });

          //shows a Alert dialog with the parameter as the message
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            title: Column(children: <Widget>[
              Center(child: Text(text)),
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

  //the build function draws the UI to the screen
  @override
  Widget build(BuildContext context) {
    //Provider used here to be able to access the logged in users data
    final user = Provider.of<User>(context);

    super.build(context);

    //Returns a container with all the UI on the screen
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(243, 245, 248, 1),
      ),
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
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
            //Draws the users card on the top of the page
            MyBCard(
              uid: user.uid,
              margin: 25,
              bgColor: currentBGColor,
              fontColor: currentFontColor,
              line1: line1Text,
              line2: line2Text,
            ),
            SizedBox(
              height: 16,
            ),
            Center(
              child: Text(
                "Card Preferences",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: AppTheme.darkText),
              ),
            ),
            SizedBox(
              height: 16,
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

              //Text form field input for the line 1 property of the card
              child: TextFormField(
                onChanged: (String value) async {
                  changeline1Text(value);
                },
                controller: line1,
                inputFormatters: [
                  //limiting the line to only have a maximum of 27 characters so it can fit on the card
                  LengthLimitingTextInputFormatter(27),
                ],
                decoration: InputDecoration(
                  labelText: 'Line 1',
                ),
              ),
            ),
            SizedBox(
              height: 16,
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

              //Text form field input for the line 2 property of the card
              child: TextFormField(
                onChanged: (String value) async {
                  changeline2Text(value);
                },
                controller: line2,
                inputFormatters: [
                  //limiting the line to only have a maximum of 27 characters so it can fit on the card
                  LengthLimitingTextInputFormatter(27),
                ],
                decoration: InputDecoration(
                  labelText: 'Line 2',
                ),
              ),
            ),
            SizedBox(height: 16,),

            //Code for the background color button
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    //When the button is pressed it opens the color picker using the ColorPicker package
                    return AlertDialog(
                      titlePadding: const EdgeInsets.all(0.0),
                      contentPadding: const EdgeInsets.all(0.0),
                      content: SingleChildScrollView(
                        //Returns the colorPicker widget from the Color_Picker package
                        //and initialises all the custom properties
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
              //Container for the styling of the change background color button
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

            //Code for the font color button
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    //When the button is pressed it opens the color picker using the ColorPicker package
                    return AlertDialog(
                      titlePadding: const EdgeInsets.all(0.0),
                      contentPadding: const EdgeInsets.all(0.0),
                      content: SingleChildScrollView(
                        //Returns the colorPicker widget from the Color_Picker package
                        //and initialises all the custom properties
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

              //Container for the styling of the change background color button
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

            //Container containing the UI and logic for the Public switch
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

                  //The switch UI and logic
                  Switch(
                    value: publicSwitchValue,
                    activeColor: Color.fromRGBO(50, 172, 121, 1),
                    onChanged: (_) {
                      //When the switch is changed the PublicSwitch variable is also changed to the corresponding boolean value
                      changePublicSwitch(!publicSwitchValue);

                      //If the switch is switching from false to true then it shows a dialog to confirm
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

            //Here it shows the Cards current location
            Center(
              child: Text(
                "Card Location:  " + currentAddress,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 16,
            ),

            //The UI and logic for the "Set card Location" button
            Center(
              child: ButtonTheme(
                minWidth: 200,
                height: 50,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0)),
                  color: AppTheme.nearlyGreen,
                  onPressed: () {
                    //When the button is pressed it runs the saveLocation function to save the location in the database
                    _saveLocation(user.uid).then((value){

                      //updates the current location address on the screen
                      coordToAddress(value).then((value1){
                        changeCurrentAddress(value1);
                      });
                    });

                    //briefly shows a success dialog on the screen which automatically closes
                    _openCustomDialog("Location Saved!");
                  },
                  child: Text('Set Card Location',
                      style:
                          TextStyle(fontSize: 20, color: AppTheme.whiteText)),
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),

            //The UI and logic for the "Save Preferences" button
            Center(
              child: ButtonTheme(
                minWidth: 200,
                height: 50,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0)),
                  color: AppTheme.nearlyGreen,
                  onPressed: () {
                    //When the button is pressed, all the data gets updated in the database
                    var db = DatabaseService(uid: user.uid);
                    db.setUserPref(
                        currentBGColor.toString(),
                        currentFontColor.toString(),
                        publicSwitchValue,
                        line1.text,
                        line2.text);

                    //briefly shows a success dialog on the screen which automatically closes
                    _openCustomDialog("Preferences Saved!");
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
          ],
        ),
      ),
    );
  }
}
