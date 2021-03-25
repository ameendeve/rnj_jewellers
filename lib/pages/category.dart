import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rnj_jewellers/models/datacontroller.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String categoryName;
  final category = FirebaseFirestore.instance.collection('categories');

  Widget _categoryInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextFormField(
        style: TextStyle(color: Colors.white),
        onSaved: (val) => categoryName = val,
        validator: (value) => value.isEmpty ? "Enter category name" : null,
        decoration: InputDecoration(
            labelText: "Category Name",
            hintText: "Enter category name",
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
      //print(categoryName);
      _addCategory();
    }
  }

  _addCategory() async {
    return await category.add({
      'category': categoryName,
    }).then((value) {
      _showSuccessSnack();
      Navigator.popAndPushNamed(context, '/addcategory');
    }).catchError((error) {
      final errorMsg = error.message.toString();
      _showErrorSnack(errorMsg);
    });
  }

  void _showSuccessSnack() {
    final snackbar = SnackBar(
      content: Text(
        "Category added successfully",
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

  Widget _categoryListSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Container(
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0)),
          color: Color(0xFF243c36),
          elevation: 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top:10.0, left: 25.0),
                child: Text("Category List",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor)),
              ),
              Padding(
                padding: EdgeInsets.only(top:10.0, left: 10.0),
                child: GetBuilder(
                    init: DataController(),
                    builder: (value) {
                      return FutureBuilder(
                        future: value.getCategory(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return CircularProgressIndicator();
                          }
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, int index) {
                                var catSnapshot = snapshot.data[index].data();
                                return Padding(
                                  padding: const EdgeInsets.only(top: 10.0, left: 15.0, bottom: 10.0),
                                  child: Row(
                                    children: [
                                      Text(catSnapshot['category'],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.0),
                                              ),
                                    ],
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
        title: Text("Add a category"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Theme.of(context).accentColor,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.0),
          child: SingleChildScrollView(
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _categoryInput(),
                    _showFormAction(),
                    _categoryListSection()
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
