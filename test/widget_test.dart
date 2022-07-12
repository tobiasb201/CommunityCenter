// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutterapp/main.dart';
import 'package:flutterapp/models/messageModel.dart';
import 'package:flutterapp/pages/newTopic.dart';
import 'package:flutterapp/service/messageService.dart';
import 'package:hive_flutter/adapters.dart';

void main() {

  Box topicsBox;

  setUpAll(() async {
    HttpOverrides.global = _HttpOverrides();
  });

  testWidgets('Found 0 Messages', (WidgetTester tester) async {

    await tester.runAsync(() => Hive.initFlutter());
    await tester.runAsync(() => Hive.openBox('topics'));
    topicsBox = Hive.box("topics");
    await tester.pumpWidget(const MyApp());
    final button1 = find.widgetWithText(ElevatedButton, "Main");
    final button2 = find.widgetWithText(ElevatedButton, "Student");
    final button3 = find.widgetWithText(ElevatedButton, "Hobby");
    final button4 = find.widgetWithText(ElevatedButton, "Work");
    expect(button1, findsOneWidget);
    expect(button2, findsOneWidget);
    expect(button3, findsOneWidget);
    expect(button4, findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

  });

  test("Load Messages from Main topic if Database not empty", () async {
    List<MessageModel> loadMessages;
    loadMessages = await MessageService().getMessages("Main");
    expect(loadMessages,isNotNull);
  });

  testWidgets("Cards displayed when Message is loaded", (WidgetTester tester) async{
    await tester.pumpWidget(const MyApp());
    await Future.delayed(const Duration(seconds: 2));
    await tester.pump();
    expect(find.byType(Card), findsWidgets);
  });

  testWidgets("Display new Button when new Topic created", (WidgetTester tester) async{
    await tester.runAsync(() => Hive.initFlutter());
    await tester.runAsync(() => Hive.openBox('topics'));
    topicsBox = Hive.box("topics");
    await tester.pumpWidget(const MaterialApp(home: NewTopic()));
    await tester.enterText(find.byType(TextField), "Crypto");
    await tester.tap(find.byType(IconButton));
    await tester.pumpWidget(const MyApp());
    expect(find.widgetWithText(ElevatedButton, 'Crypto'), findsOneWidget);
  });

}

class _HttpOverrides extends HttpOverrides{ //For loading Messages
}

