import 'package:money_manager/model/transaction.dart';
import 'package:sqflite/sqflite.dart';

class DbTransactionHelper {
  static final DbTransactionHelper instance = DbTransactionHelper._instance();
  static Database? _db;
  DbTransactionHelper._instance();

  void _createDb(Database db, int version) async {
    await db.execute(
      'CREATE TABLE transactions(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, amount REAL, date TEXT, transcation_type TEXT, category TEXT)',
    );
  }

  Future<Database> _initDb() async {
    String path = await getDatabasesPath();
    return openDatabase(
      '$path/transactions.db',
      onCreate: _createDb,
      version: 1,
    );
  }

  Future<Database?> get db async {
    _db ??= await _initDb();
    return _db;
  }

  Future<List<Map<String, dynamic>>> getTransactionsMapList() async {
    Database? db = await this.db;
    final List<Map<String, dynamic>> result = await db!.query('transactions');
    return result;
  }

  Future<List<Map<String, dynamic>>> getTransactionsMapListByType(
      TranscationType type) async {
    Database? db = await this.db;
    final List<Map<String, dynamic>> result = await db!.query(
      'transactions',
      where: 'transcation_type = ?',
      whereArgs: [type.toString()],
    );
    return result;
  }

  Future<List<TranscationModel>> getTransactionsList() async {
    final List<Map<String, dynamic>> transactionMapList =
        await getTransactionsMapList();
    final List<TranscationModel> transactionList = [];
    for (var transactionMap in transactionMapList) {
      transactionList.add(TranscationModel.fromMap(transactionMap));
    }
    return transactionList;
  }

  Future<List<TranscationModel>> getTransactionsListByType(
      TranscationType type) async {
    final List<Map<String, dynamic>> transactionMapList =
        await getTransactionsMapListByType(type);
    final List<TranscationModel> transactionList = [];
    for (var transactionMap in transactionMapList) {
      transactionList.add(TranscationModel.fromMap(transactionMap));
    }
    return transactionList;
  }

  Future<int> insertTransaction(TranscationModel transaction) async {
    Database? db = await this.db;
    final int result = await db!.insert('transactions', transaction.toMap());
    return result;
  }

  Future<int> updateTransaction(TranscationModel transaction) async {
    Database? db = await this.db;
    return await db!.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  Future<int> deleteTransaction(int id) async {
    Database? db = await this.db;
    return await db!.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAllTransactions() async {
    Database? db = await this.db;
    return await db!.delete('transactions');
  }

  Future getSumTransactionPeriod(String start, String end) async {
    Database? db = await this.db;
    var result = await db!.query('transactions',
        columns: ['SUM(amount) as total', 'transcation_type', 'category'],
        where: 'date BETWEEN ? AND ?',
        whereArgs: [start, "$end 23:59:59"],
        groupBy: 'transcation_type, category');

    return result;
  }
}
