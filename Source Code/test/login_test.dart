// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
// import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:odysseusrecipes/functions/accountHelpers.dart';
import 'package:odysseusrecipes/screens/Home.dart';
import 'package:odysseusrecipes/screens/LoginScreen.dart';
import 'package:odysseusrecipes/screens/Root.dart';

/* Testing credentials. */
const String TESTINGEMAIL = "dpalencia2112@gmail.com";
const String TESTINGPASSWORD = "Recipe!";


void main() {
  testWidgets('Root is a stateful widget', (WidgetTester tester) async {
    // Get a reference to the root stateful widget
    final Root root = Root(); 

    // No users are logged in initially.
    // Expect a login screen.
    expect(find.byType(LoginScreen), findsOneWidget);

    // Get a reference to a state.
    final RootState rootState = root.createState();

    // Log a user in.
    login(rootState, TESTINGEMAIL, TESTINGPASSWORD);

    // Trigger a rebuild in the environment.
    await tester.pumpAndSettle();

    // Now we should see a Home widget in the tree.
    expect(find.byType(Home), findsOneWidget); // Find the home widget.
    expect(find.byType(LoginScreen), findsNothing); // There should not be a login screen.
    

  });
}

