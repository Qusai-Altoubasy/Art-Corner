import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/Product.dart';

class WarehouseController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'products';

  List<Product> products = [];

  Future<void> fetchProducts() async {
    final snapshot = await _firestore
        .collection(_collection)
        .orderBy('quantity')
        .get();

    products=  snapshot.docs
        .map(Product.fromDocument)
        .toList();
  }

  Future<Product?> fetchProduct(String name) async
  {
    final snapshot = await _firestore
        .collection(_collection)
        .where('name',isEqualTo: name)
        .get();
    if (snapshot.docs.isNotEmpty) {
      return Product.fromDocument(snapshot.docs.first);
    }
    return null;
  }

  Future<void> updatePrice({
    required String productId,
    required double newPrice,
  }) async
  {
    await _firestore
        .collection(_collection)
        .doc(productId)
        .update({'price': newPrice/10});
  }

  Future<void> updatePurchasePrice({
    required String productId,
    required double newPrice,
  }) async
  {
    await _firestore
        .collection(_collection)
        .doc(productId)
        .update({'purchasePrice': newPrice/10});
  }

  Future<void> updateQuantity({
    required Product product,
    required int newQuantity,
  }) async
  {
    await _firestore
        .collection(_collection)
        .doc(product.id)
        .update({'quantity': newQuantity});
  }

  Future<double> price (String name, int qty, bool isGomla,bool isGomlawithprint,bool isMfraq) async
  {

    final prod = await fetchProduct(name);

    if (prod == null) {
      throw Exception('الكرت غير موجود');
    }

    double p=0;
    if(isGomla){
      p=((prod.price/2)*qty/100);
    }
    else if(isGomlawithprint){
      p=(((prod.price/2)*qty/100)+((1*qty/100).ceilToDouble()));
    }
    else{
      p=(prod.price*qty/100);
    }

    return p;

  }

}

