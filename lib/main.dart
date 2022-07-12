import 'package:flutter/material.dart';
import 'package:flutterapp/pages/navbar.dart';
import 'package:hive_flutter/adapters.dart';

Future<void> main() async {
  await Hive.initFlutter();
  await Hive.openBox("username");
  await Hive.openBox("topics");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CommunityCenter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Navbar());
  }
}
