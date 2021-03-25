//import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();


  String _username, _email, _password;

  bool _isSubmitting, _obscureText = true;

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Widget _showTitle() {
    return Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        elevation: 10,
        child: ClipRRect(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(10.0), bottom: Radius.circular(10.0)),
            child: Image.asset('images/logo.png', height: 100, width: 200)));
  }

  Widget _showUsernameInput() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: TextFormField(
        style: TextStyle(color: Colors.white),
        onSaved: (val) => _username = val,
        validator: (value) => value.length < 5 ? "Username too short" : null,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Username",
          hintText: "Enter username, min length 6",
          labelStyle: TextStyle(color: Theme.of(context).primaryColor),
          hintStyle: TextStyle(color: Theme.of(context).primaryColor),
          icon: Icon(
            Icons.face,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _showEmailInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextFormField(
        style: TextStyle(color: Colors.white),
        onSaved: (val) => _email = val,
        validator: (value) =>
            !value.contains('@') ? "Enter a valid Email" : null,
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
        validator: (value) => value.length < 4 ? "Password too short" : null,
        obscureText: _obscureText,
        decoration: InputDecoration(
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
            child: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
              color: Theme.of(context).primaryColor,
            ),
          ),
          border: OutlineInputBorder(),
          labelText: "Password",
          hintText: "Enter password, min length 4",
          labelStyle: TextStyle(color: Theme.of(context).primaryColor),
          hintStyle: TextStyle(color: Theme.of(context).primaryColor),
          icon: Icon(Icons.lock, color: Theme.of(context).primaryColor),
        ),
      ),
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
                    "Submit",
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
      _registerUser();
    }
  }

   _registerUser() async {
    await _auth
        .createUserWithEmailAndPassword(email: _email, password: _password)
        .then((response) {
      setState(() {
        _isSubmitting = true;
      });
      _firestore.collection("users").doc(response.user.uid).set({
        "uid": response.user.uid,
        "displayName": _username,
        "email": _email
      });
      _storeUserData(response);
      _showSuccessSnackbar();
      _redirectUser();
      //print(response);
    }).catchError((error) {
      setState(() {
        _isSubmitting = false;
      });
      final String errorMsg = error.message.toString();
      _showErrorSnackbar(errorMsg);
    });
  }

  void _showSuccessSnackbar() {
    final snackbar = SnackBar(
      backgroundColor: Colors.white,
      content: Text("User $_username is registered successfully",
          style: TextStyle(color: Colors.green), textAlign: TextAlign.center),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
    _formKey.currentState.reset();
  }

  void _showErrorSnackbar(String errorMsg) {
    final snackbar = SnackBar(
      backgroundColor: Colors.white,
      content: Text(errorMsg.toString(),
          style: TextStyle(color: Colors.red), textAlign: TextAlign.center),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
    throw Exception("$errorMsg");
  }

  void _storeUserData(response) async {
    WidgetsFlutterBinding.ensureInitialized();
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('email', _email);
  }

  void _redirectUser() {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/register');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Register"),
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
                  _showUsernameInput(),
                  _showEmailInput(),
                  _showPasswordInput(),
                  _showFormAction()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
