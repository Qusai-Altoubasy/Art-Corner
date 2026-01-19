import 'package:art_corner/controllers/controllers.dart';
import 'package:art_corner/models/Product.dart';
import 'package:art_corner/models/Sale.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SaleController {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'sale';

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
      bool isGomla,
      bool isGomlawithprint,
      bool isMfraq,
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
    if(manualPrice > 0){
      p = (manualPrice * qty/100) - discount;
    }else {
      if (isGomla) {
        p = ((prod.price / 2) * qty / 100) - discount;
      }
      else if (isGomlawithprint) {
        p = (((prod.price / 2) * qty / 100) +
            ((1 * qty / 100).ceilToDouble())) - discount;
      }
      else {
        p = (prod.price * qty / 100) - discount;
      }
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

    await _firestore.collection(_collection).add(sale.toFirestore());

    await AppController.warehouseController.updateQuantity(
        product: prod,
        newQuantity: prod.quantity-qty,
    );

    AppController.financialsController.addTransaction('$name : $qty'.trim(), pp, false, operationTime);

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
        .orderBy('date', descending: true)
        .get();

    sales = snapshot.docs.map(Sale.fromDocument).toList();
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

    await _firestore
        .collection(_collection)
        .doc(sale.id)
        .delete();

    await AppController.financialsController.removeTransaction(
        sale.purchasePrice,
        sale.date,
    );

  }

  Future<List<Sale>> fetchSalesByDate(DateTime start, DateTime end) async {
    final snapshot = await _firestore
        .collection(_collection)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('date', isLessThan: Timestamp.fromDate(end))
        .orderBy('date')
        .get();

    return snapshot.docs.map(Sale.fromDocument).toList();
  }

  Future<void> fetchSalesByName(String name) async {
    final snapshot = await _firestore
        .collection(_collection)
        .where('name',isEqualTo: name)
        .orderBy('date', descending: true)
        .get();

    sales=  snapshot.docs
        .map(Sale.fromDocument)
        .toList();
  }

}