
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:rnj_jewellers/pages/dashboard_page.dart';
import 'package:rnj_jewellers/pages/login_page.dart';


final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

class DataController extends GetxController{
  
  Future getData() async {
      QuerySnapshot snapshot = await _firestore.collection('products').get();

      return snapshot.docs;
  }

  Future getUser() async {
      QuerySnapshot snapshot = await _firestore.collection('users').get();

      return snapshot.docs;
  }

  Future blockedUser() async {
      QuerySnapshot snapshot = await _firestore.collection('blockeduser').get();

      return snapshot.docs;
  }

  Future getCategory() async {
      QuerySnapshot snapshot = await _firestore.collection('categories').get();

      return snapshot.docs;
  }

    Future getSmithDetails() async {
      QuerySnapshot snapshot = await _firestore.collection('details').get();

      return snapshot.docs;
  }

      Future getOrder() async {
      QuerySnapshot snapshot = await _firestore.collection('orders').orderBy("timestamp", descending: true).get();

      return snapshot.docs;
  }

  Future queryData(String queryString) async {
    return _firestore
        .collection('products')
        .where('Product Name', isGreaterThanOrEqualTo: queryString)
        .get();
  }

  Future deleteuseraccount(String _email,String _password) async{

    User user = _auth.currentUser;

    AuthCredential credential = EmailAuthProvider.credential(email: _email, password: _password);

    await user.reauthenticateWithCredential(credential).then((value) {
      value.user.delete().then((res) {
        Get.offAll(LoginPage());
        Get.snackbar("User Account Deleted ", "Successfully", backgroundColor: Colors.white);
      });
    }

    ).catchError((onError)=> Get.snackbar("Credential Error", "Failed"));
  }

}