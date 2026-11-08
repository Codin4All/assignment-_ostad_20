
import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/transaction_model.dart';
import 'edit_transaction_screen.dart';

class TransactionDetailsScreen extends StatelessWidget {
  final ExpenseTransaction transaction;

  const TransactionDetailsScreen({
    super.key,
    required this.transaction,
  });

  Future<void> deleteTransaction(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Transaction?'),
          content: const Text(
            'Are you sure you want to delete this transaction?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await DatabaseHelper.instance.deleteTransaction(
        transaction.id!,
      );

      if (!context.mounted) return;

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == 'Income';
    final color = isIncome ? Colors.green : Colors.red;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Details'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            const SizedBox(height: 20),

            Icon(
              isIncome
                  ? Icons.arrow_downward
                  : Icons.arrow_upward,
              size: 65,
              color: color,
            ),

            const SizedBox(height: 15),

            Center(
              child: Text(
                '${isIncome ? '+' : '-'}৳${transaction.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),

            const SizedBox(height: 30),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  children: [

                    detailRow('Title', transaction.title),

                    const Divider(),

                    detailRow('Amount',
                        '৳${transaction.amount.toStringAsFixed(2)}'),

                    const Divider(),

                    detailRow('Category', transaction.category),

                    const Divider(),

                    detailRow('Type', transaction.type),

                    const Divider(),

                    detailRow('Date', transaction.date),

                    const Divider(),

                    detailRow('Transaction ID',
                        transaction.id.toString()),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Edit Button
            ElevatedButton.icon(
              onPressed: () async {
                final result = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditTransactionScreen(
                      transaction: transaction,
                    ),
                  ),
                );

                if (result == true && context.mounted) {
                  Navigator.pop(context, true);
                }
              },
              icon: const Icon(Icons.edit),
              label: const Text('Edit Transaction'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(15),
              ),
            ),

            const SizedBox(height: 12),

            // Delete Button
            ElevatedButton.icon(
              onPressed: () => deleteTransaction(context),
              icon: const Icon(Icons.delete),
              label: const Text('Delete Transaction'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget detailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 15,
            ),
          ),

          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
