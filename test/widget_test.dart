import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:assignment_ostad_20/models/transaction_model.dart';
import 'package:assignment_ostad_20/screens/edit_transaction_screen.dart';

void main() {
  testWidgets('edit screen displays the existing transaction', (
    WidgetTester tester,
  ) async {
    final transaction = ExpenseTransaction(
      id: 1,
      title: 'Groceries',
      amount: 25.5,
      category: 'Food',
      type: 'Expense',
      date: '2026-11-08',
    );

    await tester.pumpWidget(
      MaterialApp(home: EditTransactionScreen(transaction: transaction)),
    );

    expect(find.text('Edit Transaction'), findsOneWidget);

    final textFields = tester.widgetList<EditableText>(
      find.byType(EditableText),
    );
    expect(
      textFields.map((field) => field.controller.text),
      containsAll(<String>['Groceries', '25.5']),
    );
  });
}
