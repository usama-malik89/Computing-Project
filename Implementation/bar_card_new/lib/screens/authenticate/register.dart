import 'package:flutter/material.dart';
import 'package:bar_card_new/screens/services/Auth.dart';
import 'package:progress_button/progress_button.dart';
import 'package:bar_card_new/AppTheme.dart';

//Class that contains the UI and logic for the register screen
class Register extends StatefulWidget {
  //takes in function to be able to change the screen between the sign in and register screen
  final Function toggleView;

  //class initializer
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  //All the text field controllers for the fields to be able to register
  TextEditingController userInput = TextEditingController();
  TextEditingController fNameInput = TextEditingController();
  TextEditingController sNameInput = TextEditingController();
  TextEditingController passInput = TextEditingController();

  //String for showing error messages, initialised as empty so no error is shown initially
  String err = '';

  //Controller for the scroller, used to be able to avoid the keyboard blocking any text fields
  ScrollController scrollController = ScrollController();

  //Initialising the AuthService class in Auth.dart file in the services folder, to be able to use FirebaseAuth and its methods
  final AuthService _auth = AuthService();

  //variable to control the state of the progress button
  dynamic bState = ButtonState.normal;

  //A key for the form, to be able to easily reference the form
  final _formKey = GlobalKey<FormState>();

  //the build function draws the card on the screen
  @override
  Widget build(BuildContext context) {
    //Returns a Scaffold widget which is used in Flutter to access UI elements such as AppBar
    return Scaffold(
      appBar: AppBar(
        title: Text('BarCard Register'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          physics: BouncingScrollPhysics(),
          controller: scrollController,
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                child: Text(
                  'BarCard',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                      fontSize: 30),
                )),
            Container(
              padding: EdgeInsets.all(10),
              //Form for the texfields
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    //Form field for the email address
                    TextFormField(
                      onTap: () {
                        //when the field is tapped the screen scrolls up slightly so it doesn't cover the input field
                        //It has to be delayed from running by 100ms to make sure it only scrolls after the keyboard has been shown on the screen
                        Future.delayed(const Duration(milliseconds: 100), () {
                          scrollController.animateTo(50.0,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.ease);
                        });
                      },
                      //validation to make sure something has been entered in the field
                      validator: (val) =>
                          val.isEmpty ? 'Please enter an email!' : null, //error message shown to the user if validation fails
                      controller: userInput, //assigning the controller so later on the data in the field can be accessed
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'E-mail',
                      ),
                    ),
                    SizedBox(height: 10),

                    //Form field for the First Name
                    TextFormField(
                      //when the field is tapped the screen scrolls up slightly so it doesn't cover the input field
                      //It has to be delayed from running by 100ms to make sure it only scrolls after the keyboard has been shown on the screen
                    onTap: () {
                        Future.delayed(const Duration(milliseconds: 100), () {
                          scrollController.animateTo(100.0,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.ease);
                        });
                      },
                      //validation to make sure something has been entered in the field
                      validator: (val) =>
                          val.isEmpty ? 'Please enter First Name!' : null, //error message shown to the user if validation fails
                      controller: fNameInput, //assigning the controller so later on the data in the field can be accessed
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'First Name',
                      ),
                    ),
                    SizedBox(height: 10),

                    //Form field for the  Surname
                    TextFormField(
                      //when the field is tapped the screen scrolls up slightly so it doesn't cover the input field
                      //It has to be delayed from running by 100ms to make sure it only scrolls after the keyboard has been shown on the screen
                    onTap: () {
                        Future.delayed(const Duration(milliseconds: 100), () {
                          scrollController.animateTo(150.0,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.ease);
                        });
                      },
                      //validation to make sure something has been entered in the field
                      validator: (val) =>
                          val.isEmpty ? 'Please enter Surname!' : null, //error message shown to the user if validation fails
                      controller: sNameInput, //assigning the controller so later on the data in the field can be accessed
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Surname',
                      ),
                    ),
                    SizedBox(height: 10),

                    //Form field for the password
                    TextFormField(
                      //validation to make sure a password longer than 6 characters has been added
                    validator: (val) => val.length < 7
                          ? 'Password must be longer than 6 characters!' //error message shown to the user if validation fails
                          : null,
                      obscureText: true, //Text has to be obscured to make sure password cannot be seen
                      controller: passInput, //assigning the controller so later on the data in the field can be accessed
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),

            //This is where error message gets shown
            Text(err,
                style: TextStyle(color: Colors.red, fontSize: 14),
                textAlign: TextAlign.center),
            SizedBox(
              height: 12,
            ),

            //container for containing the signup button
            Container(
              height: 50,
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ProgressButton(
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                        color: AppTheme.nearlyWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  buttonState: bState,
                  backgroundColor: AppTheme.nearlyBlue,
                  progressColor: AppTheme.nearlyWhite,
                  //This block of code gets run when the button is pressed
                  onPressed: () async {
                    //Focus gets unfocused, meaning the keyboard gets closed if it is open
                    FocusScope.of(context).unfocus();

                    //Runs if the form gets successfully validated
                    if (_formKey.currentState.validate()) {

                      setState(() {
                        //first the buttons state gets set to inProgress which means the loading animation in the button is shown
                        bState = ButtonState.inProgress;

                        //removes any previouse message that was being shown
                        err = '';
                      });

                      //Uses the regEmail method in the Auth.dart file, and passes the input data
                      dynamic result = await _auth.regEmail(userInput.text,
                          passInput.text, fNameInput.text, sNameInput.text);

                      //if the registration fails it shows an error
                      //registration can fail if the email already exists or if incorrect email has been input
                      if (result == null) {
                        setState(() {
                          //Shows the error to user
                          err = 'Please enter a valid email!';

                          //Stops the loading animation
                          bState = ButtonState.normal;
                        });
                      } else {
                        //if no error happens during registration button gets shown as loading and the screen gets popped to show the home page
                        setState(() {
                          err = '';
                          bState = ButtonState.inProgress;
                          Navigator.pop(context);
                        });
                      }
                    }
                  }),
            ),

            SizedBox(
              height: 50,
            ),

            //Container for containing the sign up button to toggle between login page and this page
            Container(
              child: Column(
                children: <Widget>[
                  Text("Already Have An Account?"),
                  FlatButton(
                    textColor: Colors.blue,
                    child: Text(
                      'Sign In',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      //uses the parent function to toggle the view
                      widget.toggleView();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
