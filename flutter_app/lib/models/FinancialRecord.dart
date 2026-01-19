import 'package:cloud_firestore/cloud_firestore.dart';

class FinancialRecord{
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final bool isAddition;
  final double balanceAfter;

  FinancialRecord({
    this.id='',
    required this.title,
    required this.amount,
    required this.date,
    required this.isAddition,
    required this.balanceAfter,
  });

  static FinancialRecord fromDocument(
      QueryDocumentSnapshot<Map<String, dynamic>> doc,
      ) {
    final data = doc.data();
    return FinancialRecord(
      id: doc.id,
      title: data['title'] ?? '',
      amount: ((data['amount'] as num).toDouble())*10,
      date: (data['date'] as Timestamp).toDate(),
      isAddition: data['isAddition'] ?? false,
      balanceAfter: ((data['balanceAfter'] as num? ?? 0.0).toDouble()) * 10,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'amount': amount/10,
      'date': Timestamp.fromDate(date),
      'isAddition': isAddition,
      'balanceAfter': balanceAfter / 10,
    };
  }



}