import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rnj_jewellers/models/datacontroller.dart';
import 'package:rnj_jewellers/pages/order_detail_page.dart';
//import 'package:jewlry/pages/dashboard_page.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {

  var firebaseUser = FirebaseAuth.instance.currentUser;

  QuerySnapshot snapshotData;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  void _showDeleteSnack() {
    final snackbar = SnackBar(
      content: Text(
        "Order Deleted",
        style: TextStyle(color: Colors.red),
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Order Page"),
        centerTitle: true,
      ),
      body: Container(
        color: Theme.of(context).accentColor,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: GetBuilder(
                    init: DataController(),
                    builder: (value) {
                      return FutureBuilder(
                        future: value.getOrder(),
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
                                  var orderSnapshot =
                                      snapshot.data[index].data();
                                  DateTime myDateTime = DateTime.parse(orderSnapshot['timestamp'].toDate().toString());
                                  String formattedDateTime = DateFormat.yMMMd().add_jm().format(myDateTime);
                                  return GestureDetector(
                                    onTap: () {
                                      Get.to(OrderDetailPage(),
                                          transition:
                                              Transition.leftToRightWithFade,
                                          arguments: snapshot.data[index]);
                                    },
                                    child: Container(
                                      width: 350,
                                      height: 170,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 15.0),
                                        child: Card(
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
                                                padding: const EdgeInsets.only(
                                                    top: 10.0),
                                                child: ListTile(
                                                  trailing: GestureDetector(
                                                    child: Icon(
                                                      Icons.delete,
                                                      color: Colors.white,
                                                    ),
                                                    onTap: () async {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .runTransaction(
                                                              (Transaction
                                                                  myTransaction) async {
                                                            myTransaction
                                                            .delete(snapshot
                                                                .data[index]
                                                                .reference);
                                                        _showDeleteSnack();
                                                        setState(() {
                                                          Navigator
                                                            .popAndPushNamed(
                                                                context,
                                                                '/order');
                                                        });
                                                      });
                                                    },
                                                  ),
                                                  leading: orderSnapshot[
                                                              'Image'] !=
                                                          null
                                                      ? ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.vertical(
                                                                  top: Radius
                                                                      .circular(
                                                                          10.0),
                                                                  bottom: Radius
                                                                      .circular(
                                                                          10.0)),
                                                          child: Image.network(
                                                            orderSnapshot[
                                                                'Image'],
                                                            height: 75,
                                                            width: 75,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        )
                                                      : Container(),
                                                  title: Padding(
                                                    padding: const EdgeInsets.only(top: 10.0),
                                                    child: Text(
                                                        "${orderSnapshot['Product Name']}",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18.0)),
                                                  ),
                                                  subtitle: Column(
                                                    children: [
                                                      Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10.0),
                                                    child: Text(
                                                        "${orderSnapshot['Smith Name']}",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15.0)),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10.0, right: 20.0),
                                                    child: Text(
                                                        "$formattedDateTime",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15.0)),
                                                  ),
                                                    ],
                                                  )
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
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
