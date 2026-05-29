import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:google_fonts/google_fonts.dart';

class AddCategoryButton extends StatelessWidget {
  final VoidCallback onTap;

  final String name;

  const AddCategoryButton({super.key, required this.onTap, required this.name});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 0),
            height: 64,
            width: 64,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: .15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.grey.withValues(alpha: 0.05),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF9333EA).withValues(alpha: .01),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Center(
              child: Icon(TablerIcons.plus, color: Colors.grey[400], size: 30),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: GoogleFonts.quicksand(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.grey[500],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
