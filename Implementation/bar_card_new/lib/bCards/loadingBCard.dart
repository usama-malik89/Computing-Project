import 'package:flutter/material.dart';

//Class for showing a loading Card if data retrieval from the database is still happening
class LoadingBCard extends StatefulWidget {
  //margin property to be able to control how much margin should be present
  final double margin;

  //class initializer
  LoadingBCard({
    Key key,
    @required this.margin,
  }) : super(key: key);
  _LoadingBCardState createState() => _LoadingBCardState();
}

class _LoadingBCardState extends State<LoadingBCard> {

  //the build function draws the card on the screen
  @override
  Widget build(BuildContext context) {
    //Returns the loading card UI to be shown on the screen
    return Container(
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
        ));
  }
}
