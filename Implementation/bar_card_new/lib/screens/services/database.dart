import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;
  DatabaseService({this.uid});

  //collection reference
  final CollectionReference userCollection = Firestore.instance.collection("userCollection");

  Future updateUserData(String fName, String sName, String email, bool isPublic, String bColor, String fColor) async {
    return await userCollection.document(uid).setData({
      'firstName': fName,
      'surname': sName,
      'email': email,
      'isPublic': isPublic,
      'bColor': bColor,
      'fColor': fColor,
      'location': ''
    });
  }

  Future createRecentCollection() async {
    return await userCollection.document(uid).collection('recent').document().setData({

    });
  }

  Future getUserName() async {
    var result = await userCollection.document(uid).get();
    //String sname = result'surname'];
    //print(result['firstName']);
    return result['firstName'] + " " + result['surname'];
  }

  Future getUserBColor() async {
    var result = await userCollection.document(uid).get();
    //String sname = result'surname'];
    //print(result['firstName']);
    return result['bColor'];
  }

  Future getUserFColor() async {
    var result = await userCollection.document(uid).get();
    //String sname = result'surname'];
    //print(result['firstName']);
    return result['fColor'];
  }

  Future getUserPublic() async {
    var result = await userCollection.document(uid).get();
    //String sname = result'surname'];
    //print(result['firstName']);
    return result['isPublic'];
  }

  Future setUserPref(bg, font, pub) async {
    await userCollection.document(uid).updateData({'bColor': bg, 'fColor': font, 'isPublic': pub});
    print("Done");
  }

  Future getRecent() async {
    final CollectionReference userCollection = Firestore.instance.collection("userCollection");
    userCollection.document(uid).collection('recent').getDocuments().then((value){
      if(value != null){
        value.documents.forEach((value){
          print(value.data);
        });
      }
      else{
        print("No Data");
      }
    });
  }

  Future updateLocation(location) async {
    await userCollection.document(uid).updateData({'location': location});
  }

}