import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vkool_ecommerce_test/Menu/activity_fragment.dart';
import 'package:vkool_ecommerce_test/Menu/chekout_fragment.dart';
import 'package:vkool_ecommerce_test/Menu/home_fragment.dart';
import 'package:vkool_ecommerce_test/Menu/profile_fragment.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: bottom_navigation(),
    );
  }
}

// ignore: camel_case_types
class bottom_navigation extends StatefulWidget {
  const bottom_navigation({super.key});

  @override
  State<bottom_navigation> createState() => _bottom_navigationState();
}

// ignore: camel_case_types
class _bottom_navigationState extends State<bottom_navigation> {
  int selectedIndex = 0;

  //list of widgets to call ontap
  final widgetOptions = [
    const HomeFragment(),
    ActivityFragment(),
    ProfileFragment()
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  final widgetTitle = ["Home", "Payment", "Profile"];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: widgetOptions.elementAt(selectedIndex),
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home_sharp,
                  ),
                  label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.payment,
                  ),
                  label: "Activity"),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.account_circle,
                  ),
                  label: "Profile"),
            ],
            backgroundColor: Colors.blue[400],
            currentIndex: selectedIndex,
            selectedItemColor: Color.fromARGB(255, 255, 255, 255),
            onTap: onItemTapped,
          ),
        ));
  }
}
