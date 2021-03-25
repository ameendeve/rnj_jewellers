import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rnj_jewellers/pages/product_feed_page.dart';
//import 'package:jewlry/pages/register_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardSamplePage extends StatefulWidget {
  @override
  _DashboardSamplePageState createState() => _DashboardSamplePageState();
}

class _DashboardSamplePageState extends State<DashboardSamplePage> {
  final _firestore = FirebaseFirestore.instance;
  String _email;

  @override
  void initState() {
    super.initState();
    _showUserData();
  }

  void _showUserData() async {
    final prefs = await SharedPreferences.getInstance();
    var storedUser = prefs.getString('email');
    if (storedUser != null) {
      setState(() {
        _email = storedUser;
      });
    }
    print(_email);
  }

  void _logOut() {
    final _auth = FirebaseAuth.instance;
    _auth.signOut().then((value) {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  Widget _drawerHeader() {
    return UserAccountsDrawerHeader(
      accountEmail: Text("Hello $_email"),
      accountName: Text(""),
    );
  }

  Widget _drawerMenu() {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
          title: Text(
            "Dashboard",
            style: TextStyle(fontSize: 16.0),
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
                title: Text("Add Products", style: TextStyle(fontSize: 16.0)),
                leading: Icon(Icons.add),
                onTap: () {
                  Navigator.popAndPushNamed(context, '/addproduct');
                },
              )
            : ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                title: Text(
                  "Add Products",
                  style: TextStyle(fontSize: 16.0, color: Colors.grey),
                ),
                leading: Icon(Icons.add),
                onTap: () {
                  Navigator.pop(context);
                },
              ),

        //Register Menu
        _email == "admin@gmail.com"
            ? ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                title: Text("Register", style: TextStyle(fontSize: 16.0)),
                leading: Icon(Icons.email),
                onTap: () {
                  Navigator.popAndPushNamed(context, '/register');
                },
              )
            : ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                title: Text("Register",
                    style: TextStyle(fontSize: 16.0, color: Colors.grey)),
                leading: Icon(Icons.email),
                onTap: () {
                  Navigator.pop(context);
                },
              ),

        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
          title: Text("Log out", style: TextStyle(fontSize: 16.0)),
          leading: Icon(Icons.logout),
          onTap: () {
            _logOut();
          },
        ),
      ],
    );
  }

  // Widget _searchBar() {
  //   return Padding(
  //     padding: const EdgeInsets.all(10.0),
  //     child: TextField(
  //       decoration: InputDecoration(
  //         hintText: "Search...",
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
        width: 230,
        child: Drawer(
            elevation: 8,
            child: ListView(
              children: [_drawerHeader(), _drawerMenu()],
            )),
      ),
      body: Container(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: "Search...",
                  ),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection("products").snapshots(),
                builder: (context, snapshot) {
                  final products = snapshot.data.docs;
                  return Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return Container(
                          color: Theme.of(context).primaryColor,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                                                    child: Card(
                                                      child: ListTile(
                                leading: Image.network('${products[index]['Image']}'),
                                title: Text("${products[index]['Product Name']}"),
                                subtitle:
                                    Text("${products[index]['Product Description']}"),
                                onTap: () {
                                  SingleProductFeedPage();
                                }
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}


