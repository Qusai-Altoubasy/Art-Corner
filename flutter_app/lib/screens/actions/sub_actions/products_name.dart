import 'package:art_corner/controllers/controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../components/components.dart';
import '../../../shared/shared.dart';

class ProductsName extends StatefulWidget {
  const ProductsName({super.key});

  @override
  State<ProductsName> createState() => _ProductsNameState();
}

class _ProductsNameState extends State<ProductsName> {
  String searchQuery = "";
  @override
  Widget build(BuildContext context) {
    final controller = AppController.warehouseController;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        backgroundColor: burgundyDark,
        elevation: 0,

        title: const Text(
          "اسماء الكروت",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: "ابحث عن كرت...",
                  prefixIcon: const Icon(Icons.search),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              )
          )
        ),
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

          FutureBuilder(
            future: controller.products.isEmpty ?
            controller.fetchProducts():
            Future.value(),
            builder: (context, asyncSnapshot) {

              if (
              asyncSnapshot.connectionState == ConnectionState.waiting
                  && controller.products.isEmpty
              ) {
                return Center(
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          CircularProgressIndicator(),
                          SizedBox(width: 20),
                          Text('دقيقة يا غالي بنجيب المعلومات ...'),
                        ],
                      ),
                    ),
                  ),
                );
              }

              final filteredProds = controller.products.where((product) {
                return product.name.toLowerCase().contains(searchQuery.toLowerCase());
              }).toList();

              filteredProds.sort((a, b) {
                bool isNumeric(String s) => double.tryParse(s) != null;

                bool aIsNum = isNumeric(a.name);
                bool bIsNum = isNumeric(b.name);

                if (aIsNum && !bIsNum) return 1;
                if (!aIsNum && bIsNum) return -1;

                return a.name.compareTo(b.name);
              });

              return ListView.builder(
                itemCount: filteredProds.length,
                itemBuilder: (context, index){
                  final product = filteredProds[index];
                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      title: Text(
                        'رقم   :     ${product.name}',
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                      subtitle:
                      Text(
                        'الكمية :       ${product.quantity}',
                        style: TextStyle(
                            fontWeight: FontWeight.w500
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.copy, size: 25, color: burgundyLight),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: product.name));
                          showCustomSnackBar(
                            context: context,
                            text: 'تم النسخ ',
                          );
                        },
                      ),
                    ),
                  );

                },
              );
            }
          ),
        ],
      ),
    );
  }
}
