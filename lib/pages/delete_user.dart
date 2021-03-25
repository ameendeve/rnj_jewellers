//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:rnj_jewellers/models/datacontroller.dart';
//import 'package:shared_preferences/shared_preferences.dart';


class DeleteUserPage extends StatefulWidget {
  @override
  _DeleteUserPageState createState() => _DeleteUserPageState();
}

class _DeleteUserPageState extends State<DeleteUserPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();



  String _email, _password;

  bool _isSubmitting, _obscureText = true;

  //final _auth = FirebaseAuth.instance;
  //final _firestore = FirebaseFirestore.instance;

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
        validator: (value) => value.length < 6 ? "Password too short" : null,
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
          hintText: "Enter the password",
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
      _deleteUser();
    }
  }

  void _deleteUser() {
     DataController().deleteuseraccount(_email, _password);
      _formKey.currentState.reset(); 
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Delete Account"),
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
