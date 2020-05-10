import 'package:firebase_auth/firebase_auth.dart';
import 'package:bar_card_new/models/User.dart';
import 'package:bar_card_new/screens/services/Database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user object
  User _userFromFBUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid, email: user.email) : null;
  }

  //auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFBUser);
  }

  //email signup
  Future regEmail(
      String email, String password, String fName, String sName) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;

      //create new doucment in database for user
      await DatabaseService(uid: user.uid).updateUserData(
          fName, sName, email, false, "Color(0xff233c67)", "Color(0xfff4f4f4)");

      return _userFromFBUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //email signing
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

  //forgot password

  Future resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  //change password
  void _changePassword(String password) async {
    //Create an instance of the current user.
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    //Pass in the password to updatePassword.
    user.updatePassword(password).then((_) {
      print("Succesfull changed password");
    }).catchError((error) {
      print("Password can't be changed" + error.toString());
      //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
    });
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
