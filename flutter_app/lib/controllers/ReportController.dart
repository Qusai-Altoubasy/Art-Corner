import 'dart:math';

import '../models/ReportData.dart';
import 'controllers.dart';
import '../models/Sale.dart';
import '../models/Product.dart';

class ReportController{

  Future<ReportData> getSalesReport(DateTime start, DateTime end, bool isFaceBook, bool isQuran) async
  {

    List<Sale> sales;

    if(isFaceBook){
       sales= await AppController.facabookPurchaseController.fetchSalesByDate(start, end, isQuran);
    }
    else {
       sales = await AppController.saleController.fetchSalesByDate(start, end);
    }

    final total = sales.fold(0.0, (s, e) => s + e.price);
    final totalPurchase = sales.fold(0.0, (s, e) => s + e.purchasePrice);

    final rows = sales.map<List<String>>((s) => [
      s.name,
      s.quantity.toString(),
      s.price.toStringAsFixed(4),
      s.purchasePrice.toStringAsFixed(4),
    ]).toList();

    return ReportData(
      rows: rows,
      total: total,
      totalPurchase: totalPurchase,
    );
  }

  Future<ReportData> getPurchasesReport(DateTime start, DateTime end) async {

    final purchases = await AppController.purchaseController.fetchPurchasesByDate(start, end);
    final total = purchases.fold(0.0, (s, e) => s + e.purchasePrice);

    final rows = purchases.map<List<String>>((p) => [
      p.name,
      p.quantity.toString(),
      p.purchasePrice.toStringAsFixed(4),
    ]).toList();

    return ReportData(
      rows: rows,
      total: total,
      totalPurchase: 0.0,
    );
  }

  ReportData getProductReport() {

    final products = AppController.warehouseController.products;

    products.sort((a, b) {
      int priceComparison = b.price.compareTo(a.price);

      if (priceComparison != 0) {
        return priceComparison;
      } else {
        return b.purchasePrice.compareTo(a.purchasePrice);
      }
    });
    final total = products.fold(0.0, (s, e) => s + (e.purchasePrice*e.quantity/100));

    final rows = products.map<List<String>>((p) => [
      p.name,
      p.quantity.toString(),
      p.price.toStringAsFixed(4),
      p.purchasePrice.toStringAsFixed(4),
      (p.purchasePrice*p.quantity/100).toStringAsFixed(4),
    ]).toList();

    return ReportData(
      rows: rows,
      total: total,
      totalPurchase: 0.0,
    );
  }

  Future<ReportData> getFinancialReport(DateTime start, DateTime end)async{

    final financials = await AppController.financialsController.fetchFinancialsByDate(start, end);

    final rows = financials.map<List<String>>((p) => [
      "${p.date.year}-${p.date.month}-${p.date.day}",
      p.title,
      p.isAddition?'ايداع':'سحب',
      p.amount.toStringAsFixed(4),
      p.balanceAfter.toStringAsFixed(4),
    ]).toList();

    return ReportData(
      rows: rows,
      total: 0.0,
      totalPurchase: 0.0,
    );


  }

}