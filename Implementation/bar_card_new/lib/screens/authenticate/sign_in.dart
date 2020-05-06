import 'package:flutter/material.dart';
import 'package:bar_card_new/screens/services/auth.dart';

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
  String err = '';
  final AuthService _auth = AuthService();
  bool _load = false;

  @override
  Widget build(BuildContext context) {
    Widget loadingIndicator =_load? new Container(
      color: Colors.grey[300],
      width: 70.0,
      height: 70.0,
      child: new Padding(padding: const EdgeInsets.all(5.0),child: new Center(child: new CircularProgressIndicator())),
    ):new Container();
    return Scaffold(
        appBar: AppBar(
          title: Text('BarCard Login'),
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
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
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          validator: (val) => val.isEmpty ? 'Please enter a valid email!' : null,
                          controller: userInput,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'User Name',
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: TextFormField(
                          validator: (val) => val.length < 7 ? 'Password must be longer than 6 characters!' : null,
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
                  onPressed: (){
                    //do something
                  },
                  textColor: Colors.blue,
                  child: Text('Forgot Password'),
                ),

                SizedBox(height: 9),
                Text(err, style: TextStyle(color: Colors.red, fontSize: 14),textAlign: TextAlign.center),
                SizedBox(height: 9),

                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.blue,
                      child: Text('Login'),
                      onPressed: () async {
                        if(_formKey.currentState.validate()) {
                          FocusScope.of(context).unfocus();
                          //print(userInput.text);
                          //print(passInput.text);
                          setState(() {
                            err = '';
                            _load = true;
                          });

                          dynamic result = await _auth.signInEmail(userInput.text, passInput.text);

                          if (result == null) {
                            setState(() {
                              err = 'Invalid Credentials!';
                              _load = false;
                            });
                          }
                          else{
                            _load = true;
                            Navigator.pop(context);
                          }
                        }
                      },
                    )),
                SizedBox(height: 24),
                Container(
                    child: Column(
                      children: <Widget>[
                        Text("Don't have account?"),
                        FlatButton(
                          textColor: Colors.blue,
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
                new Align(child: loadingIndicator,alignment: FractionalOffset.center,)
              ],
            )));
  }
}
