import 'package:firebase_auth/firebase_auth.dart';
import 'package:bar_card_new/models/user.dart';
import 'package:bar_card_new/screens/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user object
  User _userFromFBUser(FirebaseUser user){
    return user != null ? User(uid: user.uid, email: user.email) : null;
  }

  //auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFBUser);
  }

  //email signup
  Future regEmail(String email, String password, String fName, String sName) async {
    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;

      //create new doucment in database for user
      await DatabaseService(uid: user.uid).updateUserData(fName, sName, email, false, "Color(0xff233c67)", "Color(0xfff4f4f4)");

      return _userFromFBUser(user);
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

  //email signing
  Future signInEmail(String email, String password) async {
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;


      return _userFromFBUser(user,);
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }


  //anonymous signin
  Future signInAnon() async {

    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;

      return _userFromFBUser(user);

    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

  //email signin


  //sign out

  Future signOut() async {
    try{
      return await _auth.signOut();
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }



}