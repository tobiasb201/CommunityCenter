import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/pages/accountPage.dart';
import 'package:flutterapp/pages/homepage.dart';

import 'newMessage.dart';

class Navbar extends StatefulWidget {
  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _selectedIndex = 1;
  List<Widget> _widgetOptions = <Widget>[//Selectable Pages
    AccountPage(),
    Homepage(),
    newMessage(),
  ];

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: CurvedNavigationBar(
          buttonBackgroundColor: Colors.white,
          height: 50,
          items: <Widget>[
            Icon(Icons.account_box_outlined),
            Icon(Icons.home),
            Icon(Icons.add_box_outlined),
          ],
          onTap: _onTap,
          index: 1,
          animationDuration: Duration(milliseconds: 300),
        )
    );
  }
}