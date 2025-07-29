// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dosify_flutter/core/ui/app.dart';

void main() {
  testWidgets('Dosify app loads successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DosifyApp());

    // Verify that the app loads with the dashboard.
    expect(find.text('Welcome to Dosify'), findsOneWidget);
    expect(find.text('Medications'), findsWidgets);
    expect(find.text('Calculator'), findsWidgets);
    
    // Verify navigation elements exist
    expect(find.byIcon(Icons.medication), findsWidgets);
  });
}
