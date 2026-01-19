import 'dart:ui';

import 'package:flutter/material.dart';

import '../shared/shared.dart';

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  void Function(String)? onSubmit,
  void Function(String)? onChange,
  VoidCallback? onTap,
  bool isPassword = false,
  required Function validate,
  required String label,
  required IconData prefix,
  bool isClickable = true,
  IconData? suffix,
  VoidCallback? suffixPressed,
  Key? fieldKey,
}) =>
    TextFormField(
      key: fieldKey,
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      enabled: isClickable,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      onTap: onTap,
      validator: (s){
        return validate (s);
      },
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontSize: 14,
          color: Colors.black54,
        ),

        // ===== الشكل الحديث =====
        filled: true,
        fillColor: Colors.grey.shade100,

        prefixIcon: Icon(
          prefix,
          color: Colors.grey.shade700,
        ),

        suffixIcon: suffix != null
            ? IconButton(
          onPressed: suffixPressed,
          icon: Icon(suffix),
        )
            : null,

        // ===== الحدود =====
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Colors.green.shade400,
            width: 1.5,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.2,
          ),
        ),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
      ),
    );

Widget buildModernButton({
  required Color color1,
  required Color color2,
  required IconData icon,
  required String text,
  required VoidCallback onTap,
})
{
  return Material(
    color: Colors.transparent,
    child: InkWell(
      borderRadius: BorderRadius.circular(22),
      splashColor: Colors.white.withValues(alpha: 0.2),
      highlightColor: Colors.white.withValues(alpha: 0.1),
      onTap: onTap,
      child: Container(
        height: 78,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color1, color2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 18),
            Icon(icon, color: Colors.white, size: 34),
            const SizedBox(width: 18),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 18),
          ],
        ),
      ),
    ),
  );
}

void showCustomSnackBar({
  required BuildContext context,
  required String text,
  Color backgroundColor = Colors.green,
  IconData icon = Icons.check_circle,
  int durationSeconds = 3,
})
{
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      duration: Duration(seconds: durationSeconds),
      content: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildGlassButton({
  required BuildContext context,
  required String iconPath,
  required String title,
  required VoidCallback onTap,
}) {

  return ClipRRect(
    borderRadius: BorderRadius.circular(25),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        splashColor: goldAccent.withAlpha(25),
        highlightColor: Colors.transparent,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(35),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: goldAccent.withAlpha(60),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 25),
                SizedBox(
                  height: 75,
                  width: 75,
                  child: Image.asset(
                    iconPath,
                    fit: BoxFit.cover,
                    cacheWidth: 100,
                  ),
                ),
              const SizedBox(height: 10),
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: textSoftWhite,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}