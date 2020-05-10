import 'package:flutter/material.dart';
import 'package:bar_card_new/screens/services/Auth.dart';
import 'package:bar_card_new/AppTheme.dart';
import 'package:progress_button/progress_button.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController userInput = TextEditingController();
  TextEditingController passInput = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _resetformKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String err = '';
  dynamic bState = ButtonState.normal;
  final AuthService _auth = AuthService();
  bool _load = false;

  void _showDialog(value, context1) {
    var txt = TextEditingController();
    txt.text = value;

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
                      child: TextFormField(
                        validator: (val) =>
                            val.isEmpty ? 'Please enter a valid email!' : null,
                        controller: txt,
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
                          onPressed: () async {
                            if (_resetformKey.currentState.validate()) {
                              _auth.resetPassword(txt.text);
                              Navigator.pop(context);

                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text(
                                    'Reset Password E-Mail has been sent!'),
                                duration: Duration(seconds: 3),
                              ));
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

  @override
  Widget build(BuildContext context) {
    Widget loadingIndicator = _load
        ? new Container(
            color: AppTheme.grey,
            width: 70.0,
            height: 70.0,
            child: new Padding(
                padding: const EdgeInsets.all(5.0),
                child: new Center(child: new CircularProgressIndicator())),
          )
        : new Container();
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
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          validator: (val) => val.isEmpty
                              ? 'Please enter a valid email!'
                              : null,
                          controller: userInput,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'E-Mail',
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: TextFormField(
                          validator: (val) => val.length < 7
                              ? 'Password must be longer than 6 characters!'
                              : null,
                          obscureText: true,
                          controller: passInput,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                FlatButton(
                  onPressed: () {
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
                    child: Text("Login", style: TextStyle(color: AppTheme.nearlyWhite, fontSize: 18, fontWeight: FontWeight.w500),),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          err = '';
                          //_load = true;
                          bState = ButtonState.inProgress;
                        });

                        dynamic result = await _auth.signInEmail(
                            userInput.text, passInput.text);

                        if (result == null) {
                          setState(() {
                            err = 'Invalid Credentials!';
                            bState = ButtonState.normal;
                            //_load = false;
                          });
                        } else {

                          setState(() {
                            bState = ButtonState.inProgress;
                          });
                          //_load = true;
                          Navigator.pop(context);
                        }
                      }
                    },
                    buttonState: bState,
                    backgroundColor: AppTheme.nearlyBlue,
                    progressColor: AppTheme.nearlyWhite,
                  ),
                ),

//                    RaisedButton(
//                      textColor: AppTheme.whiteText,
//                      color: AppTheme.nearlyBlue,
//                      child: Text('Login'),
//                      onPressed: () async {
//                        if (_formKey.currentState.validate()) {
//                          FocusScope.of(context).unfocus();
//                          //print(userInput.text);
//                          //print(passInput.text);
//                          setState(() {
//                            err = '';
//                            _load = true;
//                          });
//
//                          dynamic result = await _auth.signInEmail(
//                              userInput.text, passInput.text);
//
//                          if (result == null) {
//                            setState(() {
//                              err = 'Invalid Credentials!';
//                              _load = false;
//                            });
//                          } else {
//                            _load = true;
//                            Navigator.pop(context);
//                          }
//                        }
//                      },
//                    )),
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
                )),
                new Align(
                  child: loadingIndicator,
                  alignment: FractionalOffset.center,
                )
              ],
            )));
  }
}
