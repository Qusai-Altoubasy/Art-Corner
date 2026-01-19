import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  double price;
  double purchasePrice;
  int quantity;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.purchasePrice,
  });

  static Product fromDocument (
      QueryDocumentSnapshot<Map<String, dynamic>> doc,
      )
  {
    final data = doc.data();

    return Product(
      id: doc.id,
      name: data['name'] ?? '',
      price: ((data['price'] as num).toDouble())*10,
      quantity: data['quantity'] ?? 0,
      purchasePrice: ((data['purchasePrice'] as num).toDouble())*10,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'price': price/10,
      'quantity': quantity,
      'purchasePrice': purchasePrice/10,
    };
  }

}
