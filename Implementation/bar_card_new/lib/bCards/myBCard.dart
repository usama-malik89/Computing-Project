import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:bar_card_new/screens/services/Database.dart';
import 'package:bar_card_new/bCards/frontBCard.dart';
import 'package:bar_card_new/bCards/errorBCard.dart';
import 'package:bar_card_new/bCards/loadingBCard.dart';

//Class for showing a variation of the Card in the MyCard section of the app
class MyBCard extends StatefulWidget {
  //all necessary variables that are taken in as parameters
  final String uid;
  final double margin;
  final String myUID;

  final bgColor;
  final fontColor;
  final name = "";
  final line1;
  final line2;

  //also takes in a function as a parameter to be able to trigger an action from the parent class
  final void Function(String value) parentAction;

  //class initializer
  MyBCard(
      {Key key,
      @required this.uid,
      @required this.margin,
      this.bgColor,
      this.fontColor,
      this.parentAction,
      this.myUID,
      this.line1,
      this.line2})
      : super(key: key);

  _MyBCardState createState() => _MyBCardState();
}

class _MyBCardState extends State<MyBCard> {
  //Future variable to store the userdata retrieved from database
  Future<List<String>> _userData;

  //initState always runs before building the widget, so initialization and data retrieval can take place before drawing UI to the screen
  @override
  void initState() {
    //sets the _userData variable as the result returned from the userData() function which gets the
    _userData = userData(widget.uid);
    super.initState();
  }

  //function which turns a string hex value into a Color object
  stringToColor(String col) {
    //Splits the string so just the hex value can be extracted
    String valueString = col.split('(0x')[1].split(')')[0];

    //uses the valueString which is a hex and turns it into a integer value which can be used in the Color object
    int value = int.parse(valueString, radix: 16);

    //returns the Color object with the correct color
    return Color(value);
  }

  //function to check if a background color property is present, if it isn't it shows a default color of navy blue
  bgcolorCheck(colorC) {
    if (widget.bgColor != null) {
      colorC = widget.bgColor;
    } else {
      colorC = stringToColor(colorC);
    }
    return colorC;
  }

  //function to check if a font color property is present, if it isn't it shows a default color of light grey
  fontcolorCheck(colorC) {
    if (widget.fontColor != null) {
      colorC = widget.fontColor;
    } else {
      colorC = stringToColor(colorC);
    }
    return colorC;
  }

  //function that gets the necessary user data from the database and returns it as a list
  Future<List<String>> userData(uid) async {
    //initialises DatabaseService class that takes in the cards UID
    var db = DatabaseService(uid: uid).userCollection;

    //gets the record with the specified UID from the database
    var user = await db.document(uid).get();

    //gets all the necessary data fields from the user record in the database
    String name = user['firstName'] + " " + user['surname'];
    String email = user['email'];
    String bColor = user['bColor'];
    String fColor = user['fColor'];
    String l1 = user['line1'];
    String l2 = user['line2'];

    //creating a new list and adds all the data retrieved from the database
    List<String> dataList = new List(6);
    dataList[0] = name;
    dataList[1] = email;
    dataList[2] = bColor;
    dataList[3] = fColor;
    dataList[4] = l1;
    dataList[5] = l2;

    //needed this to update the list, for some reason without this line it wouldn't work
    setState(() {});

    //returns the list with the necessary user info
    return dataList;
  }

  //the build function draws the card on the screen
  @override
  Widget build(BuildContext context) {
    //uses the futureBuilder function which Flutter provides to be able to access the data in the userData list
    return FutureBuilder<List<String>>(
      future: _userData,
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        dynamic children;

        //if the snapshot has returned some data, the card gets made with the necessary data from the userData list
        if (snapshot.hasData) {
          children = FlipCard(
              direction: FlipDirection.HORIZONTAL,
              front: FrontBCard(
                margin: widget.margin,
                name: snapshot.data[0],
                email: snapshot.data[1],
                bgColor: bgcolorCheck(snapshot.data[2]),
                fColor: fontcolorCheck(snapshot.data[3]),
                line1: widget.line1 != null ? widget.line1 : snapshot.data[4],
                line2: widget.line2 != null ? widget.line2 : snapshot.data[5],
              ),
              back: Container(
                  height: 200,
                  margin: EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: widget.margin,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: bgcolorCheck(snapshot.data[2]),
                  ),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          QrImage(
                            data: widget.uid,
                            backgroundColor: Colors.white,
                            version: QrVersions.auto,
                            size: 150.0,
                            gapless: true,
                          ),
                        ],
                      ),
                    ],
                  )));

          //if the snapshot has an error, the error card gets shown
        } else if (snapshot.hasError) {
          children = ErrorBCard(
            margin: widget.margin,
          );
        } else {
          //if the snapshot data is still loading, the loading card gets shown
          children = LoadingBCard(
            margin: widget.margin,
          );
        }

        return children;
      },
    );
  }
}
