import 'package:art_corner/models/Liability.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LiabilitiesController{

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'liabilities';

  List<Liability> liabilities = [];

  Future<void> fetchLiabilities() async {
    final snapshot = await _firestore
        .collection(_collection)
        .orderBy('isPaid', descending: false)
        .get();

    liabilities=  snapshot.docs
        .map(Liability.fromDocument)
        .toList();
  }

  Future<void> addLiability(String title, double amount, DateTime selectedDate)
  async {

    Liability liability = Liability(
       title: title,
        amount: amount,
        date: selectedDate
    );

    await _firestore.collection(_collection).add(liability.toFirestore());
    await fetchLiabilities();

  }

  Future<void> toggleLiabilityStatus(String id, bool currentStatus) async {
    try {
      await _firestore.collection(_collection).doc(id).update({
        'isPaid': !currentStatus,
      });
      await fetchLiabilities();
    } catch (e) {}
  }

  Future<void> deleteLiability(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
      await fetchLiabilities();
    } catch (e) {}
  }

}