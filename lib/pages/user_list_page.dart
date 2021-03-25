import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rnj_jewellers/models/datacontroller.dart';
//import 'package:jewlry/pages/dashboard_page.dart';

class UserListPage extends StatefulWidget {
  UserListPage({this.uid});
  final String uid;

  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  // void _logOut() {
  //   final _auth = FirebaseAuth.instance;
  //   _auth.signOut().then((value) {
  //         Navigator.pushReplacementNamed(context, '/deleteuser');
  //   });
  // }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var firebaseUser = FirebaseAuth.instance.currentUser;
  final _blockedUser = FirebaseFirestore.instance.collection('blockeduser');

  bool isBlocked = false;

  @override
  void initState() {
    super.initState();
  }

  // void _blockUser() async {
  //   await _firestore.collection('blockeduser').get().then((value) {
  //     value.docs.forEach((result) {
  //       final blocked = result.data()['isBlocked'];
  //       setState(() {
  //         isBlocked = blocked;
  //         print(isBlocked);
  //       });

  //     });
  //   });
  // }

  // _blocked() {
  //   var usersId = userSnapshot['uid'];
  //   _blockedUser.doc(usersId).set({
  //     'email': userSnapshot['email'],
  //     'uid': usersId,
  //     'isBlocked': true
  //   }).then((context) {
  //     _showBlockedSuccessSnack();
  //   });

  // }

  // _unblocked() {
  //   var usersId = userSnapshot['uid'];
  //   _blockedUser.doc(usersId).delete().then((context) {
  //     _showUnBlockedSuccessSnack();
  //   });
  // }

  void _showBlockedSuccessSnack() {
    final snackbar = SnackBar(
      backgroundColor: Colors.white,
      content: Text(
        "User blocked successfully",
        style: TextStyle(color: Colors.red), textAlign: TextAlign.center
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  void _showUnBlockedSuccessSnack() {
    final snackbar = SnackBar(
      backgroundColor: Colors.white,
      content: Text(
        "User Unblocked successfully",
        style: TextStyle(color: Colors.green,), textAlign: TextAlign.center
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("List of users"),
        centerTitle: true,
      ),
      body: Container(
        color: Theme.of(context).accentColor,
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: GetBuilder(
                    init: DataController(),
                    builder: (value) {
                      return FutureBuilder(
                        future: value.getUser(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(
                                  backgroundColor:
                                      Theme.of(context).primaryColor),
                            );
                          } else {
                            return ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, int index) {
                                  var userSnapshot =
                                      snapshot.data[index].data();
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0)),
                                    color: Color(0xFF243c36),
                                    elevation: 10,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10.0),
                                          child: ListTile(
                                            title: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                  "Name - ${userSnapshot['displayName']}",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16.0)),
                                            ),
                                            subtitle: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                  "Email - ${userSnapshot['email']}",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15.0)),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 10.0, left: 130.0),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ButtonTheme(
                                                    minWidth: 10,
                                                    height: 25,
                                                    child: RaisedButton(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        child: Text(
                                                          "Block",
                                                          style: TextStyle(
                                                            fontSize: 14.0,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          var usersId =
                                                              userSnapshot[
                                                                  'uid'];
                                                          _blockedUser
                                                              .doc(usersId)
                                                              .set({
                                                            'email':
                                                                userSnapshot[
                                                                    'email'],
                                                            'uid': usersId,
                                                            'isBlocked': true
                                                          }).then((context) {
                                                            _showBlockedSuccessSnack();
                                                          });
                                                        }),
                                                        ),
                                                SizedBox(
                                                  width: 10.0,
                                                ),
                                                ButtonTheme(
                                                    minWidth: 10,
                                                    height: 25,
                                                    child: RaisedButton(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      child: Text(
                                                        "Unblock",
                                                        style: TextStyle(
                                                          fontSize: 14.0,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        var usersId =
                                                            userSnapshot['uid'];
                                                        _blockedUser
                                                            .doc(usersId)
                                                            .delete()
                                                            .then((context) {
                                                          _showUnBlockedSuccessSnack();
                                                        });
                                                      },
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          }
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
}
