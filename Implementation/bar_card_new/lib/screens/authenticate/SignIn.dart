import 'package:flutter/material.dart';
import 'package:bar_card_new/screens/services/Auth.dart';
import 'package:bar_card_new/AppTheme.dart';
import 'package:progress_button/progress_button.dart';

//Class that contains the UI and logic for the sign in screen
class SignIn extends StatefulWidget {
  //takes in function to be able to change the screen between the sign in and register screen
  final Function toggleView;

  //class initializer
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  //All the text field controllers for the email and password input field
  TextEditingController userInput = TextEditingController();
  TextEditingController passInput = TextEditingController();

  //A key for the form, to be able to easily reference the form
  final _formKey = GlobalKey<FormState>();

  //A key for the reset password form, to be able to easily reference the form
  final _resetformKey = GlobalKey<FormState>();

  //A key for the scaffold which i needed to show a snackbar message
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  //String for showing error messages, initialised as empty so no error is shown initially
  String err = '';

  //variable to control the state of the progress button
  dynamic bState = ButtonState.normal;

  //Initialising the AuthService class in Auth.dart file in the services folder, to be able to use FirebaseAuth and its methods
  final AuthService _auth = AuthService();

  //Function to show a modalBottomSheet dialog for the reset password field
  void _showDialog(value, context1) {
    //the text field controllers for the email input field
    var txt = TextEditingController();

    //uses the value parameter to fill the field with the login field data
    //this is so if the user was trying to login with an email it automatically inputs that email in the reset password email field
    txt.text = value;

    //Function provided by flutter to show a card that slides from the bottom
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            children: <Widget>[
              Form(
                key: _resetformKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Reset Password",
                      style:
                          TextStyle(fontSize: 20, color: AppTheme.nearlyBlue),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      //Form field for email input
                      child: TextFormField(
                        //validation to make sure input isn't empty
                        validator: (val) =>
                            val.isEmpty ? 'Please enter a valid email!' : null,
                        //error message shown to the user if validation fails
                        controller: txt,
                        //assigning the controller so later on the data in the field can be accessed
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'E-Mail',
                        ),
                      ),
                    ),
                    Container(
                        height: 50,
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: RaisedButton(
                          textColor: AppTheme.whiteText,
                          color: AppTheme.nearlyBlue,
                          child: Text('Send Reset E-Mail'),
                          //block of code when the send reset e-mail button is pressed
                          onPressed: () async {
                            //runs if form validation is successful
                            if (_resetformKey.currentState.validate()) {
                              //uses the resetPassword in the Auth.dart file, this uses the firebaseAuth package to send a reset password email to the user
                              _auth.resetPassword(txt.text);

                              //once that is done, it closes the bottom modal
                              Navigator.pop(context);

                              //shows a snackBar message to show the user the email has been successfuly sent
                              _scaffoldKey.currentState.showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Reset Password E-Mail has been sent!'),
                                  duration: Duration(seconds: 3),
                                ),
                              );
                              //closes the keyboard if it is open
                              FocusScope.of(context).unfocus();
                            }
                          },
                        ))
                  ],
                ),
              ),
              //Text(value)
            ],
          );
        });
  }

  //the build function draws the card on the screen
  @override
  Widget build(BuildContext context) {
    //Returns a Scaffold widget which is used in Flutter to access UI elements such as AppBar
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('BarCard Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                child: Text(
                  'BarCard',
                  style: TextStyle(
                      color: AppTheme.nearlyBlue,
                      fontWeight: FontWeight.w500,
                      fontSize: 30),
                )),
            //Form for the texfields
            Form(
              key: _formKey, //key to be able to refer to this form
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10),
                    child:
                        //Form Field for email
                        TextFormField(
                      validator: (val) =>
                          val.isEmpty //input validator to make sure something has been input
                              ? 'Please enter a valid email!' //error message
                              : null,
                      controller: userInput,
                      //controller to be able to refer to the input data
                      //UI styling
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'E-Mail',
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    //Form Field for password
                    child: TextFormField(
                      validator: (val) => val.length <
                              7 //input validator to make sure password is longer than 6 chars
                          ? 'Password must be longer than 6 characters!' //error message
                          : null,
                      obscureText: true,
                      //to hide the input as this is a password
                      controller: passInput,
                      //controller to be able to refer to the input data
                      //UI styling
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //button for the forgot password button
            FlatButton(
              onPressed: () {
                //when the button is pressed the dialog is shown using the _showDialog function
                _showDialog(userInput.text, context);
              },
              textColor: AppTheme.nearlyBlue,
              child: Text('Forgot Password'),
            ),
            SizedBox(height: 9),
            Text(err,
                style: TextStyle(color: AppTheme.veryRed, fontSize: 14),
                textAlign: TextAlign.center),
            SizedBox(height: 9),
            Container(
              height: 50,
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ProgressButton(
                child: Text(
                  "Login",
                  style: TextStyle(
                      color: AppTheme.nearlyWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
                //This block of code gets run when the login button is pressed
                onPressed: () async {
                  //Runs if the form gets successfully validated
                  if (_formKey.currentState.validate()) {
                    //Focus gets unfocused, meaning the keyboard gets closed if it is open
                    FocusScope.of(context).unfocus();

                    setState(() {
                      //first the buttons state gets set to inProgress which means the loading animation in the button is shown
                      bState = ButtonState.inProgress;

                      //removes any previouse message that was being shown
                      err = '';
                    });

                    //tries signing in user with texfield data
                    dynamic result =
                        await _auth.signInEmail(userInput.text, passInput.text);

                    //if the sign in fails error message is shown
                    if (result == null) {
                      setState(() {
                        err = 'Invalid Credentials!';
                        bState = ButtonState
                            .normal; //sets the button's state to normal
                      });
                    } else {
                      //otherwise the current screen is closed and home screen is shown
                      setState(() {
                        bState = ButtonState
                            .inProgress; //sets the button's state to loading animation
                      });
                      Navigator.pop(context);
                    }
                  }
                },
                buttonState: bState,
                backgroundColor: AppTheme.nearlyBlue,
                progressColor: AppTheme.nearlyWhite,
              ),
            ),
            SizedBox(height: 24),
            Container(
              child: Column(
                children: <Widget>[
                  Text("Don't have account?"),
                  FlatButton(
                    textColor: AppTheme.nearlyBlue,
                    child: Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      widget.toggleView();
                    },
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
