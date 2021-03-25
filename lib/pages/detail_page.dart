import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rnj_jewellers/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailPage extends StatefulWidget {
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

   
  final _blockedUser = FirebaseFirestore.instance.collection('blockeduser');
  String _email;
  var userId, userEmail;
final _auth = FirebaseAuth.instance;

  //product model
  final _product = AddProduct();

  //Key Declaration
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final orderCollection = FirebaseFirestore.instance.collection('orders').doc();



  User loggedInUser;
  void getCurrentUser() async {
    try {
      // ignore: await_only_futures
      final user = await _auth.currentUser;
      if (user != null) {
        setState(() {
          loggedInUser = user;
        });
      }
    } catch (error) {
      return error;
    }
  }

  Widget _meltingInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextFormField(
        style: TextStyle(color: Colors.white),
        onSaved: (val) => _product.melting = val,
        validator: (value) => value.isEmpty ? "Enter melting" : null,
        decoration: InputDecoration(
            labelText: "Melting",
            hintText: "Enter melting",
            labelStyle: TextStyle(color: Theme.of(context).primaryColor),
            hintStyle: TextStyle(color: Theme.of(context).primaryColor)),
      ),
    );
  }

  Widget _gramsInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextFormField(
        style: TextStyle(color: Colors.white),
        onSaved: (val) => _product.grams = val,
        validator: (value) => value.isEmpty ? "Enter grams" : null,
        decoration: InputDecoration(
            labelText: "Grams",
            hintText: "Enter grams",
            labelStyle: TextStyle(color: Theme.of(context).primaryColor),
            hintStyle: TextStyle(color: Theme.of(context).primaryColor)),
      ),
    );
  }

  Widget _stonesInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextFormField(
        style: TextStyle(color: Colors.white),
        onSaved: (val) => _product.stones = val,
        validator: (value) => value.isEmpty ? "Enter stones" : null,
        decoration: InputDecoration(
            labelText: "Stones %",
            hintText: "Enter stones",
            labelStyle: TextStyle(color: Theme.of(context).primaryColor),
            hintStyle: TextStyle(color: Theme.of(context).primaryColor)),
      ),
    );
  }

  Widget _sealInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextFormField(
        style: TextStyle(color: Colors.white),
        onSaved: (val) => _product.seal = val,
        validator: (value) => value.isEmpty ? "Enter seal" : null,
        decoration: InputDecoration(
            labelText: "Seal",
            hintText: "Enter seal",
            labelStyle: TextStyle(color: Theme.of(context).primaryColor),
            hintStyle: TextStyle(color: Theme.of(context).primaryColor)),
      ),
    );
  }

  Widget _showFormAction() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: Column(
        children: [
          RaisedButton(
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
      _addOrders();
    }
  }


    _addOrders() async {
    return orderCollection.set({
      'Email': _email,
      'Image': Get.arguments['Image'],
      'Product Name': Get.arguments['Product Name'],
      'Product Category': Get.arguments['Product Category'],
      'Product Description': Get.arguments['Product Description'],
      'Smith Name': Get.arguments['Smith Name'],
      'Grams' : _product.grams,
      'Melting': _product.melting,
      'Stones': "${_product.stones}%",
      'Seal': _product.seal,
      'timestamp': DateTime.now(), 
    }).then((response) {
      _showSuccessSnack();
      _redirectUser();
    }).catchError((error) {
      final errorMsg = error.message.toString();
      _showErrorSnack(errorMsg);
    });
  }

    void _showSuccessSnack() {
    final snackbar = SnackBar(
      backgroundColor: Colors.white,
      content: Text("Order submitted successfully",
          style: TextStyle(color: Colors.green), textAlign: TextAlign.center),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
    _formKey.currentState.reset();
  }

    void _showErrorSnack(String errorMsg) {
    final snackbar = SnackBar(
      backgroundColor: Colors.white,
      content: Text(errorMsg,
          style: TextStyle(color: Colors.red), textAlign: TextAlign.center),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);

    throw Exception("$errorMsg");
  }

  void _redirectUser() {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/dashboard');
    });
  }

  void _showUserData() async {
    final prefs = await SharedPreferences.getInstance();
    var storedUser = prefs.getString('email');
    if (storedUser != null) {
      setState(() {
        _email = storedUser;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _showUserData();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Product Detail Page"),
        centerTitle: true,
      ),
      body: Container(
        color: Theme.of(context).accentColor,
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Card(
                    color: Color(0xFF243c36),
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(10.0),
                          bottom: Radius.circular(10.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Card(
                            child: GestureDetector(
                          child: Image.network(
                            Get.arguments['Image'],
                            height: 300,
                            width: 300,
                            fit: BoxFit.fitWidth,
                          ),
                          onLongPress:  _email != "admin@gmail.com" ? () {
                            _blockedUser.doc(loggedInUser.uid).set({
                              'email': loggedInUser.email,
                              'uid': loggedInUser.uid,
                              'isBlocked': true
                            });
                            Navigator.pushReplacementNamed(context, '/dashboard');
                          } : null,
                        )),
                      ),
                    ),
                  ),
                ),
                Card(
                  color: Color(0xFF243c36),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 15.0, bottom: 15.0, left: 15.0),
                        child: Text(
                            Get.arguments['Product Name'],
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).primaryColor)),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(bottom: 15.0, left: 15.0),
                        child: Text(
                          Get.arguments['Product Description'],
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
                Card(
                  color: Color(0xFF243c36),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  "Category",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 50.0,
                          width: 1.0,
                          color: Theme.of(context).accentColor,
                          margin:
                              const EdgeInsets.only(left: 15.0, right: 10.0),
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  Get.arguments['Product Category'],
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                _email == "admin@gmail.com"
                    ? Card(
                        color: Color(0xFF243c36),
                        child: Row(
                          children: [
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Text(
                                      "Smith Name",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white),
                                    ),
                                  ),
                                  
                                ],
                              ),
                            ),
                            Flexible(
                                                          child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ButtonTheme(
                                      minWidth: 10,
                                      height: 25,
                                      child: RaisedButton(
                                        color: Theme.of(context).primaryColor,
                                        child: Text(
                                          Get.arguments['Smith Name'],
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white),
                                        ),
                                        onPressed: () {
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    : Container(),

                    //Users Field
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Form(
                    key: _formKey,
                      child: Column(
                      children: [
                        _gramsInput(),
                        _meltingInput(),
                        _stonesInput(),
                        _sealInput(),
                        _showFormAction()    
                      ],
                    ),
                  ),
                ), 


              ],
            ),
          ),
        ),
      ),
    );
  }
}
