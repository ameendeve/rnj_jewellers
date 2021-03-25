import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

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
    //print(_email);
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

      Widget _showAddress() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Container(
        child: Column(
          children: [
            Text("N0.605, Ponnaiyarajapuram, Main Road", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16.0),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text("Near RS Puram, Gandhi Park", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16.0),),
            SizedBox(
              height: 5.0,
            ),
            Text("Coimbatore, Tamil Nadu", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16.0),),
            SizedBox(
              height: 5.0,
            ),
            Text("Pincode - 641001", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16.0),)
          ],
        ),
      ),
    );
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
              Navigator.popAndPushNamed(context, '/dashboard');
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
              ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
            title: Text("Search", style: TextStyle(fontSize: 15.0)),
            leading: Icon(Icons.search),
            onTap: () {
              Navigator.popAndPushNamed(context, '/search');
            },
          ),

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


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Home Page"),
          centerTitle: true,
        ),
        drawer: Container(
        width: 250,
        child: Drawer(
            elevation: 8,
            child: ListView(
              children: [_drawerHeader(), _drawerMenu()],
            )),
      ),
        body: Container(
          color: Theme.of(context).accentColor,
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _showTitle(),
              _showAddress()

            ],
          )),
        ),
      ),
    );
  }
}
