import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfService {

  static Future<void> generateReport({
    required String title,
    required List<List<String>> rows,
    required String dateText,
    required double total,
    required bool isSale,
    required double totalPur,
  }) async
  {

    final fontData = await rootBundle
        .load('assets/fonts/Cairo-VariableFont_slnt,wght.ttf');
    final arabicFont = pw.Font.ttf(fontData);

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        textDirection: pw.TextDirection.rtl,

        header: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Text(
              title,
              style: pw.TextStyle(
                font: arabicFont,
                fontSize: 20,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              dateText,
              style: pw.TextStyle(
                font: arabicFont,
                fontSize: 13,
              ),
            ),
            pw.Divider(),
            pw.SizedBox(height: 8),
          ],
        ),
        footer: (context) => pw.Container(
          alignment: pw.Alignment.centerRight,
          margin: const pw.EdgeInsets.only(top: 10),
          child: pw.Text(
            '  صفحة   ${context.pageNumber}   من   ${context.pagesCount}',
            style: pw.TextStyle(font: arabicFont, fontSize: 10),
          ),
        ),
        build: (context) => [
          if (isSale)
            pw.TableHelper.fromTextArray(
              rowDecoration: const pw.BoxDecoration(
                color: PdfColors.grey200,
              ),
              oddRowDecoration: const pw.BoxDecoration(
                color: PdfColors.white,
              ),
              headers: ['سعر الشراء', 'سعر البيع', 'الكمية', 'الاسم'],
              data: rows.map((r) => r.reversed.toList()).toList(),
              headerStyle: pw.TextStyle(
                font: arabicFont,
                fontWeight: pw.FontWeight.bold,
                fontSize: 11,
              ),
              cellStyle: pw.TextStyle(
                font: arabicFont,
                fontSize: 10,
              ),
              cellAlignment: pw.Alignment.center,
            ),

          if (!isSale)
            pw.TableHelper.fromTextArray(
              rowDecoration: const pw.BoxDecoration(
                color: PdfColors.grey200,
              ),
              oddRowDecoration: const pw.BoxDecoration(
                color: PdfColors.white,
              ),
              headers: ['سعر البيع', 'الكمية', 'الاسم'],
              data: rows.map((r) => r.reversed.toList()).toList(),
              headerStyle: pw.TextStyle(
                font: arabicFont,
                fontWeight: pw.FontWeight.bold,
                fontSize: 11,
              ),
              cellStyle: pw.TextStyle(
                font: arabicFont,
                fontSize: 10,
              ),
              cellAlignment: pw.Alignment.center,
            ),

          pw.SizedBox(height: 20),
          pw.Divider(),
          pw.Container(
            alignment: pw.Alignment.centerRight,
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(width: 1),
              borderRadius: pw.BorderRadius.circular(6),
            ),
            child: pw.Text(
              'السعر الإجمالي: ${total.toStringAsFixed(4)}',
              style: pw.TextStyle(
                font: arabicFont,
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),

          if (isSale) pw.SizedBox(height: 6),

          if (isSale)...[
            pw.Container(
              alignment: pw.Alignment.centerRight,
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(width: 1),
                borderRadius: pw.BorderRadius.circular(6),
              ),
              child: pw.Text(
                'سعر الشراء الإجمالي: ${totalPur.toStringAsFixed(4)}',
                style: pw.TextStyle(
                  font: arabicFont,
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 6),
            pw.Container(
              alignment: pw.Alignment.centerRight,
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(width: 1),
                borderRadius: pw.BorderRadius.circular(6),
              ),
              child: pw.Text(
                'صافي الربح: ${(total - totalPur).toStringAsFixed(4)}',
                style: pw.TextStyle(
                  font: arabicFont,
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: _safeFileName(title),
    );
  }

  static Future<void> generateProductReport({
    required String title,
    required List<List<String>> rows,
    required String dateText,
    required double total,
  })async
  {

    final fontData = await rootBundle
        .load('assets/fonts/Cairo-VariableFont_slnt,wght.ttf');
    final arabicFont = pw.Font.ttf(fontData);

    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        textDirection: pw.TextDirection.rtl,
        header: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Text(
              title,
              style: pw.TextStyle(
                font: arabicFont,
                fontSize: 20,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              dateText,
              style: pw.TextStyle(
                font: arabicFont,
                fontSize: 13,
              ),
            ),
            pw.Divider(),
            pw.SizedBox(height: 8),
          ],
        ),
        build: (context) => [
            pw.TableHelper.fromTextArray(
              rowDecoration: const pw.BoxDecoration(
                color: PdfColors.grey200,
              ),
              oddRowDecoration: const pw.BoxDecoration(
                color: PdfColors.white,
              ),
              headers: ['السعر الاجمالي','سعر الشراء', 'سعر البيع', 'الكمية', 'الاسم'],
              data: rows.map((r) => r.reversed.toList()).toList(),
              headerStyle: pw.TextStyle(
                font: arabicFont,
                fontWeight: pw.FontWeight.bold,
                fontSize: 11,
              ),
              cellStyle: pw.TextStyle(
                font: arabicFont,
                fontSize: 10,
              ),
              cellAlignment: pw.Alignment.center,
            ),
            pw.SizedBox(height: 20),
            pw.Divider(),
            pw.Container(
              alignment: pw.Alignment.centerRight,
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(width: 1),
                borderRadius: pw.BorderRadius.circular(6),
              ),
              child: pw.Text(
                'المجموع  : ${total.toStringAsFixed(4)}',
                style: pw.TextStyle(
                  font: arabicFont,
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
          ],
        footer: (context) => pw.Container(
          alignment: pw.Alignment.centerRight,
          margin: const pw.EdgeInsets.only(top: 10),
          child: pw.Text(
            '  صفحة   ${context.pageNumber}   من   ${context.pagesCount}',
            style: pw.TextStyle(font: arabicFont, fontSize: 10),
          ),
        ),

      )
    );
    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: _safeFileName(title),
    );
  }

  static Future<void> generateFinancialReport({
    required String title,
    required List<List<String>> rows,
    required String dateText,
  })async
  {

    final fontData = await rootBundle
        .load('assets/fonts/Cairo-VariableFont_slnt,wght.ttf');
    final arabicFont = pw.Font.ttf(fontData);

    final pdf = pw.Document();
    pdf.addPage(
        pw.MultiPage(
          textDirection: pw.TextDirection.rtl,
          header: (context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(
                title,
                style: pw.TextStyle(
                  font: arabicFont,
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                dateText,
                style: pw.TextStyle(
                  font: arabicFont,
                  fontSize: 13,
                ),
              ),
              pw.Divider(),
              pw.SizedBox(height: 8),
            ],
          ),
          build: (context) => [
            pw.TableHelper.fromTextArray(
              rowDecoration: const pw.BoxDecoration(
                color: PdfColors.grey200,
              ),
              oddRowDecoration: const pw.BoxDecoration(
                color: PdfColors.white,
              ),
              headers: ['الرصيد بعد العملية','القيمة', 'العملية', 'البيان', 'التاريخ'],
              data: rows.map((r) => r.reversed.toList()).toList(),
              headerStyle: pw.TextStyle(
                font: arabicFont,
                fontWeight: pw.FontWeight.bold,
                fontSize: 11,
              ),
              cellStyle: pw.TextStyle(
                font: arabicFont,
                fontSize: 10,
              ),
              cellAlignment: pw.Alignment.center,
            ),
            pw.SizedBox(height: 20),
          ],
          footer: (context) => pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 10),
            child: pw.Text(
              '  صفحة   ${context.pageNumber}   من   ${context.pagesCount}',
              style: pw.TextStyle(font: arabicFont, fontSize: 10),
            ),
          ),

        )
    );
    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: _safeFileName(title),
    );
  }


  static String _safeFileName(String title) {
    final now = DateTime.now();
    return '${title}_${now.year}-${now.month}-${now.day}.pdf';
  }


}
