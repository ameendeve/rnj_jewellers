import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rnj_jewellers/pages/edit_product_page.dart';
//import 'package:rnj_jewellers/pages/dashboard_sample_page.dart';
import 'package:rnj_jewellers/pages/product_feed_page.dart';
//import 'package:rnj_jewellers/pages/register_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

String _email, _blockedUserEmail;

class DashboardPage extends StatefulWidget {
  DashboardPage({
    this.uid,
  });
  final String uid;

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

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

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    _showUserData();
    _blockUser();
  }

//String userId = FirebaseFirestore.instance.collection("blockeduser").doc().id;
  void _blockUser() async {
    await _firestore.collection('blockeduser').get().then((value) {
      value.docs.forEach((result) {
        final uid = result.data()['uid'];
        final blockedEmail = result.data()['email'];
        //print(uid);
        if (loggedInUser.uid == uid) {
          setState(() {
            _blockedUserEmail = blockedEmail;
          });
        }
      });
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
    //print(_email);
  }

  void _logOut() {
    // final prefs = await SharedPreferences.getInstance();
    // prefs.remove('email');
    final _auth = FirebaseAuth.instance;
    _auth.signOut();
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.pushReplacementNamed(context, '/login');
  }

  Widget _drawerHeader() {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        image: DecorationImage(
            image: AssetImage("images/drawerlogo.png"), fit: BoxFit.fitWidth),
      ),
      accountEmail: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Text(
          "Hello $_email",
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
        ),
      ),
      accountName: Container(),
    );
  }

  Widget _drawerMenu() {
    return Container(
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
            title: Text(
              "Dashboard",
              style: TextStyle(fontSize: 15.0),
            ),
            leading: Icon(Icons.home),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/dashboard');
            },
          ),

          //Add a Product Menu
          _email == "admin@gmail.com"
              ? ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                  title: Text("Add Product", style: TextStyle(fontSize: 15.0)),
                  leading: Icon(Icons.add),
                  onTap: () {
                    Navigator.popAndPushNamed(context, '/addproduct');
                  },
                )
              : Container(),

          _email == "admin@gmail.com"
              ? ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                  title: Text("Add Category", style: TextStyle(fontSize: 15.0)),
                  leading: Icon(Icons.add_comment),
                  onTap: () {
                    Navigator.popAndPushNamed(context, '/addcategory');
                  },
                )
              : Container(),
          _email == "admin@gmail.com"
              ? ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                  title: Text("Add Smith Details",
                      style: TextStyle(fontSize: 15.0)),
                  leading: Icon(Icons.post_add),
                  onTap: () {
                    Navigator.popAndPushNamed(context, '/addsmithdetails');
                  },
                )
              : Container(),

          //Register Menu
          _email == "admin@gmail.com"
              ? ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                  title: Text("Add User", style: TextStyle(fontSize: 15.0)),
                  leading: Icon(Icons.app_registration),
                  onTap: () {
                    Navigator.popAndPushNamed(context, '/register');
                  },
                )
              : Container(),
          _email == "admin@gmail.com"
              ? ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                  title: Text("Block User", style: TextStyle(fontSize: 15.0)),
                  leading: Icon(Icons.block),
                  onTap: () {
                    Navigator.popAndPushNamed(context, '/userslist');
                  },
                )
              : Container(),

              _email == "admin@gmail.com"
              ? ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                  title: Text("Orders", style: TextStyle(fontSize: 15.0)),
                  leading: Icon(Icons.shopping_cart),
                  onTap: () {
                    Navigator.popAndPushNamed(context, '/order');
                  },
                )
              : Container(),

              //Search Menu
             _blockedUserEmail != _email ? ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
            title: Text("Search", style: TextStyle(fontSize: 15.0)),
            leading: Icon(Icons.search),
            onTap: () {
              Navigator.popAndPushNamed(context, '/search');
            },
          ) : Container(),

          //Forgot Password
          _email == 'admin@gmail.com' ? ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
            title: Text("Password Reset", style: TextStyle(fontSize: 15.0)),
            leading: Icon(Icons.restore),
            onTap: () {
              Navigator.popAndPushNamed(context, '/forgotpassword');
            },
          ) : Container(),

          // ListTile(
          //   contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
          //   title: Text("Delete Account", style: TextStyle(fontSize: 15.0)),
          //   leading: Icon(Icons.delete),
          //   onTap: () {
          //     Navigator.popAndPushNamed(context, '/deleteuser');
          //   },
          // ),

          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
            title: Text("Log out", style: TextStyle(fontSize: 15.0)),
            leading: Icon(Icons.logout),
            onTap: () {
              _logOut();
            },
          ),
        ],
      ),
    );
  }

  // Widget _searchBar() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
  //     child: TextField(
  //       style: TextStyle(color: Colors.white),
  //       decoration: InputDecoration(
  //         prefixIcon: Icon(Icons.search, color: Theme.of(context).primaryColor),
  //         hintText: "Search...",
  //         hintStyle: TextStyle(color: Theme.of(context).primaryColor),
  //         labelStyle: new TextStyle(
  //           color: Colors.white,
  //         ),
  //         enabledBorder: UnderlineInputBorder(
  //           borderSide: BorderSide(color: Theme.of(context).primaryColor),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _logOut();
            },
          )
        ],
      ),
      drawer: Container(
        width: 250,
        child: Drawer(
            elevation: 8,
            child: ListView(
              children: [_drawerHeader(), _drawerMenu()],
            )),
      ),
      body: _blockedUserEmail == _email
          ? Container(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 200.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                    "User Blocked",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 40.0
                    ),
                  ),
                  Text(
                    "Contact Admin",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 20.0
                    ),
                  )
                    ],
                  ),
                ),
              ),
            )
          : Container(
              color: Theme.of(context).accentColor,
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      StreamBuilder<QuerySnapshot>(
                          stream: _firestore
                              .collection("products")
                              .orderBy("timestamp", descending: true)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: CircularProgressIndicator(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                ),
                              );
                            }
                            final products = snapshot.data.docs;

                            List<ProductFeed> productFeeds = [];

                            for (var product in products) {
                              final productName =
                                  product.data()['Product Name'];
                              final productCategory =
                                  product.data()['Product Category'];
                              final productDescription =
                                  product.data()['Product Description'];
                              final smithName = product.data()['Smith Name'];
                              final productImage = product.data()['Image'];
                              final id = product.data()['Document ID'];

                              final productFeed = ProductFeed(
                                  productName: productName,
                                  productCategory: productCategory,
                                  productDescription: productDescription,
                                  smithName: smithName,
                                  productImage: productImage,
                                  productId: id);
                              productFeeds.add(productFeed);
                            }
                            return Column(children: productFeeds);
                          })
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class ProductFeed extends StatelessWidget {
  ProductFeed(
      {this.productName,
      this.productCategory,
      this.productDescription,
      this.smithName,
      this.productImage,
      this.productId});
  final String productName;
  final String productCategory;
  final String productDescription;
  final String smithName;
  final String productImage;
  final String productId;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 200,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          color: Color(0xFF243c36),
          elevation: 10,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: ListTile(
                    leading: 
                    productImage != null ? ClipRRect(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(10.0),
                                bottom: Radius.circular(10.0)),
                            child: Image.network(
                              productImage,
                              height: 75,
                              width: 75,
                              fit: BoxFit.cover,
                            ),
                          ) : Container(
                            width: 80,
                            height: 100,
                            child: Card(
                              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text("No \n Image", style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500), textAlign: TextAlign.center,),
                              ))),

                    title: Text(productName,
                        style: TextStyle(color: Colors.white, fontSize: 18.0)),
                    subtitle: Text(productDescription,
                        style: TextStyle(color: Colors.white, fontSize: 15.0)),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0, left: 130.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _email == 'admin@gmail.com'
                          ? ButtonTheme(
                              minWidth: 10,
                              height: 25,
                              child: RaisedButton(
                                color: Theme.of(context).primaryColor,
                                child: Text(
                                  "Edit",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditProductPage(
                                          productId: productId,
                                          productName: productName,
                                          productCategory: productCategory,
                                          productDescription:
                                          productDescription,
                                          smithName: smithName,
                                          productImage: productImage,
                                        ),
                                      ));
                                },
                              ),
                            )
                          : Container(),
                      SizedBox(
                        width: 10.0,
                      ),
                      ButtonTheme(
                        minWidth: 10,
                        height: 25,
                        child: RaisedButton(
                          color: Theme.of(context).primaryColor,
                          child: Text(
                            "Know More",
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SingleProductFeedPage(
                                  productId: productId,
                                  productName: productName,
                                  productCategory: productCategory,
                                  productDescription: productDescription,
                                  smithName: smithName,
                                  productImage: productImage,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}