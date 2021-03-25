import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_form_builder/flutter_form_builder.dart';
//import 'package:get/get.dart';
import 'package:rnj_jewellers/models/product.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
//import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
//import 'dart:typed_data';
import 'package:image/image.dart' as ui;
//import 'dart:convert';
import 'package:path_provider/path_provider.dart';




class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

enum AppState {
  free,
  picked,
  cropped,
}

class _AddProductPageState extends State<AddProductPage> {
  //Image Declaration
  AppState state;
  File imageFile, croppedFile;
  final picker = ImagePicker();
  String imageLink;
  var source = ImageSource.gallery;
  ui.Image _originalImage;
  var filePath;
  List<int> wmImage;

  //Key Declaration
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  //Firebase Declaration
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final _firebaseStorage = FirebaseStorage.instance;
  final _firestore = FirebaseFirestore.instance;
  final products = FirebaseFirestore.instance.collection('products').doc();

  final _product = AddProduct();

  //Smith Name declaration
  String smithName, smithNumber;
  List res = [];
  String jsonRes;

  //Category declaration
  List<dynamic> _myActivities;
  String _myActivitiesResult;

  @override
  void initState() {
    super.initState();
   // _showUserData();
    state = AppState.free;
    _myActivities = [];
    _myActivitiesResult = '';
  }

  // void _showUserData() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   var storedUser = prefs.getString('email');
  //   //print(storedUser);
  // }

  // Widget _showTitle() {
  //   return Text("Add Products", style: Theme.of(context).textTheme.headline1);
  // }

