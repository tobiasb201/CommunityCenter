import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterapp/pages/AccountPage.dart';
import 'package:hive_flutter/adapters.dart';

void main() {

  Box usernameBox;

  testWidgets("Create Username", (WidgetTester tester) async {
    await tester.runAsync(() => Hive.initFlutter());
    await tester.runAsync(() => Hive.openBox('username'));
    usernameBox = Hive.box("username");
    await tester.pumpWidget(const MaterialApp(home: AccountPage()));
    await tester.enterText(find.byType(TextFormField), "tobiasTestUser");
    await tester.tap(find.byType(IconButton));

    expect(usernameBox.get('username'),isNotNull);
  });

  testWidgets("Create Username with Validation exception", (WidgetTester tester) async{
    await tester.runAsync(() => Hive.initFlutter());
    await tester.runAsync(() => Hive.openBox('username'));
    usernameBox = Hive.box("username");
    usernameBox.put('username', null);
    await tester.pumpWidget(const MaterialApp(home: AccountPage()));
    await tester.enterText(find.byType(TextFormField), "tobias@test.de");
    await tester.tap(find.byType(IconButton));

    expect(usernameBox.get('username'),isNull);
  });

}

