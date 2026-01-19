import 'package:art_corner/controllers/controllers.dart';
import 'package:art_corner/screens/actions/facebook_purchase_screen.dart';
import 'package:art_corner/screens/actions/purchase_screen.dart';
import 'package:art_corner/screens/actions/report_screen.dart';
import 'package:art_corner/screens/actions/sale_screen.dart';
import 'package:art_corner/screens/actions/liability_screen.dart';
import 'package:art_corner/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import '../components/components.dart';
import 'actions/financial_screen.dart';
import 'actions/warehouse_screen.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {

    final LocalAuthentication auth = LocalAuthentication();

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFF121212),
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: burgundyDark,
          elevation: 0,
          title: const Text(
            'ركن الفن لأجمل بطاقات الأفراح',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              letterSpacing: 0.3,
              color: Colors.white,
            ),
          ),
        ),
        body: Stack(
          children: [
            // ===== BACKGROUND =====
            Container(
              decoration: BoxDecoration(
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
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        //------الآية----------
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(top: 16),
                          decoration: BoxDecoration(
                            color: Colors.black.withAlpha(25),
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color: goldAccent.withAlpha(90),
                              width: 1,
                            ),
                          ),

                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 20),
                            child: Column(
                              children: [
                                const Text(
                                  'بِسْمِ اللَّهِ الرَّحْمنِ الرَّحِيمِ',
                                  style: TextStyle(
                                    color: textSoftWhite,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    height: 1.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 8),
                                const Text(
                                  'فَقُلْتُ اسْتَغْفِرُوا رَبَّكُمْ إِنَّهُ كَانَ غَفَّارًا يُرْسِلِ السَّمَاءَ عَلَيْكُمْ مِدْرَارًا وَيُمْدِدْكُمْ بِأَمْوَالٍ وَبَنِينَ وَيَجْعَلْ لَكُمْ جَنَّاتٍ وَيَجْعَلْ لَكُمْ أَنْهَارًا',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    height: 1.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        //---------Actions-----------
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          mainAxisSpacing: 15,
                          crossAxisSpacing: 15,
                          childAspectRatio: .95,
                          children: [
                            buildGlassButton(
                              context: context,
                              iconPath: 'assets/images/warehouse.png',
                              title: 'المستودع',
                              onTap: () async {
                                navigateWithLoading(
                                    context,
                                    ()=>AppController.warehouseController.fetchProducts(),
                                    WarehouseScreen()
                                );
                              },
                            ),

                            buildGlassButton(
                              context: context,
                              iconPath: 'assets/images/shopping.png',
                              title: 'شراء',
                              onTap: () {
                                navigateTo(context, PurchaseScreen());
                              },
                            ),

                            buildGlassButton(
                              context: context,
                              iconPath: 'assets/images/sale.png',
                              title: 'بيع',
                              onTap: () {
                                navigateTo(context, SaleScreen());
                              },
                            ),

                            buildGlassButton(
                              context: context,
                              iconPath: 'assets/images/pdf.png',
                              title: 'طباعة كشف حساب',
                              onTap: () {
                                navigateTo(context, ReportScreen());
                              },
                            ),

                            buildGlassButton(
                              context: context,
                              iconPath: 'assets/images/facebook.png',
                              title: 'مبيعات الفيس بوك',
                              onTap: () {
                                navigateTo(context, FacebookPurchase());
                              },
                            ),

                            buildGlassButton(
                              context: context,
                              iconPath: 'assets/images/financial.png',
                              title: 'المالية',
                              onTap: () async {
                                try {
                                  bool authenticated = await auth.authenticate(
                                    localizedReason: 'البصمة يا كبير',
                                    options: const AuthenticationOptions(
                                      stickyAuth: true,
                                      biometricOnly: false,
                                    ),
                                  );
                                  if (authenticated) {
                                    navigateWithLoading(
                                      context,
                                      AppController.financialsController.fetchFinancial,
                                      FinancialScreen(),
                                    );
                                  }
                                } on PlatformException catch (e) {
                                  showCustomSnackBar(context: context, text: "خطأ في التحقق من الهوية", backgroundColor: Colors.red);
                                }
                              },
                            ),
                          ],

                        ),
                      ],
                    ),
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}
