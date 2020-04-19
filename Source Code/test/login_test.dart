// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
// import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:odysseusrecipes/main.dart';
import 'package:odysseusrecipes/screens/Home.dart';
import 'package:odysseusrecipes/screens/LoginScreen.dart';


/* Testing credentials. */


void main() {

  testWidgets('Widget tests for login/logout', (WidgetTester tester) async {
    String testingEmail = "dpalencia2112@gmail.com";
    String testingPassword = "Recipe!";
    // Get a reference to the root stateful widget
    // Build the widget in the test environment.
    await tester.pumpWidget(OdysseusApp());

    // No users are logged in initially.
    // Expect a login screen.
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byKey(Key("emailInput")), findsOneWidget);
    expect(find.byKey(Key("passwordInput")), findsOneWidget);
    expect(find.byKey(Key("loginButton")), findsOneWidget);

    // Trigger a rebuild in the environment.
    await tester.enterText(find.byKey(Key("emailInput")), testingEmail);
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(Key("passwordInput")), testingPassword);
    await tester.pumpAndSettle();

    expect(find.text(testingEmail), findsOneWidget);
    expect(find.text(testingPassword), findsOneWidget);
    await tester.tap(find.byKey(Key("loginButton")));
    await tester.pumpAndSettle();

    // Now we should see a Home widget in the tree.
    // TODO: Look for the stateful re-render that gives us the homepage.

    //expect(find.byType(LoginScreen), findsNothing); // There should not be a login screen.
    //expect(find.byType(Home), findsOneWidget); // Find the home widget.

  });
}

