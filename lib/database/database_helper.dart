
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/transaction_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance =
      DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDB('expense_tracker.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE transactions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            amount REAL NOT NULL,
            category TEXT NOT NULL,
            type TEXT NOT NULL,
            date TEXT NOT NULL
          )
        ''');
      },
    );
  }

  // CREATE
  Future<int> insertTransaction(
      ExpenseTransaction transaction) async {
    final db = await database;

    return await db.insert(
      'transactions',
      transaction.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // READ
  Future<List<ExpenseTransaction>>
      getAllTransactions() async {
    final db = await database;

    final result = await db.query(
      'transactions',
      orderBy: 'date DESC, id DESC',
    );

    return result
        .map((map) => ExpenseTransaction.fromMap(map))
        .toList();
  }

  // UPDATE
  Future<int> updateTransaction(
      ExpenseTransaction transaction) async {
    final db = await database;

    return await db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  // DELETE
  Future<int> deleteTransaction(int id) async {
    final db = await database;

    return await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
