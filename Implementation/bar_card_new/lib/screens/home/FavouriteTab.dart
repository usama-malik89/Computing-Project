import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bar_card_new/models/User.dart';
import 'package:bar_card_new/screens/services/Database.dart';
import 'package:bar_card_new/AppTheme.dart';
import 'package:bar_card_new/bCards/favBCard.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

//Class to create the logic and UI for the Favourite Tab
class FavouriteTab extends StatefulWidget {
  @override
  _FavouriteTabState createState() => _FavouriteTabState();
}

class _FavouriteTabState extends State<FavouriteTab>
    with AutomaticKeepAliveClientMixin {

  //Used to keep the tab active even if the user changes tabs
  @override
  bool get wantKeepAlive => true;

  //A stream is used to get a live stream of the database
  Stream myStream;

  //Function to get the cards from the favourite cards collection in the logged in users record
  //This function is a stream function meaning whatever data is yielded is live from the database
  Stream favQuery(uid) async* {
    //initialises DatabaseService class that takes in the current logged in user's UID
    DatabaseService data = DatabaseService(uid: uid);

    //gets the documents from the cardFav collection in the database
    final dynamic documents = await data.getFav();

    //yields the documents as live data
    yield documents;
  }

  //Function used to refresh the card list whenever a card is deleted from the favourite section
  refresh(myUID) {
    setState(() {
      myStream = favQuery(myUID); //refresh the stream here
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
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: <Widget>[
            //SilverStickyHeader widget used from the flutter_sticky_header package
            //allows for the header to stay at the top of the screen no matter how far the user has scrolled
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
              //The list of the cards are drawn here
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  StreamBuilder(
                      stream: favQuery(user.uid),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        List<Widget> s = [];

                        //if the snapshot has returned some data, the card gets made with the cards UID
                        if (snapshot.hasData) {
                          //If no card exists in the collection a message is shown
                          if (snapshot.data.documents.length == 0) {
                            s.add(SizedBox(
                              height: 50,
                            ));
                            s.add(Text(
                                "Favourite cards will be shown here!"));
                            s.add(
                                Text("Currently there are no favourite Cards!"));
                          }

                          //Iterates over all the data in the collection and creates a card for each record in the collection
                          snapshot.data.documents.forEach((document) {
                            s.add(FavBCard(
                              uid: document.documentID,
                              margin: 10,
                              parentAction: refresh,
                              myUID: user.uid,
                            ));
                          });

                          //if the snapshot has an error, the error message gets shown
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
                        //if the data is still being loaded, the loading animation is shown
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
        ));
  }
}
