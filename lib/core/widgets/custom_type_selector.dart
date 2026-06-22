import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTypeSelector extends StatelessWidget {
  final bool isLeftSelected;
  final String leftLabel;
  final String rightLabel;
  final ValueChanged<bool> onChanged;
  final Color? activeColor;

  const CustomTypeSelector({
    super.key,
    required this.isLeftSelected,
    required this.leftLabel,
    required this.rightLabel,
    required this.onChanged,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          _buildOption(context, leftLabel, isLeftSelected, true),
          _buildOption(context, rightLabel, !isLeftSelected, false),
        ],
      ),
    );
  }

  Widget _buildOption(
    BuildContext context,
    String label,
    bool isActive,
    bool isLeft,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (!isActive) {
            onChanged(isLeft);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 0),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .05),
                      blurRadius: 10,
                    ),
                  ]
                : [],
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.quicksand(
              fontWeight: FontWeight.bold,
              color: isActive ? const Color(0xFF1F2937) : Colors.grey[400],
            ),
          ),
        ),
      ),
    );
  }
}
