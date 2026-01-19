import 'package:flutter/material.dart';

import '../components/components.dart';

void navigateTo(BuildContext context, Widget page) {
  Navigator.of(context).push(
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 220),
      reverseTransitionDuration: const Duration(milliseconds: 120),
      pageBuilder: (_, animation, __) => page,
      transitionsBuilder: (_, animation, __, child) {
        final fade = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        );

        final slide = Tween<Offset>(
          begin: const Offset(0.0, 0.05),
          end: Offset.zero,
        ).animate(fade);

        return FadeTransition(
          opacity: fade,
          child: SlideTransition(
            position: slide,
            child: child,
          ),
        );
      },
    ),
  );
}

Future<void> navigateWithLoading(
    BuildContext context,
    Future<void> Function() fetchData,
    Widget nextPage,
    ) async
{
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text('اللهم صل على محمد ...'),
          ],
        ),
      ),
    ),
  );

  try {
    await fetchData();
  } catch (e) {
    showCustomSnackBar(
        context: context,
        text: "تأكد من الإنترنت يا غالي", backgroundColor: Colors.red
    );
  }
  finally {
    if (!context.mounted) return;
    Navigator.of(context).pop();
  }

  if (!context.mounted) return;

  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => nextPage,
    ),
  );
}

String arabicDayName(DateTime date) {
  const days = [
    'الاثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
    'السبت',
    'الأحد',
  ];
  return days[date.weekday - 1];
}

const burgundyDark   = Color(0xFF3A0F12);
const burgundyMid    = Color(0xFF5D1013);
const burgundyLight  = Color(0xFF7A1A1C);

const goldAccent     = Color(0xFFD4AF37);
const textSoftWhite  = Color(0xFFECECEC);
const textMuted      = Color(0xFFB8B8B8);

