import 'package:art_corner/controllers/controllers.dart';
import 'package:art_corner/services/pdf_service.dart';
import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../shared/shared.dart';

class PrintFinancialReport extends StatefulWidget {
  const PrintFinancialReport({super.key});

  @override
  State<PrintFinancialReport> createState() => _PrintFinancialReportState();
}

class _PrintFinancialReportState extends State<PrintFinancialReport> {
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
                    'كشف حساب الخزنة',
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
                        const SizedBox(height: 30),
                        buildModernButton(
                          color1: burgundyMid,
                          color2: burgundyLight,
                          icon: Icons.picture_as_pdf,
                          text: 'طباعة PDF',
                          onTap: () async{
                            await _printReport();
                          },
                        ),

                      ],
                    )
                  ),

                ],
              )
          ),
        ],
      ),
    );
  }
  Future<void> _printReport() async {
    DateTime start;
    DateTime end;
    if (fromDate == null || toDate == null) {
      showCustomSnackBar(
        context: context,
        text: 'اختار تاريخ البداية والنهاية',
        backgroundColor: Colors.red,
        icon: Icons.error,
      );
      return;
    }
    if (fromDate != null && toDate != null) {
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

    start = DateTime(fromDate!.year, fromDate!.month, fromDate!.day);
    end = DateTime(toDate!.year, toDate!.month, toDate!.day)
        .add(const Duration(days: 1));

    final String reportDateText =
    'من ${arabicDayName(fromDate!)} '
        '${fromDate!.year}/${fromDate!.month}/${fromDate!.day}'
        ' إلى ${arabicDayName(toDate!)} '
        '${toDate!.year}/${toDate!.month}/${toDate!.day}';

    final report = await AppController.reportController.getFinancialReport(start, end);

    await PdfService.generateFinancialReport(
        title: 'كشف حساب',
        rows: report.rows,
        dateText: reportDateText,
    );




  }


}