  Widget _productNameInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextFormField(
        style: TextStyle(color: Colors.white),
        onSaved: (val) => _product.productName = val,
        validator: (value) => value.isEmpty ? "Enter product name" : null,
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Product Name",
            hintText: "Enter a product name",
            labelStyle: TextStyle(color: Theme.of(context).primaryColor),
            hintStyle: TextStyle(color: Theme.of(context).primaryColor)),
      ),
    );
  }

  Widget _categoryInput() {
    return new StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('categories').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: Center(child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).primaryColor,
              )),
            );
         // var length = snapshot.data.docs.length;
          //DocumentSnapshot ds = snapshot.data.docs[length - 1];
          var _queryCat = snapshot.data.docs;
          return new Container(
            padding: EdgeInsets.only(top: 20.0, bottom: 5.0),
            child: InputDecorator(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Choose Category',
                labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 16.0),
                hintText: 'Choose Category',
                hintStyle: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 16.0,
                  fontWeight: FontWeight.normal,
                ),
              ),
              //isEmpty: _category == null,
              child: new DropdownButtonFormField(
                value: _product.productCategory,
                validator: (value) =>
                    value == null ? 'Please enter category' : null,
                isDense: true,
                onChanged: (String newValue) {
                  setState(() {
                    _product.productCategory = newValue;
                  });
                  //print(_product.productCategory);
                },
                items: _queryCat.map((DocumentSnapshot document) {
                  return DropdownMenuItem<String>(
                      value: document.data()['category'],
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0)),
                        //color: primaryColor,
                        child: Text(
                          document.data()['category'],
                          style:
                              TextStyle(color: Theme.of(context).primaryColor)
                        ),
                      ));
                }).toList(),
              ),
            ),
          );
        });
  }

  Widget _smithName() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('details').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator(
            backgroundColor: Theme.of(context).primaryColor
          ));
        }
        var result = snapshot.data.docs;
        _myActivities = [];
        result.forEach((item) {
          _myActivities.add(item.data());
        });
        //print(_myActivities);
        return new Container(
          child: InputDecorator(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Column(
                children: [
                  MultiSelectFormField(
                    fillColor: Theme.of(context).accentColor,
                    chipBackGroundColor: Theme.of(context).primaryColor,
                    chipLabelStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500),
                    autovalidate: false,
                    title: Text(
                      'Smith Name',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    validator: (value) => value == null || value.length == 0
                        ? 'Please select one or more smith name'
                        : null,
                    dataSource: _myActivities,
                    textField: 'Smith Name',
                    valueField: 'Smith Name',
                    okButtonLabel: 'OK',
                    cancelButtonLabel: 'CANCEL',
                    // required: true,
                    hintWidget: Text('Please choose one or more',
                        style:
                            TextStyle(color: Theme.of(context).primaryColor)),
                    initialValue: res,
                    onSaved: (value) {
                      if (value == null) return;
                      setState(() {
                        res = value;
                        jsonRes = res.join(", ");
                      });
                    },
                  ),
                  // Container(
                  //   padding: EdgeInsets.only(top: 16.0),
                  //   child: Text(_myActivitiesResult),
                  // )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _productDescriptionInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextFormField(
        style: TextStyle(color: Colors.white),
        onSaved: (val) => _product.description = val,
        validator: (value) => value.isEmpty ? "Enter description" : null,
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Description",
            hintText: "Enter product description",
            labelStyle: TextStyle(color: Theme.of(context).primaryColor),
            hintStyle: TextStyle(color: Theme.of(context).primaryColor)),
      ),
    );
  }

  // Widget _buildButtonIcon() {
  //   if (state == AppState.free) {
  //     return Column(
  //       children: [
  //         Icon(Icons.add_a_photo, color: Colors.white),

  //         Text("Camera")
  //       ],
  //     );
  //   } else if (state == AppState.picked) {
  //     return Icon(Icons.crop);
  //   } else {
  //     return Text("Uploaded");
  //   }
  // }
  
  Future _pickImage() async {
    final pickedFile = await picker.getImage(source: source, imageQuality: 90, maxHeight: 500, maxWidth: 500);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        state = AppState.picked;
      });
      _originalImage = ui.decodeImage(imageFile.readAsBytesSync());
      ui.drawString(_originalImage, ui.arial_24, 50, 50, 'RNJ');
        // Store the watermarked image to a File
       wmImage = ui.encodeJpg(_originalImage);
       Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
       String appDocumentsPath = appDocumentsDirectory.path; 
       for(int i = 0; i < _originalImage.length; i++ ){
          filePath = '$appDocumentsPath/$i.jpg';
       }
        File imgFile = File(filePath);
        imgFile.writeAsBytes(wmImage);
        setState((){
          imageFile = imgFile;
        });
    }
  }

  Future _pickImageCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera, imageQuality: 80, maxHeight: 500, maxWidth: 500);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        state = AppState.picked;
      });
      _originalImage = ui.decodeImage(imageFile.readAsBytesSync());
      ui.drawString(_originalImage, ui.arial_24, 50, 50, 'RNJ');
        // Store the watermarked image to a File
       wmImage = ui.encodeJpg(_originalImage);
       Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
       String appDocumentsPath = appDocumentsDirectory.path; 
       for(int i = 0; i < _originalImage.length; i++ ){
          filePath = '$appDocumentsPath/$i.jpg';
       }
        File imgFile = File(filePath);
        imgFile.writeAsBytes(wmImage);
        setState((){
          imageFile = imgFile;
        });
    }
  }

  Future<Null> _cropImage() async {
    croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      // _originalImage = ui.decodeImage(croppedFile.readAsBytesSync());
      // ui.drawString(_originalImage, ui.arial_48, 150, 340, 'RNJ Jewellers');
      //   // Store the watermarked image to a File
      //  wmImage = ui.encodeJpg(_originalImage);
      //  Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
      //  String appDocumentsPath = appDocumentsDirectory.path; 
      //  for(int i = 0; i < _originalImage.length; i++ ){
      //     filePath = '$appDocumentsPath/$i.jpg';
      //  }
      //   File imgFile = File(filePath);
      //   imgFile.writeAsBytes(wmImage);
      //   print(imgFile);
      imageFile = croppedFile;
      setState(() {
        state = AppState.cropped;
      });
      final Reference rootReference = _firebaseStorage.ref();
      final Reference pictureFolderRef = rootReference.child(imageFile.path);
      pictureFolderRef.putFile(File(imageFile.path)).then((storageTask) async {
        String link = await storageTask.ref.getDownloadURL();
        _showImageSuccessSnack();
        setState(() {
          imageLink = link;
        });
      });
    }
  }

  void _clearImage() {
    imageFile = null;
    setState(() {
      state = AppState.free;
    });
  }

  Widget _uploadImage() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        children: [
          imageFile != null ? Image.file(imageFile) : Container(),
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Expanded(
                child: state != AppState.cropped
                    ? FlatButton(
                        color: Theme.of(context).primaryColor,
                        child: state == AppState.free
                            ? Icon(
                                Icons.photo,
                                color: Colors.white,
                              )
                            : Icon(
                                Icons.crop,
                                color: Colors.white,
                              ),
                        onPressed: () {
                          if (state == AppState.free)
                            _pickImage();
                          else if (state == AppState.picked)
                            _cropImage();
                          else if (state == AppState.cropped) _clearImage();
                        },
                      )
                    : Container(),
              ),
              SizedBox(
                width: 10,
              ),
              state == AppState.free
                  ? Expanded(
                      child: state != AppState.cropped
                          ? FlatButton(
                              color: Theme.of(context).primaryColor,
                              child: state == AppState.free
                                  ? Icon(
                                      Icons.add_a_photo,
                                      color: Colors.white,
                                    )
                                  : Icon(Icons.crop, color: Colors.white),
                              onPressed: () {
                                if (state == AppState.free)
                                  _pickImageCamera();
                                else if (state == AppState.picked)
                                  _cropImage();
                                else if (state == AppState.cropped)
                                  _clearImage();
                              },
                            )
                          : Container(),
                    )
                  : Container(),
            ],
          ),
        ],
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
            onPressed: () => imageLink != null ? _submit() : null
          )
        ],
      ),
    );
  }

  void _submit() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      setState(() {
        _myActivitiesResult = _myActivities.toString();
      });
      _addProducts();
    }
  }

  _addProducts() async {
    return products.set({
      'Document ID': products.id,
      'Product Name': _product.productName,
      'Product Category': _product.productCategory,
      'Product Description': _product.description,
      'Smith Name': jsonRes,
      'Image': imageLink,
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
      content: Text("Products added successfully",
          style: TextStyle(color: Colors.green), textAlign: TextAlign.center),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
    _formKey.currentState.reset();
  }

  void _showImageSuccessSnack() {
    final snackbar = SnackBar(
      backgroundColor: Colors.white,
      content: Text("Image Uploaded",
          style: TextStyle(color: Colors.green), textAlign: TextAlign.center),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Add Product"),
        centerTitle: true,
      ),
      body: Container(
        color: Theme.of(context).accentColor,
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _productNameInput(),
                      _categoryInput(),
                      _smithName(),
                      _productDescriptionInput(),
                      _uploadImage(),
                      _showFormAction()
                    ],
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
