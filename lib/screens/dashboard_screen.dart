
import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/transaction_model.dart';
import '../widgets/summary_card.dart';
import '../widgets/transaction_item.dart';

import 'add_transaction_screen.dart';
import 'transaction_details_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  List<ExpenseTransaction> transactions = [];

  double totalIncome = 0;
  double totalExpense = 0;
  double currentBalance = 0;

  @override
  void initState() {
    super.initState();
    loadTransactions();
  }

  // Load Transactions from Database
  Future<void> loadTransactions() async {
    final data =
        await DatabaseHelper.instance.getAllTransactions();

    double income = 0;
    double expense = 0;

    for (var transaction in data) {
      if (transaction.type == 'Income') {
        income += transaction.amount;
      } else {
        expense += transaction.amount;
      }
    }

    if (!mounted) return;

    setState(() {
      transactions = data;
      totalIncome = income;
      totalExpense = expense;
      currentBalance = income - expense;
    });
  }

  // Open Add Screen
  Future<void> openAddScreen() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => const AddTransactionScreen(),
      ),
    );

    if (result == true) {
      loadTransactions();
    }
  }

  // Open Details Screen
  Future<void> openDetails(
      ExpenseTransaction transaction) async {

    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionDetailsScreen(
          transaction: transaction,
        ),
      ),
    );

    if (result == true) {
      loadTransactions();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Expense Tracker',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const SizedBox(height: 15),

          // Summary Cards
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),

            child: Row(
              children: [

                SummaryCard(
                  title: 'Total Income',
                  amount: totalIncome,
                  color: Colors.green,
                  icon: Icons.account_balance_wallet,
                ),

                SummaryCard(
                  title: 'Total Expense',
                  amount: totalExpense,
                  color: Colors.red,
                  icon: Icons.money_off,
                ),

                SummaryCard(
                  title: 'Balance',
                  amount: currentBalance,
                  color: Colors.indigo,
                  icon: Icons.account_balance,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Recent Transactions Heading
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),

            child: Text(
              'Recent Transactions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Transaction List
          Expanded(
            child: transactions.isEmpty
                ? const Center(
                    child: Text(
                      'No transactions found.\nAdd your first transaction!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  )

                : ListView.builder(
                    itemCount: transactions.length,

                    itemBuilder: (context, index) {
                      final transaction = transactions[index];

                      return TransactionItem(
                        transaction: transaction,

                        onTap: () {
                          openDetails(transaction);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),

      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: openAddScreen,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
