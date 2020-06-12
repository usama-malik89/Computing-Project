import 'package:flutter/material.dart';

//Class for creating the front of the card which can be used in all variations of the cards, because the front is always the same
class FrontBCard extends StatefulWidget {
  //all necessary variables that are taken in as parameters
  final double margin;
  final Color bgColor;
  final Color fColor;
  final String name;
  final String email;
  final String line1;
  final String line2;

  //class initializer
  FrontBCard({
    Key key,
    @required this.margin,
    @required this.bgColor,
    @required this.fColor,
    @required this.name,
    @required this.email,
    this.line1,
    this.line2,
  }) : super(key: key);

  _FrontBCardState createState() => _FrontBCardState();
}

class _FrontBCardState extends State<FrontBCard> {
  //the build function draws the card on the screen
  @override
  Widget build(BuildContext context) {
    //returns the front of the card using the parameters entered through this class
    return Container(
      height: 200,
      margin: EdgeInsets.symmetric(
        horizontal: 32,
        vertical: widget.margin,
      ),
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: widget.bgColor,
              offset: const Offset(1.1, 4.0),
              blurRadius: 8.0),
        ],
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: widget.bgColor,
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
            widget.name,
            style: TextStyle(
                fontSize: 20,
                color: widget.fColor,
                fontWeight: FontWeight.w700,
                letterSpacing: 2.0),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            widget.email,
            style: TextStyle(
                fontSize: 16,
                color: widget.fColor,
                fontWeight: FontWeight.w700,
                letterSpacing: 2.0),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            widget.line1,
            style: TextStyle(
                fontSize: 13,
                color: widget.fColor,
                fontWeight: FontWeight.w700,
                letterSpacing: 2.0),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            widget.line2,
            style: TextStyle(
                fontSize: 13,
                color: widget.fColor,
                fontWeight: FontWeight.w700,
                letterSpacing: 2.0),
          ),
        ],
      ),
    );
  }
}
