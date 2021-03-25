import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rnj_jewellers/models/datacontroller.dart';
import 'package:rnj_jewellers/pages/add_product_page.dart';
import 'package:rnj_jewellers/pages/category.dart';
import 'package:rnj_jewellers/pages/dashboard_page.dart';
import 'package:rnj_jewellers/pages/register_page.dart';
import 'package:rnj_jewellers/pages/search.dart';

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  PageController pageController = new PageController();
  DataController dataController = Get.put(DataController());
  int currentIndex = 0;

  void onTap(int page) {
    setState(() {
      currentIndex = page;
    });
    pageController.jumpToPage(page);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        controller: pageController,
        children: [DashboardPage(), AddProductPage(), CategoryPage(), RegisterPage(), Search()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTap,
        backgroundColor: Theme.of(context).primaryColor,
        selectedIconTheme: IconThemeData(color: Theme.of(context).accentColor),
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: 'Dashboard'  ),
          BottomNavigationBarItem(
              icon: Icon(Icons.add), label: 'Product'  ),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_comment), label: 'Category' ),
          BottomNavigationBarItem(
              icon: Icon(Icons.email), label: 'Add user'),
          BottomNavigationBarItem(
              icon: Icon(Icons.search), label: 'Search'  )        
          
        ],
      ),
    );
  }
}













