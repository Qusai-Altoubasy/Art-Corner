import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../controllers/controllers.dart';
import '../../../shared/shared.dart';

class PricesScreen extends StatefulWidget {
  const PricesScreen({super.key});

  @override
  State<PricesScreen> createState() => _PricesScreenState();
}

class _PricesScreenState extends State<PricesScreen> {

  bool isGomla=false;
  bool isGomlawithPrint=false;
  bool ismfaraq=true;
  var qty = TextEditingController();
  var name = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
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
                    const SizedBox(height: 16),
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
                      child: const Center(
                        child: Icon(
                          Icons.price_check,
                          size: 44,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'استفسار عن سعر',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),

                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ToggleButtons(
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
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text('جملة', style: TextStyle(fontSize: 16)),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text('جملة مع طباعة', style: TextStyle(fontSize: 16)),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text('مفرق', style: TextStyle(fontSize: 16)),
                          ),
                        ],
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
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            defaultFormField(
                              controller: name,
                              type: TextInputType.number,
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
                            Divider(height: 40),
                            buildModernButton(
                              color1: burgundyMid,
                              color2: burgundyLight,
                              icon: Icons.search,
                              text: 'استفسار عن السعر',
                              onTap: () async {
                                if (!formKey.currentState!.validate()) return;
                                try {
                                  final p = await AppController.warehouseController.price(
                                    name.text,
                                    int.parse(qty.text),
                                    isGomla,
                                    isGomlawithPrint,
                                    ismfaraq,
                                  );

                                  showCustomSnackBar(
                                    context: context,
                                    text: 'السعر النهائي: $p',
                                  );
                                } catch (e) {
                                  showCustomSnackBar(
                                    context: context,
                                    text: e.toString().split(': ').last,
                                    icon: Icons.error,
                                    backgroundColor: Colors.red,
                                  );
                                }
                              },
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
}
