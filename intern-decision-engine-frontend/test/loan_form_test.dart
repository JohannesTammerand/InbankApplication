import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inbank_frontend/widgets/loan_form.dart';
import 'package:inbank_frontend/resources/countries.dart';

void main() {
  testWidgets('LoanForm displays the form and initial values',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: Column(
        children: const [LoanForm()],
      ),
    )));
    // Verify the form and initial values are displayed
    expect(find.text('Loan Amount: 2500 €'), findsOneWidget);
    expect(find.text('Loan Period: 36 months'), findsOneWidget);
    expect(find.text('Approved Loan Amount: -- €'), findsOneWidget);
    expect(find.text('Approved Loan Period: -- months'), findsOneWidget);
    expect(find.text('Estonia'), findsOneWidget);

    // Verify sliders and dropdown menu are displayed
    expect(find.byType(Slider), findsNWidgets(2));
    expect(find.byType(DropdownButton<String>), findsOneWidget);
  });

  // Test the slider behavior for loan amount
  testWidgets('LoanForm slider changes the loan amount',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: Column(
        children: const [LoanForm()],
      ),
    )));
    final Slider slider = tester.widget(find.byType(Slider).first);
    const double newValue = 2500;

    // Perform slider interaction
    await tester.drag(find.byType(Slider).first, const Offset(10.0, 0));
    await tester.pumpAndSettle();

    // Verify slider value changed
    expect(slider.value, newValue);
  });

  // Test the slider behavior for loan period
  testWidgets('LoanForm slider changes the loan period',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: Column(
        children: const [LoanForm()],
      ),
    )));
    final Slider slider = tester.widget(find.byType(Slider).last);
    const double newValue = 36;

    // Perform slider interaction
    await tester.drag(find.byType(Slider).last, const Offset(10.0, 0));
    await tester.pumpAndSettle();

    // Verify slider value changed
    expect(slider.value, newValue);
  });

  testWidgets('LoanForm dropdown changes the selected country',
    (WidgetTester tester) async {
  await tester.pumpWidget(MaterialApp(
      home: Scaffold(
    body: Column(
      children: const [LoanForm()],
    ),
  )));

  final dropdownFinder = find.byType(DropdownButton<String>);
  
  DropdownButton<String> dropdown = tester.widget(dropdownFinder);
  expect(dropdown.value, countries.first);

  await tester.tap(dropdownFinder);
  await tester.pumpAndSettle();

  final newCountry = countries[1];
  await tester.tap(find.text(newCountry).last);
  await tester.pumpAndSettle();

  dropdown = tester.widget(dropdownFinder);
  expect(dropdown.value, newCountry);
});
}
