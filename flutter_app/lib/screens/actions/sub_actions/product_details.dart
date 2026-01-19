import 'package:art_corner/controllers/controllers.dart';
import 'package:art_corner/models/Product.dart';
import 'package:art_corner/screens/actions/sub_actions/product_purchases.dart';
import 'package:art_corner/shared/shared.dart';
import 'package:flutter/material.dart';

import '../../../components/components.dart';

class ProductDetails extends StatefulWidget {

  final Product product;

  const ProductDetails({super.key, required this.product});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  var salePrice = TextEditingController();
  var purchasePrice = TextEditingController();
  var qty = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        backgroundColor: burgundyDark,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  burgundyDark,
                  burgundyMid,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 12,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.insert_drive_file_outlined,
                        size: 44,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.product.name,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 20,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(16),
                            padding: const EdgeInsets.all(20),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 20,
                                  offset: Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'العدد',
                                    style: TextStyle(
                                        fontSize: 20
                                    ),
                                  ),
                                ),
                                const Text(
                                  ':',
                                  style: TextStyle(fontSize: 20),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    widget.product.quantity.toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ),
                                IconButton(
                                    onPressed: (){
                                      showEditPriceDialog(
                                          qty,
                                          'تعديل الكمية',
                                          widget.product.quantity.toString(),
                                          true,
                                          true
                                      );
                                    },
                                    icon: Icon(Icons.edit)
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(16),
                            padding: const EdgeInsets.all(20),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 20,
                                  offset: Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'سعر   البيع',
                                    style: TextStyle(
                                        fontSize: 20
                                    ),
                                  ),
                                ),
                                const Text(
                                  ':',
                                  style: TextStyle(fontSize: 20),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    widget.product.price.toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ),
                                IconButton(
                                    onPressed: (){
                                      showEditPriceDialog(
                                          salePrice,
                                          'تعديل سعر البيع',
                                          widget.product.price.toString(),
                                          true,
                                          false
                                      );
                                    },
                                    icon: Icon(Icons.edit)
                                ),

                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(16),
                            padding: const EdgeInsets.all(20),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 20,
                                  offset: Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'سعر الشراء',
                                    style: TextStyle(
                                        fontSize: 20
                                    ),
                                  ),
                                ),
                                const Text(
                                  ':',
                                  style: TextStyle(fontSize: 20),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    widget.product.purchasePrice.toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ),
                                IconButton(
                                    onPressed: (){
                                      showEditPriceDialog(
                                          purchasePrice,
                                          'تعديل سعر الشراء',
                                          widget.product.purchasePrice.toString(),
                                          false,
                                          false
                                      );
                                    },
                                    icon: Icon(Icons.edit)
                                ),


                              ],
                            ),
                          ),
                        ],
                      )
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: buildModernButton(
                          color1: burgundyMid,
                          color2: burgundyLight,
                          icon: Icons.edit,
                          text: 'عرض المبيعات',
                          onTap: () {
                            navigateWithLoading(
                                context,
                                ()=>AppController.saleController.fetchSalesByName(widget.product.name),
                                ProductPurchases()
                            );
                          }
                      ),
                    ),
                  ],
                ),
              )
          ),
        ],
      ),
    );
  }
  void showEditPriceDialog(TextEditingController cont, String label, String x, bool isSalePrice, bool isQty){

    cont.text = x;

    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text(label),
          content: TextField(
            controller: cont,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: isQty ? 'الكمية الجديدة' : 'السعر الجديد',
              border: const OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
                onPressed: ()async {

                  if(isQty){
                    final int? newQty = int.tryParse(cont.text);
                    if (newQty == null || newQty < 0 ) {
                      showCustomSnackBar(
                        context: context,
                        text: 'القيمة غير صحيحة',
                        backgroundColor: Colors.red,
                      );
                      return;
                    }

                    await AppController.warehouseController.updateQuantity(
                        product: widget.product,
                        newQuantity: newQty
                    );

                    setState(() {
                      widget.product.quantity = newQty;
                    });
                  }
                  else{
                    final newPrice = double.tryParse(cont.text);
                    if (newPrice == null){
                      showCustomSnackBar(
                        context: context,
                        text: 'القيمة غير صحيحة',
                        backgroundColor: Colors.red,
                      );
                      return;
                    }
                    if(isSalePrice){
                      await AppController.warehouseController.updatePrice(productId: widget.product.id, newPrice: newPrice);
                      setState(() {
                        widget.product.price = newPrice;
                      });
                    }
                    else{
                      await AppController.warehouseController.updatePurchasePrice(productId: widget.product.id, newPrice: newPrice);
                      setState(() {
                        widget.product.purchasePrice = newPrice;
                      });
                    }
                  }
                  Navigator.pop(context);
                  showCustomSnackBar(
                    context: context,
                    text: 'تم التعديل ',
                  );
                },
              child: const Text('حفظ'),
            ),
          ],
        );
      }
    );
  }

  @override
  void dispose() {
    salePrice.dispose();
    purchasePrice.dispose();
    qty.dispose();
    super.dispose();
  }
}
