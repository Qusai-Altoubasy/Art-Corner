import 'package:cloud_firestore/cloud_firestore.dart';

class Liability{
  final String id;
  final String title;
  double amount;
  DateTime date;
  bool isPaid;

  Liability({
    this.id = '',
    required this.title,
    required this.amount,
    required this.date,
    this.isPaid = false,
  });

  static Liability fromDocument(
      QueryDocumentSnapshot<Map<String, dynamic>> doc,
      ) {
    final data = doc.data();
    return Liability(
      id: doc.id,
      title: data['title'] ?? '',
      amount: ((data['amount'] as num).toDouble())*10,
      date: (data['date'] as Timestamp).toDate(),
      isPaid: data['isPaid'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'amount': amount/10,
      'date': Timestamp.fromDate(date),
      'isPaid': isPaid,
    };
  }

}