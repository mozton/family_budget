import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectorItem {
  final String id;
  final String name;
  final IconData icon;
  final Color color;

  SelectorItem({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });
}

class HorizontalItemSelector extends StatelessWidget {
  final List<SelectorItem> items;
  final String? selectedItemId;
  final Function(SelectorItem) onItemSelected;
  final String emptyMessage;

  const HorizontalItemSelector({
    super.key,
    required this.items,
    required this.selectedItemId,
    required this.onItemSelected,
    this.emptyMessage = "No hay elementos disponibles",
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          style: GoogleFonts.quicksand(color: Colors.grey),
        ),
      );
    }

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final isSelected = selectedItemId == item.id;

          return Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () => onItemSelected(item),
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 64,
                    width: 64,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFF3E8FF)
                          : Colors.grey[50],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFFD8B4FE)
                            : Colors.transparent,
                        width: 2,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: const Color(
                                  0xFF9333EA,
                                ).withValues(alpha: 0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [],
                    ),
                    child: Center(
                      child: Icon(
                        item.icon,
                        size: 28,
                        color: isSelected
                            ? const Color(0xFF9333EA)
                            : item.color,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.name,
                    style: GoogleFonts.quicksand(
                      fontSize: 10,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                      color: isSelected
                          ? const Color(0xFF1F2937)
                          : Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
