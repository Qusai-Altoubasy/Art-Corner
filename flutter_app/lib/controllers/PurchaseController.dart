import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/Purchase.dart';
import 'controllers.dart';

class PurchaseController {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'purchase';

  List<Purchase> purchases = [];

  Future<void> purchaseProduct({
    required String name,
    required int qty,
    required double salePrice,
    required double purchasePrice,
    required bool isNew,
  }) async
  {

    var prod = await AppController.warehouseController.fetchProduct(name);

    if (prod == null && !isNew) {
      throw Exception('هاض الكرت جديد');
    }

    if (prod == null) {
      await _firestore.collection('products').add({
        'name': name,
        'price': salePrice/10,
        'purchasePrice': purchasePrice/10,
        'quantity': qty,
      });
    } else {
      await AppController.warehouseController.updateQuantity(
        product: prod,
        newQuantity: prod.quantity + qty,
      );
    }

    double finalPurchasePrice =
    isNew ? purchasePrice : prod!.purchasePrice;

    await _firestore.collection(_collection).add(
      Purchase(
        name: name,
        quantity: qty,
        purchasePrice: finalPurchasePrice * qty / 100,
        date: DateTime.now(),
      ).toFirestore(),
    );
  }

  Future<void> fetchTodayPurchases() async {
    DateTime now = DateTime.now();
    DateTime start = DateTime(now.year, now.month, now.day);
    DateTime end = start.add(const Duration(days: 1));

    final snapshot = await _firestore
        .collection(_collection)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('date', isLessThan: Timestamp.fromDate(end))
        .orderBy('date', descending: true)
        .get();

    purchases = snapshot.docs.map(Purchase.fromDocument).toList();
  }

  Future<void> retrievePurchase(Purchase purchase) async {

    final prod = await AppController.warehouseController.fetchProduct(purchase.name);

    if (prod == null) {
      throw Exception('الكرت غير موجود بالمستودع');
    }

    final int newQty = prod.quantity - purchase.quantity;
    if (newQty < 0) {
      throw Exception('لا يمكن حذف العملية لأن الكمية الحالية أقل من كمية الشراء');
    }

    await AppController.warehouseController.updateQuantity(
      product: prod,
      newQuantity: newQty,
    );

    await _firestore.collection(_collection).doc(purchase.id).delete();

  }

  Future<List<Purchase>> fetchPurchasesByDate(DateTime start, DateTime end) async {
    final snapshot = await _firestore
        .collection(_collection)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('date', isLessThan: Timestamp.fromDate(end))
        .orderBy('date')
        .get();

    return snapshot.docs.map(Purchase.fromDocument).toList();
  }


}
