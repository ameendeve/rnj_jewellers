import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rnj_jewellers/models/datacontroller.dart';

class SmithPage extends StatefulWidget {
  @override
  _SmithPageState createState() => _SmithPageState();
}

class _SmithPageState extends State<SmithPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  var userId;
  String smithName, smithNumber;
  final _smith = FirebaseFirestore.instance.collection('details');

  @override
  void initState() {
    super.initState();
  }

  // void _getUser(){
  //   FirebaseFirestore.instance.collection('users').get().then((value){
  //     value.docs.forEach((result) {
  //       setState(() {
  //         userId = result.data()['uid'];
  //         print(userId);
  //       });
  //     });
  //   });
  // }

  Widget _smithNameInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextFormField(
        style: TextStyle(color: Colors.white),
        onSaved: (val) => smithName = val,
        validator: (value) => value.isEmpty ? "Enter smith name" : null,
        decoration: InputDecoration(
            labelText: "Smith Name",
            hintText: "Enter smith name",
            labelStyle: TextStyle(color: Theme.of(context).primaryColor),
            hintStyle: TextStyle(color: Theme.of(context).primaryColor)),
      ),
    );
  }

  // Widget _smithNumberInput() {
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 20.0),
  //     child: TextFormField(
  //       style: TextStyle(color: Colors.white),
  //       onSaved: (val) => smithNumber = val,
  //       validator: (value) => value.isEmpty ? "Enter smith number" : null,
  //       decoration: InputDecoration(
  //           labelText: "Smith Number",
  //           hintText: "Enter smith number",
  //           labelStyle: TextStyle(color: Theme.of(context).primaryColor),
  //           hintStyle: TextStyle(color: Theme.of(context).primaryColor)),
  //     ),
  //   );
  // }

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
              _onSubmit();
            },
          )
        ],
      ),
    );
  }

  void _onSubmit() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      _addSmith();
    }
  }

  _addSmith() async {
    return _smith.add({
      'Smith Name': smithName,
    }).then((value) {
      _showSuccessSnack();
      Navigator.popAndPushNamed(context, '/addsmithdetails');
    }).catchError((error) {
      final errorMsg = error.message.toString();
      _showErrorSnack(errorMsg);
    });
  }

  void _showSuccessSnack() {
    final snackbar = SnackBar(
      content: Text(
        "Smith details added successfully",
        style: TextStyle(color: Colors.green),
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
    _formKey.currentState.reset();
  }

  void _showErrorSnack(String errorMsg) {
    final snackbar = SnackBar(
      content: Text(
        errorMsg,
        style: TextStyle(color: Colors.red),
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);

    throw Exception("$errorMsg");
  }

  void _showDeleteSnack() {
    final snackbar = SnackBar(
      content: Text(
        "Smith Deleted",
        style: TextStyle(color: Colors.green),
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  Widget _smithListSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Container(
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          color: Color(0xFF243c36),
          elevation: 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10.0, left: 25.0),
                child: Text("Smith List",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor)),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0, left: 10.0),
                child: GetBuilder(
                    init: DataController(),
                    builder: (value) {
                      return FutureBuilder(
                        future: value.getSmithDetails(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return CircularProgressIndicator();
                          }
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, int index) {
                                var catSnapshot = snapshot.data[index].data();
                                return ListTile(
                                  trailing: GestureDetector(
                                    child: Icon(Icons.delete, color: Colors.white,),
                                    onTap: () async {
                                      await FirebaseFirestore.instance
                                          .runTransaction((Transaction
                                              myTransaction) async {
                                            myTransaction.delete(
                                            snapshot.data[index].reference);
                                            _showDeleteSnack();
                                             Navigator.popAndPushNamed(context, '/addsmithdetails');
                                      });
                                    },
                                  ),
                                  title: Text(
                                    catSnapshot['Smith Name'],
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15.0),
                                  ),
                                );
                              });
                        },
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Add smith details"),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Theme.of(context).accentColor,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _smithNameInput(),
                    _showFormAction(),
                    _smithListSection()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
