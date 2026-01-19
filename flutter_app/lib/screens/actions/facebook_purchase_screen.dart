import 'package:art_corner/screens/actions/sub_actions/editSales.dart';
import 'package:art_corner/screens/actions/sub_actions/print_facebook_purchase.dart';
import 'package:art_corner/screens/actions/sub_actions/products_name.dart';
import 'package:flutter/material.dart';

import '../../components/components.dart';
import '../../controllers/controllers.dart';
import '../../shared/shared.dart';

class FacebookPurchase extends StatefulWidget {
  const FacebookPurchase({super.key});

  @override
  State<FacebookPurchase> createState() => _FacebookPurchaseState();
}

class _FacebookPurchaseState extends State<FacebookPurchase> {
  var qty = TextEditingController();
  var name = TextEditingController();
  var discount = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var price = TextEditingController();
  bool isQuran = false;

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
          SizedBox(width: 10,),
          IconButton(
              onPressed: (){
                navigateTo(context, PrintFacebookPurchase());
              },
              icon: Icon(Icons.print, size: 30,),
              tooltip: 'طباعة كشف حساب لمبيعات الفيس بوك',

          ),
          SizedBox(width: 10,),
          IconButton(
              onPressed: (){
                navigateWithLoading(
                    context,
                        ()=>AppController.facabookPurchaseController.fetchLastWeekSales(),
                    EditSales(isFaceBook: true,)
                );
              },
            icon: Icon(Icons.receipt, size: 30,),
            tooltip: 'عرض مبيعات اخر اسبوع',
          ),
        ],
        centerTitle: true,
        backgroundColor: burgundyDark,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  burgundyDark,
                  burgundyMid,
                ],
              ),
            ),
          ),
          SingleChildScrollView(
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
                    Icons.facebook,
                    size: 44,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  'عملية بيع فيس بوك ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
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
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: SwitchListTile(
                              activeThumbColor: burgundyLight,
                              title: const Text('مصاحف ؟'),
                              value: isQuran,
                              onChanged: (v) => setState(() => isQuran = v),
                            ),
                          ),
                          SizedBox(height: 10,),
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
                          if(isQuran)...[
                            defaultFormField(
                              controller: price,
                              type: TextInputType.numberWithOptions(),
                              validate: (v) => v!.isEmpty|| double.tryParse(v) == 0? '' : null,
                              label: 'سعر ال 100 : ',
                              prefix: Icons.price_change_outlined,
                            ),
                            SizedBox(height: 10,),
                          ],
                          defaultFormField(
                            controller: discount,
                            type: TextInputType.numberWithOptions(),
                            validate: (String value) {},
                            label: 'الخصم (اختياري) : ',
                            prefix: Icons.discount,
                          ),
                          SizedBox(height: 10,),
                          Divider(height: 40),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: buildModernButton(
                                color1: burgundyMid,
                                color2: burgundyLight,
                                icon: Icons.add_box_outlined,
                                text: 'بيع',
                                onTap: () async {

                                  if (!formKey.currentState!.validate()) return;

                                  try{
                                    double discountValue = double.tryParse(discount.text) ?? 0.0;
                                    double manualPrice = isQuran ? (double.tryParse(price.text) ?? 0.0) : 0.0;

                                    double pr = await AppController.facabookPurchaseController.saleProducts(
                                        name.text.trim(),
                                        int.parse(qty.text),
                                        discountValue,
                                        manualPrice
                                    );
                                    showCustomSnackBar(
                                        durationSeconds: 4,
                                        context: context,
                                        text: 'تم يا غالي الله يبارك \n الحساب كامل طلع $pr'
                                    );
                                    Navigator.pop(context);
                                  }
                                  catch(error){
                                    showCustomSnackBar(
                                        context: context,
                                        text: error.toString().split(': ').last,
                                        icon: Icons.error,
                                        backgroundColor: const Color(0xFFEF5350),
                                        durationSeconds: 4
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
          ),
        ],
      ),
    );
  }
  @override
  void dispose() {
    qty.dispose();
    name.dispose();
    discount.dispose();
    price.dispose();
    super.dispose();
  }
}
