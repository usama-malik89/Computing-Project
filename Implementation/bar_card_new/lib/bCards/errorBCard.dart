import 'package:flutter/material.dart';

//Class for showing a Error Card if an error occurs within card retrieval
class ErrorBCard extends StatefulWidget {
  //margin property to be able to control how much margin should be present
  final double margin;

  //class initializer
  ErrorBCard({
    Key key,
    @required this.margin,
  }) : super(key: key);

  _ErrorBCardState createState() => _ErrorBCardState();
}

class _ErrorBCardState extends State<ErrorBCard> {

  //the build function draws the card on the screen
  @override
  Widget build(BuildContext context) {
    //Returns the error card UI to be shown on the screen
    return Container(
      height: 200,
      margin: EdgeInsets.symmetric(
        horizontal: 32,
        vertical: widget.margin,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Color(0xff233c67),
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
    );
  }
}
