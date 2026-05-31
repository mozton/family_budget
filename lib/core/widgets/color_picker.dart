import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ColorPicker extends StatefulWidget {
  final String title;
  final Color initialColor;
  final ValueChanged<Color> onColorSelected;

  const ColorPicker({
    super.key,
    required this.title,
    required this.initialColor,
    required this.onColorSelected,
  });

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  late Color selectedColor;

  @override
  void initState() {
    super.initState();
    selectedColor = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16, bottom: 16, left: 16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: GoogleFonts.quicksand(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 100,
            width: double.infinity,
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.transparent,
                    Colors.grey,
                    Colors.white,
                    Colors.transparent,
                  ],
                  stops: [0.0, 0.03, 0.95, 1.0],
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstIn,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 5,
                ),
                scrollDirection: Axis.horizontal,
                itemCount: colors.length,
                itemBuilder: (context, index) {
                  final Color color = colors[index];
                  final isSelected = selectedColor == color;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedColor = color;
                        });
                        widget.onColorSelected(color);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(color: Colors.grey[400]!, width: 3)
                              : null,
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: color.withValues(alpha: .4),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : [],
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 24,
                              )
                            : null,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  final List<Color> colors = [
    Color(0xFF9333EA),
    Color(0xFFFF6B6B),
    Color(0xFF4ECDC4),
    Color(0xFFFFD93D),
    Color(0xFF6A0572),
    Color(0xFF1B9C85),
    Color(0xFFFF9F1C),
    Color(0xFF457B9D),
    Color(0xFFA8DADC),
    Color(0xFFE63946),
    Color(0xFFF4A261),
    Color(0xFF10B981),
    Color(0xFF7C3AED),
    Color(0xFFFF8FAB),
    Color(0xFF00C2A8),
    Color(0xFFFFC75F),
    Color(0xFF3A86FF),
    Color(0xFF8338EC),
    Color(0xFFFF006E),
    Color(0xFF06D6A0),
    Color(0xFFFFBE0B),
    Color(0xFF118AB2),
    Color(0xFFEF476F),
    Color(0xFF73C2FB),
    Color(0xFF52B788),
    Color(0xFFFF7F50),
    Color(0xFF9D4EDD),
    Color(0xFF2EC4B6),
    Color(0xFFFF595E),
    Color(0xFF8AC926),
    Color(0xFF1982C4),
    Color(0xFFC77DFF),
  ];
}
