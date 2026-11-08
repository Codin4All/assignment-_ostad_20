import 'package:flutter/material.dart';

import '../models/transaction_model.dart';
import 'add_transaction_screen.dart';

class EditTransactionScreen extends StatelessWidget {
  final ExpenseTransaction transaction;

  const EditTransactionScreen({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return AddTransactionScreen(
      transaction: transaction,
    );
  }
}