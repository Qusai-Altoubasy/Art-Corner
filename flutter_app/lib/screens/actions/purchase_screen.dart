import 'package:art_corner/controllers/controllers.dart';
import 'package:art_corner/screens/actions/sub_actions/editPurchase.dart';
import 'package:art_corner/screens/actions/sub_actions/products_name.dart';
import 'package:flutter/material.dart';

import '../../components/components.dart';
import '../../shared/shared.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({super.key});

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {

  bool isNew = false;
  var qty = TextEditingController();
  var name = TextEditingController();
  var salePrice = TextEditingController();
  var purchasePrice = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        actions: [
          IconButton(
              onPressed: () {
                navigateTo(context, ProductsName());
              },
              icon: Icon(
                Icons.copy,
                size: 27,
              ),
            tooltip: 'اسماء الكروت',

          ),

          IconButton(
              onPressed: (){
                navigateWithLoading(
                    context,
                        ()=>AppController.purchaseController.fetchTodayPurchases(),
                    EditPurchase(),
                );
              },
              icon: Icon(Icons.receipt, size: 30,)
          ),
        ],
        centerTitle: true,
        backgroundColor: burgundyDark,
      ),
      body: Stack(
        children: [
          // ===== BACKGROUND =====
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
                        Icons.shopping_cart_outlined,
                        size: 48,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'عملية شراء',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 30,),
                    ToggleButtons(
                      borderRadius: BorderRadius.circular(18),
                      isSelected: [!isNew, isNew],
                      onPressed: (index) {
                        setState(() => isNew = index == 1);
                      },
                      fillColor: Color(0xFF81C784),
                      selectedColor: Colors.white,
                      color: Colors.white,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Text('كرت قديم'),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Text('كرت جديد'),
                        ),
                      ],
                    ),
                    SizedBox(height: 30,),
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

                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            defaultFormField(
                              controller: name,
                              type: TextInputType.text,
                              validate: (String value) {
                                if (value.isEmpty) {
                                  return "";
                                }
                                return null;
                              },
                              label: 'رقم الكرت : ',
                              prefix: Icons.numbers,
                            ),
                            SizedBox(height: 10,),
                            defaultFormField(
                              controller: qty,
                              type: TextInputType.numberWithOptions(),
                              validate: (String value) {
                                if (value.isEmpty) {
                                  return "";
                                }
                                return null;
                              },
                              label: 'العدد : ',
                              prefix: Icons.numbers,
                            ),
                            SizedBox(height: 10,),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              switchInCurve: Curves.easeOut,
                              switchOutCurve: Curves.easeIn,
                              transitionBuilder: (child, animation) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(0, 0.05),
                                      end: Offset.zero,
                                    ).animate(animation),
                                    child: child,
                                  ),
                                );
                              },
                              child: isNew ? _priceFields() : const SizedBox.shrink(
                                key: ValueKey('empty'),
                              ),
                            ),

                            // ===== Button =====
                            Divider(height: 40),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: buildModernButton(
                                  color1: burgundyMid,
                                  color2: burgundyLight,
                                  icon: Icons.add_box_outlined,
                                  text: 'شراء',
                                  onTap: () async {
                                    if (!formKey.currentState!.validate()) return;
                                    try{
                                      double sale = double.tryParse(salePrice.text) ?? 0.0;
                                      double purchase = double.tryParse(purchasePrice.text) ?? 0.0;

                                      await AppController.purchaseController.purchaseProduct(
                                          name: name.text.trim(),
                                          qty: int.parse(qty.text),
                                          salePrice: sale,
                                          purchasePrice: purchase,
                                          isNew: isNew
                                      );
                                      showCustomSnackBar(
                                          durationSeconds: 4,
                                          context: context,
                                          text: ' تم ياغالي \n الله يحسن الجبر '
                                      );
                                      Navigator.pop(context);
                                    }
                                    catch(e) {
                                      showCustomSnackBar(
                                        context: context,
                                        text: e.toString().split(': ').last,
                                        icon: Icons.error,
                                        backgroundColor: Colors.red,
                                      );
                                    }
                                  }
                              ),
                            ),
                          ],
                        ),
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
  Widget _priceFields() {
    return Column(
      key: const ValueKey('priceFields'),
      children: [
        defaultFormField(
          controller: salePrice,
          type: TextInputType.number,
          label: 'سعر البيع',
          prefix: Icons.attach_money,
          validate: (v) => v!.isEmpty ? '' : null,
        ),
        const SizedBox(height: 12),
        defaultFormField(
          controller: purchasePrice,
          type: TextInputType.number,
          label: 'سعر الشراء',
          prefix: Icons.attach_money,
          validate: (v) => v!.isEmpty ? '' : null,
        ),
      ],
    );
  }


  @override
  void dispose() {
    qty.dispose();
    name.dispose();
    salePrice.dispose();
    purchasePrice.dispose();
    super.dispose();
  }

}
