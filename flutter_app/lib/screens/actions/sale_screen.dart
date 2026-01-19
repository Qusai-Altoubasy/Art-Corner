import 'package:art_corner/controllers/controllers.dart';
import 'package:art_corner/screens/actions/sub_actions/prices_screen.dart';
import 'package:art_corner/screens/actions/sub_actions/editSales.dart';
import 'package:art_corner/screens/actions/sub_actions/products_name.dart';
import 'package:flutter/material.dart';
import '../../components/components.dart';
import '../../shared/shared.dart';

class SaleScreen extends StatefulWidget {
  const SaleScreen({super.key});

  @override
  State<SaleScreen> createState() => _SaleScreenState();
}

class _SaleScreenState extends State<SaleScreen> {
  bool isGomla=false;
  bool isGomlawithPrint=false;
  bool ismfaraq=true;
  bool isQuran = false;

  var qty = TextEditingController();
  var name = TextEditingController();
  var discount = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var price = TextEditingController();

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
            onPressed: () => navigateTo(context, PricesScreen()),
            icon: const Icon(Icons.sell_outlined, size: 28),
            tooltip: 'استعلام عن سعر',
          ),
          SizedBox(width: 10,),
          IconButton(
              onPressed: (){
                navigateWithLoading(
                    context,
                        ()=>AppController.saleController.fetchLastWeekSales(),
                    EditSales(isFaceBook: false,),
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
          // ===== BACKGROUND =====
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
                        Icons.point_of_sale,
                        size: 44,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'عملية بيع',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 30,),
                    ToggleButtons(
                      borderRadius: BorderRadius.circular(18),
                      isSelected: [
                        isGomla,
                        isGomlawithPrint,
                        ismfaraq,
                      ],
                      onPressed: (index) {
                        setState(() {
                          isGomla = index == 0;
                          isGomlawithPrint = index == 1;
                          ismfaraq = index == 2;
                        });
                      },
                      fillColor: Colors.green,
                      selectedColor: Colors.white,
                      color: Colors.white,
                      children: const [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 18),
                          child: Text(
                              'جملة',
                            style: TextStyle(
                              fontSize: 16
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 18),
                          child: Text(
                              'جملة مع طباعة',
                            style: TextStyle(
                                fontSize: 16
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 18),
                          child: Text(
                              'مفرق',
                            style: TextStyle(
                                fontSize: 16
                            ),
                          ),
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
                                validate: (v) => v!.isEmpty|| double.tryParse(v) == 0 ? '' : null,
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
                                      double pr = await AppController.saleController.saleProducts(
                                          name.text.trim(),
                                          int.parse(qty.text),
                                          discountValue,
                                          isGomla,
                                          isGomlawithPrint,
                                          ismfaraq,
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
                  ]
              ),
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
