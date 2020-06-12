import 'package:firebase_auth/firebase_auth.dart';
import 'package:bar_card_new/models/User.dart';
import 'package:bar_card_new/screens/services/Database.dart';

//class for handling authentication methods, mostly provided by FireBaseAuth package
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create the user object
  User _userFromFBUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid, email: user.email) : null;
  }

  //auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFBUser);
  }

  //Function to register with email
  Future regEmail(
      String email, String password, String fName, String sName) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;

      //create a new document in database for user
      await DatabaseService(uid: user.uid).updateUserData(
          fName, sName, email, false, "Color(0xff233c67)", "Color(0xfff4f4f4)");

      return _userFromFBUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //function to sign in with email
  Future signInEmail(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;

      return _userFromFBUser(
        user,
      );
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //function to send a reset password email if the password is forgotten
  Future resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  //Function to sign out the logged in user
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
