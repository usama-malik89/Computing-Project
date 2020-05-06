import 'package:flutter/material.dart';
import 'package:bar_card_new/screens/services/auth.dart';
import 'package:flutter/services.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController userInput = TextEditingController();
  TextEditingController fNameInput = TextEditingController();
  TextEditingController sNameInput = TextEditingController();
  TextEditingController passInput = TextEditingController();
  String err = '';

  final AuthService _auth = AuthService();

  bool _load = false;

  final _formKey = GlobalKey<FormState>();

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
          title: Text('BarCard Register'),
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
                Container(
                  padding: EdgeInsets.all(10),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          validator: (val) => val.isEmpty ? 'Please enter an email!' : null,
                          controller: userInput,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'E-mail',
                          ),
                        ),
                        SizedBox(height: 10),

                        TextFormField(
                          validator: (val) => val.isEmpty ? 'Please enter First Name!' : null,
                          controller: fNameInput,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'First Name',
                          ),
                        ),
                        SizedBox(height: 10),

                        TextFormField(
                          validator: (val) => val.isEmpty ? 'Please enter Surname!' : null,
                          controller: sNameInput,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Surname',
                          ),
                        ),
                        SizedBox(height: 10),

                        TextFormField(
                          validator: (val) => val.length < 7 ? 'Password must be longer than 6 characters!' : null,
                          obscureText: true,
                          controller: passInput,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 12,),
                Text(err, style: TextStyle(color: Colors.red, fontSize: 14),textAlign: TextAlign.center),
                SizedBox(height: 12,),

                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.blue,
                      child: Text('Register'),
                      onPressed: () async {
                        //print(userInput.text);
                        //print(passInput.text);
                        FocusScope.of(context).unfocus();
                        if(_formKey.currentState.validate()){
                          //print(userInput.text);
                          //print(passInput.text);

                          dynamic result = await _auth.regEmail(
                              userInput.text, passInput.text, fNameInput.text,
                              sNameInput.text);

                          if(result == null){
                            setState(() {
                              err = 'Please enter a valid email!';
                              print(err);
                              _load=false;
                            });
                          }
                          else{
                            setState((){
                              err = '';
                              _load=true;
                              Navigator.pop(context);
                            });
                          }
                        }
                      },
                    )),
                SizedBox(height: 50,),
                Container(
                  child: Column(children: <Widget>[
                    Text("Already Have An Account?"),
                    FlatButton(
                      textColor: Colors.blue,
                      child: Text(
                        'Sign In',
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        widget.toggleView();
                      },
                    ),
                  ],),
                ),

                new Align(child: loadingIndicator,alignment: FractionalOffset.center,),

              ],
            )));
  }
}
