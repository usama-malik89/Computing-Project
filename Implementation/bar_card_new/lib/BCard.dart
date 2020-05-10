import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:bar_card_new/screens/services/Database.dart';
import 'package:url_launcher/url_launcher.dart';

class BCard extends StatefulWidget {
  String uid;
  double margin;
  bool isMine;

  var bgColor;
  var fontColor;
  var name = "";

  BCard({
    Key key,
    @required this.uid,
    @required this.margin,
    this.isMine,
    this.bgColor,
    this.fontColor,
  }) : super(key: key);

  _BCardState createState() => _BCardState();
}

class _BCardState extends State<BCard> {
  Future<List<String>> _userData;
  bool publicStatus;

  @override
  void initState() {
    _userData = userData(widget.uid); // only create the future once.
    checkPublic().then((value) {
      publicStatus = value;
    });
    super.initState();
  }

  getUid() {
    return widget.uid;
  }

  Future checkPublic() async {
    var db = DatabaseService(uid: widget.uid).userCollection;
    var user = await db.document(widget.uid).get();
    bool status = user["isPublic"];
    if (status == true) {
      return true;
    }

    return false;
  }

  stringToColor(String col) {
    String valueString = col.split('(0x')[1].split(')')[0];
    //print(valueString);
    int value = int.parse(valueString, radix: 16);
    //print(Color(value).toString());
    return Color(value);
  }

  bgcolorCheck(colorC) {
    if (widget.bgColor == null) {
      if (colorC == null) {
        colorC = Color(0xff233c67);
        //print("No color");
      } else if (colorC is String) {
        colorC = stringToColor(colorC);
      }
    } else {
      colorC = widget.bgColor;
    }
    return colorC;
  }

  fontcolorCheck(colorC) {
    if (widget.fontColor == null) {
      if (colorC == null) {
        colorC = Colors.grey[100];
        //print("No color");
      } else if (colorC is String) {
        colorC = stringToColor(colorC);
      }
    } else {
      colorC = widget.fontColor;
    }
    return colorC;
  }

  Future<List<String>> userData(uid) async {
    var db = DatabaseService(uid: uid).userCollection;
    var user = await db.document(uid).get();

    String name = user['firstName'] + " " + user['surname'];
    String email = user['email'];
    String bColor = user['bColor'];
    String fColor = user['fColor'];
    //print(email);
    List<String> dataList = new List(4);
    dataList[0] = name;
    dataList[1] = email;
    dataList[2] = bColor;
    dataList[3] = fColor;
    setState(() {});
    return dataList;
  }

  sendEmail(email) async {
    var url = "mailto:" + email + "?subject=BarCard Contact&body=";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  cardBack(bgColor, fColor, email) {
    if (widget.isMine == null) {
      if (publicStatus == true) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                QrImage(
                  data: widget.uid,
                  backgroundColor: Colors.white,
                  version: QrVersions.auto,
                  size: 100.0,
                  gapless: true,
                ),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  textColor: bgColor,
                  color: fColor,
                  child: Text("Send E-Mail"),
                  onPressed: () {
                    sendEmail(email);
                  },
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                ),
              ],
            ),



          ],
        );
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  textColor: bgColor,
                  color: fColor,
                  child: Text("Send E-Mail"),
                  onPressed: () {

                  },
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                ),
              ],
            ),
          ],
        );
      }
    } else {
      return Column(
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
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _userData,
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        dynamic children;

        if (snapshot.hasData) {
          children = FlipCard(
            direction: FlipDirection.HORIZONTAL,
            front: Container(
                height: 200,
                margin: EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: widget.margin,
                ),
                decoration: BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: bgcolorCheck(snapshot.data[2]).withOpacity(0.6),
                        offset: const Offset(1.1, 4.0),
                        blurRadius: 8.0),
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: bgcolorCheck(snapshot.data[2]),
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[],
                    ),
                    SizedBox(height: 10),
                    Text(
                      snapshot.data[0],
                      style: TextStyle(
                          fontSize: 20,
                          color: fontcolorCheck(snapshot.data[3]),
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2.0),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      snapshot.data[1],
                      style: TextStyle(
                          fontSize: 16,
                          color: fontcolorCheck(snapshot.data[3]),
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2.0),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "[LINE 1]",
                      style: TextStyle(
                          fontSize: 16,
                          color: fontcolorCheck(snapshot.data[3]),
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2.0),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "[LINE 2]",
                      style: TextStyle(
                          fontSize: 16,
                          color: fontcolorCheck(snapshot.data[3]),
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2.0),
                    ),
                  ],
                )),
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
              child: cardBack(bgcolorCheck(snapshot.data[2]), fontcolorCheck(snapshot.data[3]), snapshot.data[1]),
            ),
          );
        } else if (snapshot.hasError) {
          children = FlipCard(
            direction: FlipDirection.HORIZONTAL,
            front: Container(
              height: 200,
              margin: EdgeInsets.symmetric(
                horizontal: 32,
                vertical: widget.margin,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: bgcolorCheck(widget.bgColor),
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[],
                  ),
                  SizedBox(
                    height: 10,
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
                    "Error Loading Card!",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.0),
                  ),
                ],
              ),
            ),
            back: Container(
              height: 200,
              margin: EdgeInsets.symmetric(
                horizontal: 32,
                vertical: widget.margin,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: bgcolorCheck(widget.bgColor),
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[],
                  ),
                  SizedBox(
                    height: 10,
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
                    "Error Loading Card!",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.0),
                  ),
                ],
              ),
            ),
          );
        } else {
          children = FlipCard(
              direction: FlipDirection.HORIZONTAL,
              front: Container(
                  height: 200,
                  margin: EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: widget.margin,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.grey,
                  ),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[],
                      ),
                      SizedBox(height: 10),
                      Center(
                          child: Text(
                        "Loading",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
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
                    ],
                  )),
              back: null);
        }

        return children;
      },
    );
  }
}
