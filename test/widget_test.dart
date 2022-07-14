// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hackernews/main.dart';

void main() {
  testWidgets('Clicking tile opens it', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byIcon(Icons.launch), findsNothing);

    // Click on the first expansion tile
    await tester.tap(find.byType(ExpansionTile).first);
    await tester.pump(Duration(days: 9));

    expect(find.byIcon(Icons.launch), findsOneWidget);
  });
}
