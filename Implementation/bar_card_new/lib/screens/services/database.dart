import 'package:cloud_firestore/cloud_firestore.dart';

//The mid layer class that handles all the database operations
class DatabaseService {
  //UID to be able to access the user record in the database with the corresponding UID
  final String uid;

  DatabaseService({this.uid});

  //user collection reference
  final CollectionReference userCollection =
      Firestore.instance.collection("userCollection");


  //function to update the user data in the users record
  Future updateUserData(String fName, String sName, String email, bool isPublic,
      String bColor, String fColor) async {
    return await userCollection.document(uid).setData({
      'firstName': fName,
      'surname': sName,
      'email': email,
      'isPublic': isPublic,
      'bColor': bColor,
      'fColor': fColor,
      'location': '',
      'line1': '',
      'line2': ''
    });
  }

  //Function to get the users Full name from the database
  Future getUserName() async {
    var result = await userCollection.document(uid).get();
    return result['firstName'] + " " + result['surname'];
  }

  //Function to get the users cards line1 property
  Future getLine1() async {
    var result = await userCollection.document(uid).get();
    return result['line1'];
  }

  //Function to get the users cards line2 property
  Future getLine2() async {
    var result = await userCollection.document(uid).get();
    return result['line2'];
  }

  //Function to get the users cards background color property
  Future getUserBColor() async {
    var result = await userCollection.document(uid).get();
    return result['bColor'];
  }

  //Function to get the users cards font color property
  Future getUserFColor() async {
    var result = await userCollection.document(uid).get();
    return result['fColor'];
  }

  //Function to get the users cards background color property
  Future getUserPublic() async {
    var result = await userCollection.document(uid).get();
    return result['isPublic'];
  }

  //Function to set the users cards preferences
  Future setUserPref(bg, font, pub, l1, l2) async {
    await userCollection
        .document(uid)
        .updateData({'bColor': bg, 'fColor': font, 'isPublic': pub, 'line1': l1, 'line2': l2});
  }

  //Function to get the users recently scanner card history from database
  Future getRecent() async {
    dynamic recentDoc = userCollection
        .document(uid)
        .collection('cardHistory').orderBy('timestamp', descending: true)
        .getDocuments();

    return recentDoc;
  }

  //Function to get the users favorite cards from database
  Future getFav() async {
    dynamic favDoc = userCollection
        .document(uid)
        .collection('cardFav').orderBy('timestamp', descending: true)
        .getDocuments();

    return favDoc;
  }

  //Function to add a scanned card in the database cardHistory collection
  Future updateCardHistory(scannedUID) async {
    dynamic test = await userCollection.document(scannedUID).get();
    if(test.exists){
      return await userCollection
          .document(uid)
          .collection('cardHistory')
          .document(scannedUID)
          .setData({
        'timestamp': DateTime.now(),
      });
    }
  }

  //Function to add a favorite card in the database cardFav collection
  Future updateFav(cardUID) async {
    print("Fav Updated");
    return await userCollection
        .document(uid)
        .collection('cardFav')
        .document(cardUID)
        .setData({
      'timestamp': DateTime.now(),
    });
  }

  //Function to set the location property in the user record
  Future updateLocation(location) async {
    await userCollection.document(uid).updateData({'location': location});
  }

  //Function to get the location property in the user record
  Future getLocation() async {
    var result = await userCollection.document(uid).get();
    return result['location'];
  }
}
