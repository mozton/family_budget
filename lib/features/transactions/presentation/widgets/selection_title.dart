import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectionTitle extends StatelessWidget {
  final String title;

  const SelectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        textAlign: TextAlign.left,
        style: GoogleFonts.quicksand(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.grey[500],
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
