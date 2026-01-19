import 'package:art_corner/controllers/controllers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../shared/shared.dart';

class ProductPurchases extends StatelessWidget {
  const ProductPurchases({super.key});

  @override
  Widget build(BuildContext context) {

    final sal = AppController.saleController.sales;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        backgroundColor: burgundyDark,
        title: Text(
            sal.isEmpty?'':sal.first.name,
          style: const TextStyle(
            color: Colors.white
          ),
        ),
      ),
      backgroundColor: const Color(0xFF6FA8A1),
        body: sal.isEmpty?
        Stack(
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

            const Center(
              child: Text(
                'لا يوجد مبيعات لغاية الآن',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
              ),
            ),
          ],
        ) :Stack(
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
            ListView.builder(
              itemCount: sal.length,
                itemBuilder: (context, index){
                  final sale = sal[index];
                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      title: Text(
                        'العدد   :     ${sale.quantity}',
                        style: TextStyle(
                            fontWeight: FontWeight.w900
                        ),
                      ),
                      subtitle: Row(
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
                    ),
                  );
                }

            ),
          ],
        )
    );
  }
}
