import 'package:art_corner/controllers/LiabilitiesController.dart';

import 'FacebookPurchaseController.dart';
import 'FinancialsController.dart';
import 'PurchaseController.dart';
import 'ReportController.dart';
import 'SaleController.dart';
import 'WarehouseController.dart';

class AppController {
  static final WarehouseController warehouseController = WarehouseController();
  static final PurchaseController purchaseController = PurchaseController();
  static final SaleController saleController = SaleController();
  static final ReportController reportController = ReportController();
  static final FacebookPurchaseController facabookPurchaseController = FacebookPurchaseController();
  static final LiabilitiesController liabilitiesController = LiabilitiesController();
  static final FinancialsController financialsController = FinancialsController();
}
