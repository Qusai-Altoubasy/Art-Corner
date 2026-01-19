import 'package:art_corner/controllers/controllers.dart';
import 'package:flutter/material.dart';
import 'package:art_corner/models/Liability.dart';

import '../../components/components.dart';

class LiabilityScreen extends StatefulWidget {
  const LiabilityScreen({super.key});

  @override
  State<LiabilityScreen> createState() => _LiabilityScreenState();
}

class _LiabilityScreenState extends State<LiabilityScreen> {
  @override
  Widget build(BuildContext context) {
    final liabilities = AppController.liabilitiesController.liabilities;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        actions: [
          IconButton(
            onPressed: () {
              _showAddLiabilityDialog(context);
              setState(() {});
            },
            icon: Icon(Icons.add),
          ),
        ],
        backgroundColor: const Color(0xFF7FA8C9),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF7FA8C9),
                  Color(0xFFC6DBF0),
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
                    const SizedBox(height: 20),
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
                      child: const Icon(
                        Icons.library_add_check_outlined,
                        size: 48,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'الالتزامات',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 30,),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: liabilities.length,
                        itemBuilder: (context, index){
                          final liability = liabilities[index];
                          return Opacity(
                            opacity: liability.isPaid ? 0.8 : 1.0,
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              child: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.inventory_2,
                                      color: Color(0xFF7FA8C9),
                                      size: 32,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                        child: Column(
                                          children: [
                                            Text(
                                              liability.title,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              liability.amount.toString(),
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '${liability.date.year}-${liability.date.month}-${liability.date.day}',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        )
                                    ),
                                    Checkbox(
                                      value: liability.isPaid,
                                      activeColor: Colors.green,
                                      onChanged: (bool? value) async {
                                        await AppController.liabilitiesController.toggleLiabilityStatus(
                                          liability.id,
                                          liability.isPaid,
                                        );
                                        setState(() {});
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                      onPressed: () => _showDeleteConfirmation(context, liability),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                    ),
                  ],
                ),
              )
          ),
        ],
      ),
    );
  }
  void _showAddLiabilityDialog(BuildContext context) {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    DateTime? selectedDate;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState){
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text('إضافة التزام جديد', textAlign: TextAlign.center),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'اسم الالتزام'),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'المبلغ'),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 20),
                Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedDate == null
                      ? 'لم يتم اختيار تاريخ'
                      : "${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setDialogState(() {
                        selectedDate = picked;
                      });
                    }
                  },
                  icon: const Icon(Icons.calendar_month, size: 18),
                  label: const Text('اختر تاريخ السداد'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[200], foregroundColor: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (titleController.text.isNotEmpty && amountController.text.isNotEmpty && selectedDate != null)
                  {
                    final double amt = double.tryParse(amountController.text) ?? 0.0;

                    await AppController.liabilitiesController.addLiability(
                      titleController.text,
                      amt,
                      selectedDate ?? DateTime.now(),
                    );

                    if (mounted) Navigator.pop(context);
                    setState(() {});
                  }
                  else{
                    showCustomSnackBar(
                        context: context,
                        text: 'شكلك نسيت تعبي اشي يا غالي ',
                      backgroundColor: Colors.red,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7FA8C9)),
                child: const Text('حفظ', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      ),
    );
  }
  void _showDeleteConfirmation(BuildContext context, Liability liability) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('تأكيد الحذف', textAlign: TextAlign.right),
        content: Text('هل أنت متأكد من حذف التزام "${liability.title}" نهائياً؟', textAlign: TextAlign.right),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              await AppController.liabilitiesController.deleteLiability(liability.id);
              if (context.mounted) Navigator.pop(context);
              setState(() {});
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
