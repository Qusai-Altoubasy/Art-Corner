import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/Sale.dart';
import 'controllers.dart';

class FacebookPurchaseController {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'facebook';

  List<Sale> sales = [];

  Future<void> fetchSales() async {
    final snapshot = await _firestore
        .collection(_collection)
        .get();

    sales=  snapshot.docs
        .map(Sale.fromDocument)
        .toList();
  }

  Future<double> saleProducts(
      String name,
      int qty,
      double discount,
      double manualPrice
      ) async
  {

    var prod = await AppController.warehouseController.fetchProduct(name);

    if (prod == null) {
      throw Exception('ما عنا من هاض الكرت يا غالي اتأكد بالله من الرقم');
    }

    if(prod.quantity < qty){
      throw Exception('ما عنا هالقد من هاض الكرت');
    }

    double p=0;
    if(manualPrice > 0) {
      p = (manualPrice * qty/100) - discount;
    }else {
      p=(prod.price*qty/100)-discount;
    }

    double pp=prod.purchasePrice*qty/100;
    DateTime operationTime = DateTime.now();

    Sale sale = Sale(
      name: name,
      quantity: qty,
      price: p,
      discount: discount,
      date: operationTime,
      purchasePrice: pp,
    );
    if(manualPrice > 0){
      await _firestore.collection('facebookQuran').add(sale.toFirestore());
    }
    else {
      await _firestore.collection(_collection).add(sale.toFirestore());
    }

    await AppController.warehouseController.updateQuantity(
      product: prod,
      newQuantity: prod.quantity-qty,
    );

    AppController.financialsController.addTransaction(
        '$name : $qty',
        pp,
        false,
        operationTime
    );

    return p;
  }

  Future<void> fetchLastWeekSales() async {

    DateTime now = DateTime.now();
    DateTime todayStart = DateTime(now.year, now.month, now.day);

    DateTime start = todayStart.subtract(const Duration(days: 6));
    DateTime end = todayStart.add(const Duration(days: 1));

    final snapshot = await _firestore
        .collection(_collection)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('date', isLessThan: Timestamp.fromDate(end))
        .get();

    final QuranSnapshot = await _firestore
        .collection('facebookQuran')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('date', isLessThan: Timestamp.fromDate(end))
        .get();

    List<Sale> normalSales = snapshot.docs.map(Sale.fromDocument).toList();
    List<Sale> quranSales = QuranSnapshot.docs.map(Sale.fromDocument).toList();

    sales = [...normalSales, ...quranSales];

    sales.sort((a, b) => b.date.compareTo(a.date));

  }

  Future<void> retrieveSale(Sale sale)async {

    var prod = await AppController.warehouseController.fetchProduct(sale.name);

    if (prod == null) {
      throw Exception('ما عنا من هاض الكرت يا غالي اتأكد بالله من الرقم');
    }

    await AppController.warehouseController.updateQuantity(
      product: prod,
      newQuantity: prod.quantity + sale.quantity,
    );

    var docRef = _firestore.collection(_collection).doc(sale.id);
    var docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      await docRef.delete();
    }
    else{
      await _firestore.collection('facebookQuran').doc(sale.id).delete();
    }

    await AppController.financialsController.removeTransaction(
      sale.purchasePrice,
      sale.date,
    );

  }

  Future<List<Sale>> fetchSalesByDate(DateTime start, DateTime end, bool isQuran) async {
    final QuerySnapshot<Map<String, dynamic>> snapshot;
    if(isQuran){
      snapshot = await _firestore
          .collection('facebookQuran')
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
          .where('date', isLessThan: Timestamp.fromDate(end))
          .orderBy('date')
          .get();
    }
    else {
      snapshot = await _firestore
          .collection(_collection)
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
          .where('date', isLessThan: Timestamp.fromDate(end))
          .orderBy('date')
          .get();
    }

    return snapshot.docs.map(Sale.fromDocument).toList();
  }

}