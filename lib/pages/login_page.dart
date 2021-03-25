import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _email, _password;

  bool _isSubmitting, _obscureText = true;

  final _auth = FirebaseAuth.instance;
  
  @override
  void initState(){
    super.initState();
    _storeUserData();
    //_blockedUser();
  }

  Widget _showTitle() {
    return Card(
      shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            elevation: 10,
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(
                                top: Radius.circular(10.0),
                                bottom: Radius.circular(10.0)),
            child: Image.asset('images/logo.png', height: 100, width: 200)));
  }

  Widget _showEmailInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextFormField(
        style: TextStyle(color: Colors.white),
        onSaved: (val) => _email = val,
        validator: (value) => !value.contains('@') ? "Email is invalid" : null,
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Email",
            hintText: "Enter a valid email",
              labelStyle: TextStyle(color: Theme.of(context).primaryColor),
              hintStyle: TextStyle(color: Theme.of(context).primaryColor),
            icon: Icon(Icons.mail, color: Theme.of(context).primaryColor)),
      ),
    );
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: TextFormField(
        style: TextStyle(color: Colors.white),
          onSaved: (val) => _password = val,
          validator: (value) => value.length < 6 ? "Password too short" : null,
          obscureText: _obscureText,
          decoration: InputDecoration(
            suffixIcon: GestureDetector(
              onTap: (){
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
              child: Icon(_obscureText ? Icons.visibility : Icons.visibility_off, color: Theme.of(context).primaryColor,),
              ),
              border: OutlineInputBorder(),
              labelText: "Password",
              hintText: "Enter password, min length 6",
              labelStyle: TextStyle(color: Theme.of(context).primaryColor),
              hintStyle: TextStyle(color: Theme.of(context).primaryColor),
              icon: Icon(Icons.lock, color: Theme.of(context).primaryColor))),
    );
  }

  Widget _showFormAction() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: Column(
        children: [
          _isSubmitting == true
              ? CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                )
              : RaisedButton(
                  child: Text(
                    "Login",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: Colors.white),
                  ),
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    _submit();
                  },
                )
        ],
      ),
    );
  }

  void _submit() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      _loggingInUser(); 
    }
  }

  void _loggingInUser() async {
    await _auth
        .signInWithEmailAndPassword(email: _email, password: _password)
        .then((response) {
              setState(() {
      _isSubmitting = true;
    });
      //print(response);
      _storeUserData();
      _showSuccessSnack();
      _redirectUser();
    }).catchError((error) {
      setState(() {
        _isSubmitting = false;
      });
      final errorMsg = error.message.toString();
      _showErrorSnack(errorMsg);
    });
  }

  void _showSuccessSnack() {
    final snackbar = SnackBar(
      backgroundColor: Colors.white,
      content: Text(
        "User successfully logged in",
        style: TextStyle(color: Colors.green), textAlign: TextAlign.center,
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
    _formKey.currentState.reset();
  }


  void _showErrorSnack(String errorMsg) {
    final snackbar = SnackBar(
      backgroundColor: Colors.white, 
      content: Text(
        errorMsg,
        style: TextStyle(color: Colors.red), textAlign: TextAlign.center
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);

    throw Exception("$errorMsg");
  }

  void _storeUserData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('email', _email);
  }

  void _redirectUser() {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,
      ),
      body: Container(
        color: Theme.of(context).accentColor,
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _showTitle(),
                  _showEmailInput(),
                  _showPasswordInput(),
                  _showFormAction(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
