import 'package:cloud_firestore/cloud_firestore.dart';

class Sale{
  final String id;
  final String name;
  final int quantity;
  final double price;
  final double purchasePrice;
  final double discount;
  final DateTime date;

  Sale({
    this.id='dd',
    required this.name,
    required this.quantity,
    required this.price,
    required this.purchasePrice,
    required this.discount,
    required this.date
  });

  static Sale fromDocument (
      QueryDocumentSnapshot<Map<String, dynamic>> doc,
      )
  {
    final data = doc.data();

    Timestamp timestamp = data['date'];
    DateTime fullDate = timestamp.toDate();

    return Sale(
      id: doc.id,
      name: data['name'] ?? '',
      quantity: data['quantity'] ?? 0,
      price: ((data['price'] as num).toDouble())*10,
      date:fullDate,
      discount: (data['discount'] as num).toDouble(),
      purchasePrice: ((data['purchasePrice'] as num).toDouble())*10,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'quantity': quantity,
      'discount': discount,
      'price': price/10,
      'date': Timestamp.fromDate(date),
      'purchasePrice': purchasePrice/10,
    };
  }




}