import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomLabeledTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;

  const CustomLabeledTextField({
    required this.label,
    required this.hint,
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: GoogleFonts.quicksand(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.grey[500],
            ),
          ),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.quicksand(
                color: Colors.grey[400],
                fontWeight: FontWeight.w600,
              ),
              border: InputBorder.none,
              isDense: true,
            ),
          ),
        ],
      ),
    );
  }
}
