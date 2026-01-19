import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../controllers/controllers.dart';
import '../../../shared/shared.dart';

class EditPurchase extends StatefulWidget {
  const EditPurchase({super.key});

  @override
  State<EditPurchase> createState() => _EditPurchaseState();
}

class _EditPurchaseState extends State<EditPurchase> {
  @override
  Widget build(BuildContext context) {

    final purchases = AppController.purchaseController.purchases;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "مشتريات اليوم",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
        centerTitle: true,
        backgroundColor: burgundyDark,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: purchases.isEmpty ?
        Stack(
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

            const Center(
              child: Text(
                'لا يوجد مشتريات اليوم',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
              ),
            ),
          ],
        )
          :Stack(
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

              ListView.builder(
                      itemCount: purchases.length,
              itemBuilder: (context, index){
                final pur = purchases[index];

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(
                      'رقم   :     ${pur.name}',
                      style: TextStyle(
                          fontWeight: FontWeight.w900
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        Column(
                          children: [
                            Text(
                              'الكمية :       ${pur.quantity}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () async {

                                bool? confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('تأكيد الحذف'),
                                      content: const Text('هل أنت متأكد من حذف عملية الشراء؟'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, false),
                                          child: const Text('إلغاء'),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, true),
                                          child: const Text(
                                            'حذف',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );

                                if (confirm != true) return;

                                try{

                                  await AppController.purchaseController.retrievePurchase(pur);

                                  setState(() {
                                    purchases.removeAt(index);
                                  });

                                  showCustomSnackBar(
                                      durationSeconds: 2,
                                      context: context,
                                      text: 'اعتبرو انحذف ولا يهمك',
                                  );
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
                              },
                            ),
                          ),
                        ),

                      ],
                    ),

                  ),
                );
              }
                    ),
            ],
          ),
    );
  }
}
