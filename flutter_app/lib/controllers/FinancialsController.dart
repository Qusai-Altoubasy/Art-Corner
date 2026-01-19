import 'package:art_corner/models/FinancialRecord.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FinancialsController{

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'financialRecords';

  List<FinancialRecord> financialRecords = [];
  double totalBalance = 0;

  Future<void> fetchFinancial() async {
    final mainDoc = await _firestore.collection('financials').doc('main').get();
    if (mainDoc.exists) {
      totalBalance = (mainDoc.data()?['totalBalance'] as num? ?? 0.0).toDouble() * 10;
    }

    DateTime now = DateTime.now();
    DateTime threeDaysAgo = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 3));

    final snapshot = await _firestore
        .collection(_collection)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(threeDaysAgo))
        .orderBy('date', descending: true)
        .get();

    financialRecords = snapshot.docs.map(FinancialRecord.fromDocument).toList();

  }

  Future<void> addTransaction(String title, double amount, bool isAddition, DateTime time) async {

    double newBalanceAfter = isAddition
        ? totalBalance + amount
        : totalBalance - amount;

    FinancialRecord newRecord = FinancialRecord(
      title: title,
      amount: amount,
      date: time,
      isAddition: isAddition,
      balanceAfter: newBalanceAfter,
    );

    await _firestore.collection(_collection).add(newRecord.toFirestore());

    double change = isAddition ? (amount / 10) : -(amount / 10);
    await _firestore.collection('financials').doc('main').update({
      'totalBalance': FieldValue.increment(change)
    });

    await fetchFinancial();
  }

  Future<void> removeTransaction(double amount, DateTime time) async {

    final snapshot = await _firestore
        .collection(_collection)
        .where('date', isEqualTo: Timestamp.fromDate(time))
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      String docId = snapshot.docs.first.id;

      await _firestore.collection(_collection).doc(docId).delete();

      double change = (amount / 10);
      await _firestore.collection('financials').doc('main').update({
        'totalBalance': FieldValue.increment(change)
      });

    }
  }

  Future<List<FinancialRecord>> fetchFinancialsByDate(DateTime startDate, DateTime endDate) async {

    final snapshot = await _firestore
        .collection(_collection)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where('date', isLessThan: Timestamp.fromDate(endDate))
        .orderBy('date', descending: false)
        .get();

    return snapshot.docs.map(FinancialRecord.fromDocument).toList();
  }

  Future<void> removeTransactionByTime(DateTime time, double amount, bool wasAddition) async {
    final snapshot = await _firestore
        .collection(_collection)
        .where('date', isEqualTo: Timestamp.fromDate(time))
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      await _firestore.collection(_collection).doc(snapshot.docs.first.id).delete();

      double change = wasAddition ? -(amount / 10) : (amount / 10);

      await _firestore.collection('financials').doc('main').update({
        'totalBalance': FieldValue.increment(change)
      });

      await fetchFinancial();
    }
  }
}