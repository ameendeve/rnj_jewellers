import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _email;

  bool _isSubmitting;

  final _auth = FirebaseAuth.instance;
  
  @override
  void initState(){
    super.initState();
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
      _resettingUserPassword(); 
    }
  }

  void _resettingUserPassword() async {
    await _auth
        .sendPasswordResetEmail(email: _email)
        .then((response) {
              setState(() {
      _isSubmitting = true;
    });
      //print(response);
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
        "Password reset email sent successfully",
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


  void _redirectUser() {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/dashboard');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Password Reset"),
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
