import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AccountItem extends StatelessWidget {
  final String name;
  final double amount;
  final bool isSelected;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  AccountItem({
    super.key,
    required this.name,
    required this.amount,
    required this.isSelected,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 0),
              height: 64,
              width: 64,
              decoration: BoxDecoration(
                color: isSelected
                    ? color.withValues(alpha: 0.20)
                    : color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? color : Colors.transparent,
                  width: 2,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: color.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: 30,
                  color: isSelected ? color : color.withValues(alpha: 0.8),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              name,
              style: GoogleFonts.quicksand(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? const Color(0xFF1F2937) : Colors.grey[800],
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2), // Un pequeño espacio
            // 💡 3. Nuevo Text para el Balance
            Text(
              "\$${NumberFormat("#,##0", "en_US").format(amount)}",
              style: GoogleFonts.quicksand(
                fontSize: 9, // Letra un poco más pequeña que el título
                fontWeight: FontWeight.w700,
                color: isSelected ? const Color(0xFF1F2937) : Colors.grey[400],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
