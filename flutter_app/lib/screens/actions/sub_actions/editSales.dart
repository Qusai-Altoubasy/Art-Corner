import 'package:art_corner/controllers/controllers.dart';
import 'package:art_corner/models/Sale.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../components/components.dart';
import '../../../shared/shared.dart';

class EditSales extends StatefulWidget {

  final bool isFaceBook;
  const EditSales({super.key, required this.isFaceBook});

  @override
  State<EditSales> createState() => _EditSales();
}

class _EditSales extends State<EditSales> {
  @override
  Widget build(BuildContext context) {

    final List<Sale> sal = widget.isFaceBook
        ? AppController.facabookPurchaseController.sales
        : AppController.saleController.sales;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "مبيعات الاسبوع",
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
      body: sal.isEmpty?
      Stack(
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

          const Center(
            child: Text(
              'لا يوجد مبيعات الاسبوع هاض',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
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
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  burgundyDark,
                  burgundyMid,
                ],
              ),
            ),
          ),

          ListView.builder(
            itemCount: sal.length,
              itemBuilder: (context, index){
              final sale = sal[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(
                    'رقم   :     ${sale.name}',
                    style: TextStyle(
                        fontWeight: FontWeight.w900
                    ),
                  ),
                  subtitle: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'الكمية :       ${sale.quantity}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                            Text(
                              'السعر  :       ${sale.price}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.access_time,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  DateFormat('dd/MM/yyyy • HH:mm').format(sale.date),
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {

                          bool? confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('تأكيد الحذف'),
                                content: const Text('هل أنت متأكد من حذف عملية البيع؟'),
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

                            if(widget.isFaceBook){
                              await AppController.facabookPurchaseController.retrieveSale(sale);
                            }
                            else{
                              await AppController.saleController.retrieveSale(sale);
                            }

                            setState(() {
                              sal.removeAt(index);
                            });

                            showCustomSnackBar(
                                durationSeconds: 2,
                                context: context,
                                text: 'اعتبرو انحذف ولا يهمك'
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
                    ],
                  ),
                ),
              );
            }
          ),
        ],
      ),

      backgroundColor: const Color(0xFF6FA8A1),
    );
  }
}
