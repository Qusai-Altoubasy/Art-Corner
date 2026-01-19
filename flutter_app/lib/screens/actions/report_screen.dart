import 'package:flutter/material.dart';

import '../../components/components.dart';
import '../../controllers/controllers.dart';
import '../../services/pdf_service.dart';
import '../../shared/shared.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {

  bool isSales = true;
  bool isToday = true;
  DateTime? fromDate;
  DateTime? toDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: burgundyDark,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
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
                  const SizedBox(height: 30),
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      shape: BoxShape.circle,
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
                        Icons.receipt_long,
                        size: 46,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'كشف الحساب',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
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
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: buildModernButton(
                                color1: isSales ? Colors.green : Colors.grey,
                                color2: isSales ? Colors.greenAccent : Colors.grey.shade600,
                                icon: Icons.point_of_sale,
                                text: 'مبيعات',
                                onTap: () => setState(() => isSales = true),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: buildModernButton(
                                color1: !isSales ? Colors.green : Colors.grey,
                                color2: !isSales ? Colors.greenAccent : Colors.grey.shade600,
                                icon: Icons.shopping_cart,
                                text: 'مشتريات',
                                onTap: () => setState(() => isSales = false),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: SwitchListTile(
                            activeThumbColor: burgundyLight,
                            title: const Text('كشف حساب اليوم'),
                            value: isToday,
                            onChanged: (v) => setState(() => isToday = v),
                          ),
                        ),

                        if (!isToday) ...[
                          const SizedBox(height: 30),
                          buildModernButton(
                            color1: Colors.blueGrey,
                            color2: Colors.blueGrey.shade200,
                            icon: Icons.date_range,
                            text: fromDate == null
                                ? 'من تاريخ'
                                : '${fromDate!.year}/${fromDate!.month}/${fromDate!.day}',
                            onTap: () async {
                              fromDate = await showDatePicker(
                                context: context,
                                firstDate: DateTime(2023),
                                lastDate: DateTime.now(),
                                initialDate: DateTime.now(),
                              );
                              setState(() {});
                            },
                          ),
                          const SizedBox(height: 10),

                          buildModernButton(
                            color1: Colors.blueGrey,
                            color2: Colors.blueGrey.shade200,
                            icon: Icons.date_range,
                            text: toDate == null
                                ? 'إلى تاريخ'
                                : '${toDate!.year}/${toDate!.month}/${toDate!.day}',
                            onTap: () async {
                              toDate = await showDatePicker(
                                context: context,
                                firstDate: DateTime(2023),
                                lastDate: DateTime.now(),
                                initialDate: DateTime.now(),
                              );
                              setState(() {});
                            },
                          ),
                        ],
                        const SizedBox(height: 30),
                        buildModernButton(
                          color1: burgundyMid,
                          color2: burgundyLight,
                          icon: Icons.picture_as_pdf,
                          text: 'طباعة PDF',
                          onTap: () async {

                            if (!isToday && fromDate != null && toDate != null) {
                              if (toDate!.isBefore(fromDate!)) {
                                showCustomSnackBar(
                                  context: context,
                                  text: 'تاريخ النهاية لازم يكون بعد تاريخ البداية',
                                  backgroundColor: Colors.red,
                                  icon: Icons.error,
                                );
                                return;
                              }
                            }

                            await _printReport();
                          },
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _printReport() async {
    DateTime start;
    DateTime end;

    if (isToday) {
      final now = DateTime.now();
      start = DateTime(now.year, now.month, now.day);
      end = start.add(const Duration(days: 1));
    } else {
      if (fromDate == null || toDate == null) {
        showCustomSnackBar(
          context: context,
          text: 'اختار تاريخ البداية والنهاية',
          backgroundColor: Colors.red,
          icon: Icons.error,
        );
        return;
      }

      start = DateTime(fromDate!.year, fromDate!.month, fromDate!.day);
      end = DateTime(toDate!.year, toDate!.month, toDate!.day)
          .add(const Duration(days: 1));
    }

    String reportDateText;
    if (isToday) {
      reportDateText =
      'اليوم: ${arabicDayName(start)} '
          '${start.year}/${start.month}/${start.day}';
    }
    else {
      reportDateText =
      'من ${arabicDayName(fromDate!)} '
          '${fromDate!.year}/${fromDate!.month}/${fromDate!.day}'
          ' إلى ${arabicDayName(toDate!)} '
          '${toDate!.year}/${toDate!.month}/${toDate!.day}';
    }

    if (isSales) {

      final report = await AppController.reportController.getSalesReport(start, end, false, false);

      await PdfService.generateReport(
        title: 'كشف مبيعات',
        rows: report.rows,
        total: report.total,
        totalPur: report.totalPurchase,
        dateText: reportDateText,
        isSale: isSales,
      );
    }
    else {
      final report = await AppController.reportController.getPurchasesReport(start, end);

      await PdfService.generateReport(
        title: 'كشف مشتريات',
        rows: report.rows,
        total: report.total,
        totalPur: report.totalPurchase,
        dateText: reportDateText,
        isSale: isSales,
      );

    }
  }


}
