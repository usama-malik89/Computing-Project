import 'package:flutter/material.dart';
import 'package:bar_card_new/b_card.dart';
import 'package:provider/provider.dart';
import 'package:bar_card_new/models/user.dart';
import 'package:bar_card_new/screens/services/barcode_scanner.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  void _showDialog(value) {
    showModalBottomSheet(context: context, builder: (context){
      return Column(
        children: <Widget>[
          Icon(
            Icons.drag_handle,
            size: 35,
          ),
          SizedBox(height: 10,),
          Text(
            'Scan Result',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          SizedBox(height: 40,),
          BCard(uid: value,margin: 1,),
          RaisedButton(
            textColor: Colors.white,
            color: Colors.lightBlue,
            child: Text("Scan QR CODE"),
            onPressed: () {
              BarcodeScanner test = BarcodeScanner();
              test.open().then((value) {
                Navigator.pop(context);
                _showDialog(value);
              });
            },
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0),
            ),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final user = Provider.of<User>(context);

    return Container(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          //Container for top data

          Column(
            children: <Widget>[
              SizedBox(height: 15,),
              BCard(uid: user.uid, margin: 5),
              //SizedBox(height: 10),
              RaisedButton(
                textColor: Colors.white,
                color: Colors.lightBlue,
                child: Text("Scan QR CODE"),
                onPressed: () {
                  BarcodeScanner test = BarcodeScanner();
                  test.open().then((value) {
                    _showDialog(value);
                  });
                },
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                ),
              ),
            ],
          ),

          //draggable sheet
          DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                    color: Color.fromRGBO(243, 245, 248, 1),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40))),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 24,
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Recent Cards",
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 24,
                                  color: Colors.black),
                            ),
                            Text(
                              "See all",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: Colors.grey[800]),
                            )
                          ],
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 32),
                      ),
                      //SizedBox(height: 24,),

                      ListView.builder(
                        itemBuilder: (context, index) {
                          return BCard(
                            uid: user.uid,
                            margin: 5,
                          );
                        },
                        shrinkWrap: true,
                        itemCount: 5,
                        padding: EdgeInsets.all(0),
                        controller: ScrollController(keepScrollOffset: false),
                      ),
                    ],
                  ),
                  controller: scrollController,
                ),
              );
            },
            initialChildSize: 0.45,
            minChildSize: 0.45,
            maxChildSize: 1,
          )
        ],
      ),
    );
  }
}
