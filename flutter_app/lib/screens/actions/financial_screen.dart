import 'package:art_corner/controllers/controllers.dart';
import 'package:art_corner/screens/actions/sub_actions/print_financial_report.dart';
import 'package:art_corner/shared/shared.dart';
import 'package:flutter/material.dart';
import '../../components/components.dart';

class FinancialScreen extends StatefulWidget {
  const FinancialScreen({super.key});

  @override
  State<FinancialScreen> createState() => _FinancialScreenState();
}

class _FinancialScreenState extends State<FinancialScreen> {
  @override
  Widget build(BuildContext context) {
    final financials = AppController.financialsController;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: burgundyDark,
        title: const Text(
            ' المالية',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold
            )
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: (){
                navigateTo(context, PrintFinancialReport());
              },
              icon: Icon(Icons.picture_as_pdf)
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
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildBalanceCard(financials.totalBalance),
                const SizedBox(height: 20),
                _buildActionButtons(context),
                const SizedBox(height: 20),
                const Text(
                  'سجل الحركات المالية',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                    ),
                    child: financials.financialRecords.isEmpty
                        ? const Center(child: Text('لا يوجد حركات مسجلة بعد'))
                        : ListView.builder(
                      padding: const EdgeInsets.all(15),
                      itemCount: financials.financialRecords.length,
                      itemBuilder: (context, index) {
                        final record = financials.financialRecords[index];
                        return _buildRecordTile(record);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(double balance) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          const Text('الرصيد الكلي الحالي', style: TextStyle(color: Colors.white, fontSize: 16)),
          const SizedBox(height: 10),
          Text(
            balance.toStringAsFixed(2),
            style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
          ),
          const Text('دينار', style: TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 100),
      child: GestureDetector(
        onTap: () => _showTransactionDialog(context, true),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              )
            ],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.payments_outlined, color: burgundyDark),
              SizedBox(width: 10),
              Text(
                "تسديد مبلغ",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: burgundyDark
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTransactionDialog(BuildContext context, bool isAddition) {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) =>
          StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('تسجيل دفعة مسددة', textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'طريقة الدفعة'),
                  textAlign: TextAlign.right
              ),
              TextField(
                  controller: amountController,
                  decoration: const InputDecoration(labelText: 'المبلغ المدفوع'),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.right
              ),
              const SizedBox(height: 15),
              OutlinedButton.icon(
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setDialogState(() => selectedDate = picked);
                  }
                },
                icon: const Icon(Icons.calendar_month),
                label: Text("تاريخ الدفعة: ${selectedDate.year}-${selectedDate.month}-${selectedDate.day}"),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isNotEmpty && amountController.text.isNotEmpty) {
                  final double amt = double.tryParse(amountController.text) ?? 0.0;

                  await AppController.financialsController.addTransaction(
                      titleController.text,
                      amt,
                      isAddition,
                      selectedDate
                  );

                  if (mounted) Navigator.pop(context);
                  setState(() {});
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: burgundyDark),
              child: const Text('تأكيد', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordTile(dynamic record) {
    String hour = record.date.hour.toString().padLeft(2, '0');
    String minute = record.date.minute.toString().padLeft(2, '0');
    String timeString = "$hour:$minute";
    String dateString = "${record.date.day}/${record.date.month}/${record.date.year}";

    return Card(
      elevation: 0,
      color: Colors.grey[50],
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(

        onLongPress: () {
          if (record.isAddition) {
            _showDeleteConfirmation(context, record);
          }
        },
        leading: CircleAvatar(
          backgroundColor: record.isAddition ? Colors.green[50] : Colors.red[50],
          child: Icon(
            record.isAddition ? Icons.north_east : Icons.south_east,
            color: record.isAddition ? Colors.green : Colors.red,
            size: 20,
          ),
        ),
        title: Text(record.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Row(
          children: [
            Icon(Icons.calendar_today, size: 12, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text(dateString, style: TextStyle(color: Colors.grey[600])),
            const SizedBox(width: 15),
            Icon(Icons.access_time, size: 12, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text(timeString, style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500)),
          ],
        ),
        trailing: Text(
          "${record.isAddition ? '+' : '-'}${record.amount.toStringAsFixed(3)}",
          style: TextStyle(
            color: record.isAddition ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, dynamic record) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف الحركة المالية'),
        content: Text('هل أنت متأكد من حذف دفعة "${record.title}" بقيمة ${record.amount}؟\nسيتم خصم المبلغ من الرصيد الكلي.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              await AppController.financialsController.removeTransactionByTime(record.date, record.amount, record.isAddition);

              if (mounted) Navigator.pop(context);
              setState(() {});
              showCustomSnackBar(context: context, text: 'تم حذف الحركة وتعديل الرصيد', backgroundColor: Colors.green);
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

}