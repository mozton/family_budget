import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextfieldAmountInput extends StatelessWidget {
  final Color color;
  final TextEditingController controller;

  const TextfieldAmountInput({
    super.key,
    required this.color,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(
            "MONTO",
            style: GoogleFonts.quicksand(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey[500],
              letterSpacing: 1.2,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "DOP",
              style: GoogleFonts.quicksand(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: color.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 150,
              child: TextField(
                controller: controller,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textAlign: TextAlign.center,
                style: GoogleFonts.quicksand(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F2937),
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "0.00",
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
