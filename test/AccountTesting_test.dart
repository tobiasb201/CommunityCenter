
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterapp/main.dart';
import 'package:flutterapp/pages/AccountPage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

void main() {

  Box _usernameBox;

  testWidgets("Create Username", (WidgetTester tester) async {
    await tester.runAsync(() => Hive.initFlutter());
    await tester.runAsync(() => Hive.openBox('username'));
    _usernameBox = Hive.box("username");
    await tester.pumpWidget(const MaterialApp(home: AccountPage()));
    await tester.enterText(find.byType(TextFormField), "tobiasTestUser");
    await tester.tap(find.byType(IconButton));

    expect(_usernameBox.get('username'),isNotNull);
  });

  testWidgets("Create Username with Validation exception", (WidgetTester tester) async{
    await tester.runAsync(() => Hive.initFlutter());
    await tester.runAsync(() => Hive.openBox('username'));
    _usernameBox = Hive.box("username");
    _usernameBox.put('username', null);
    await tester.pumpWidget(const MaterialApp(home: AccountPage()));
    await tester.enterText(find.byType(TextFormField), "tobias@test.de");
    await tester.tap(find.byType(IconButton));

    expect(_usernameBox.get('username'),isNull);
  });

}

