import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rnj_jewellers/pages/add_product_page.dart';
import 'package:rnj_jewellers/pages/category.dart';
import 'package:rnj_jewellers/pages/delete_user.dart';
import 'package:rnj_jewellers/pages/forgot_password_page.dart';
import 'package:rnj_jewellers/pages/login_page.dart';
import 'package:rnj_jewellers/pages/order_page.dart';
import 'package:rnj_jewellers/pages/search.dart';
import 'package:rnj_jewellers/pages/dashboard_page.dart';
import 'package:rnj_jewellers/pages/register_page.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:rnj_jewellers/pages/search_page.dart';
import 'package:rnj_jewellers/pages/smith_page.dart';
import 'package:rnj_jewellers/pages/home_page.dart';
import 'package:rnj_jewellers/pages/splash_page.dart';
import 'package:rnj_jewellers/pages/user_list_page.dart';
//import 'package:search_page/search_page.dart';
//import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

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
    } catch (e) {
      print(e);
    }
  }

  // void _showUserData() async {
  // final prefs = await SharedPreferences.getInstance();
  // var storedUser = prefs.getString('email');
  // if(storedUser != null){
  //   setState(() {
  //     _email = storedUser;
  //   });
  // }
  // print(_email);
  // }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      routes: {
        '/dashboard': (BuildContext context) => DashboardPage(),
        '/login': (BuildContext context) => LoginPage(),
        '/register': (BuildContext context) => RegisterPage(),
        '/addproduct': (BuildContext context) => AddProductPage(),
        '/userslist': (BuildContext context) => UserListPage(),
        '/deleteuser': (BuildContext context) => DeleteUserPage(),
        '/addcategory': (BuildContext context) => CategoryPage(),
        '/addsmithdetails': (BuildContext context) => SmithPage(),
        //'/search': (BuildContext context) => SearchPage(),
        '/search': (BuildContext context) => Search(),
        '/order': (BuildContext context) => OrderPage(),
        '/forgotpassword': (BuildContext context) => ForgotPasswordPage(),
        '/home': (BuildContext context) => HomePage(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: const Color(0xFFceab3d),
          accentColor: const Color(0xFF1e322d),
          cursorColor: Colors.white,
          textTheme: TextTheme(
            headline1: TextStyle(fontSize: 60.0, fontWeight: FontWeight.bold),
            subtitle2: TextStyle(fontSize: 36.0, fontStyle: FontStyle.normal),
            bodyText1: TextStyle(fontSize: 18.0),
          ),
          ),
      home: loggedInUser != null ? HomePage() : SplashScreen(),
    );
  }
}
