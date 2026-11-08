
class ExpenseTransaction {
  final int? id;
  final String title;
  final double amount;
  final String category;
  final String type;
  final String date;

  ExpenseTransaction({
    this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.type,
    required this.date,
  });

  // Convert Object to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'category': category,
      'type': type,
      'date': date,
    };
  }

  // Convert Map to Object
  factory ExpenseTransaction.fromMap(
      Map<String, dynamic> map) {
    return ExpenseTransaction(
      id: map['id'],
      title: map['title'],
      amount: (map['amount'] as num).toDouble(),
      category: map['category'],
      type: map['type'],
      date: map['date'],
    );
  }
}
