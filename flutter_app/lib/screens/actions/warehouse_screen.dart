import 'package:art_corner/screens/actions/sub_actions/product_details.dart';
import 'package:art_corner/screens/actions/sub_actions/products_name.dart';
import 'package:art_corner/shared/shared.dart';
import 'package:flutter/material.dart';
import '../../controllers/controllers.dart';
import '../../services/pdf_service.dart';


  class WarehouseScreen extends StatefulWidget {
    const WarehouseScreen({super.key});

    @override
    State<WarehouseScreen> createState() => _WarehouseScreenState();
  }

  class _WarehouseScreenState extends State<WarehouseScreen> {

    TextEditingController searchController = TextEditingController();
    String searchText = '';

    @override
    Widget build(BuildContext context) {
      final prods = AppController.warehouseController.products;
      final filteredProducts = prods.where((product) {
        return product.name
            .contains(searchText);
      }).toList();

      return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          centerTitle: true,
          backgroundColor: burgundyDark,
          elevation: 0,
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
                onPressed: () async {
                  await _printReport();
                },
                icon: Icon(
                  Icons.picture_as_pdf,
                  size: 30,
                )
            ),
          ],
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
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 190,
                  backgroundColor: Colors.transparent,
                  automaticallyImplyLeading: false,
                  floating: false,
                  pinned: false,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
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
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.warehouse_outlined,
                            size: 44,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          'مخزون المستودع',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: searchController,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        setState(() {
                          searchText = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'بحث برقم الكرت',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.only(bottom: 40),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      childCount: filteredProducts.length,
                      (context, index) {
                        final product = filteredProducts[index];
                        return GestureDetector(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProductDetails(product: product),
                              ),
                            );
                            setState(() {});
                          },
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.inventory_2,
                                    color: burgundyLight,
                                    size: 32,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'رقم الكرت: ${product.name}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          'الكمية: ${product.quantity}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: product.quantity < 1000
                                                ? Colors.red
                                                : Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (product.quantity < 1000)
                                    const Icon(
                                      Icons.warning_amber_rounded,
                                      color: Colors.red,
                                      size: 26,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
    Future<void> _printReport() async {

      DateTime start;

      final now = DateTime.now();
      start = DateTime(now.year, now.month, now.day);

      String reportDateText =
      'اليوم: ${arabicDayName(start)} '
          '${start.year}/${start.month}/${start.day}';

      final report = AppController.reportController.getProductReport();

      await PdfService.generateProductReport(
        title: 'كشف المستودع',
        rows: report.rows,
        total: report.total,
        dateText: reportDateText,
      );
    }


    @override
    void dispose() {
      searchController.dispose();
      super.dispose();
    }
  }
