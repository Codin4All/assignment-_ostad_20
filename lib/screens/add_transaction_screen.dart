import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../database/database_helper.dart';
import '../models/transaction_model.dart';

class AddTransactionScreen extends StatefulWidget {
  final ExpenseTransaction? transaction;

  const AddTransactionScreen({super.key, this.transaction});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final amountController = TextEditingController();

  String? selectedCategory;
  String? selectedType;
  DateTime selectedDate = DateTime.now();

  final List<String> incomeCategories = [
    'Salary',
    'Business',
    'Freelance',
    'Gift',
    'Other',
  ];

  final List<String> expenseCategories = [
    'Food',
    'Transport',
    'Shopping',
    'Education',
    'Bills',
    'Health',
    'Entertainment',
    'Other',
  ];

  @override
  void initState() {
    super.initState();

    final transaction = widget.transaction;

    if (transaction != null) {
      titleController.text = transaction.title;
      amountController.text = transaction.amount.toString();
      selectedCategory = transaction.category;
      selectedType = transaction.type;
      selectedDate = DateTime.parse(transaction.date);
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }

  Future<void> pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  Future<void> saveTransaction() async {
    if (selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select transaction type')),
      );
      return;
    }

    final transaction = ExpenseTransaction(
      id: widget.transaction?.id,
      title: titleController.text.trim(),
      amount: double.parse(amountController.text.trim()),
      category: selectedCategory!,
      type: selectedType!,
      date: DateFormat('yyyy-MM-dd').format(selectedDate),
    );

    if (widget.transaction == null) {
      await DatabaseHelper.instance.insertTransaction(transaction);
    } else {
      await DatabaseHelper.instance.updateTransaction(transaction);
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.transaction == null
              ? 'Transaction Added Successfully'
              : 'Transaction Updated Successfully',
        ),
      ),
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final categories = selectedType == 'Income'
        ? incomeCategories
        : expenseCategories;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.transaction == null ? 'Add Transaction' : 'Edit Transaction',
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: _formKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const Text('Transaction Title'),

              const SizedBox(height: 8),

              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: 'Enter title',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Title cannot be empty';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Amount
              const Text('Amount'),

              const SizedBox(height: 8),

              TextFormField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  hintText: 'Enter amount',
                  prefixText: '৳ ',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.money),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Amount is required';
                  }

                  final amount = double.tryParse(value.trim());

                  if (amount == null || !amount.isFinite || amount <= 0) {
                    return 'Enter a valid positive amount';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Transaction Type
              const Text('Transaction Type'),

              RadioGroup<String>(
                groupValue: selectedType,
                onChanged: (value) {
                  setState(() {
                    selectedType = value;
                    selectedCategory = null;
                  });
                },
                child: Column(
                  children: [
                    RadioListTile<String>(
                      title: const Text('Income'),
                      value: 'Income',
                    ),
                    RadioListTile<String>(
                      title: const Text('Expense'),
                      value: 'Expense',
                    ),
                  ],
                ),
              ),

              if (selectedType == null)
                const Text(
                  'Please select transaction type',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),

              const SizedBox(height: 15),

              // Category
              const Text('Category'),

              const SizedBox(height: 8),

              DropdownButtonFormField<String>(
                initialValue: selectedCategory,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Select category',
                  prefixIcon: Icon(Icons.category),
                ),

                items: categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),

                onChanged: selectedType == null
                    ? null
                    : (value) {
                        setState(() {
                          selectedCategory = value;
                        });
                      },

                validator: (value) {
                  if (value == null) {
                    return 'Please select category';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Date
              const Text('Transaction Date'),

              const SizedBox(height: 8),

              InkWell(
                onTap: pickDate,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),

                  child: Row(
                    children: [
                      const Icon(Icons.calendar_month),
                      const SizedBox(width: 12),
                      Text(DateFormat('dd MMM yyyy').format(selectedDate)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 50,

                child: ElevatedButton(
                  onPressed: saveTransaction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    widget.transaction == null
                        ? 'Save Transaction'
                        : 'Update Transaction',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
