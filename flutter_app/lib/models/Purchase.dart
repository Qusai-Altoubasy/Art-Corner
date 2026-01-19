import 'package:cloud_firestore/cloud_firestore.dart';

class Purchase {
  final String id;
  final String name;
  final int quantity;
  final double purchasePrice;
  final DateTime date;

  Purchase({
    this.id = '',
    required this.name,
    required this.quantity,
    required this.purchasePrice,
    required this.date,
  });

  static Purchase fromDocument(
      QueryDocumentSnapshot<Map<String, dynamic>> doc,
      )
  {
    final data = doc.data();

    return Purchase(
      id: doc.id,
      name: data['name'],
      quantity: data['quantity'],
      purchasePrice: ((data['purchasePrice'] as num).toDouble())*10,
      date: (data['date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'quantity': quantity,
      'purchasePrice': purchasePrice/10,
      'date': Timestamp.fromDate(date),
    };
  }
}
