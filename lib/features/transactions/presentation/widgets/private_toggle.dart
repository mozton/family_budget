import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivateToggle extends StatefulWidget {
  final bool isPrivate;
  final ValueChanged<bool> onPrivateChanged;

  const PrivateToggle({
    super.key,
    required this.isPrivate,
    required this.onPrivateChanged,
  });

  @override
  State<PrivateToggle> createState() => _PrivateToggleState();
}

class _PrivateToggleState extends State<PrivateToggle> {
  @override
  Widget build(BuildContext context) {
    bool isPrivate = widget.isPrivate;
    final Color primaryPurple = const Color(0xFF9333EA);
    return GestureDetector(
      onTap: () {
        setState(() => isPrivate = !isPrivate);
        widget.onPrivateChanged(isPrivate);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isPrivate
              ? primaryPurple.withValues(alpha: .05)
              : Colors.grey[50],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isPrivate
                ? primaryPurple.withValues(alpha: .05)
                : Colors.grey[100]!,
          ),
        ),
        child: Row(
          children: [
            Text(
              widget.isPrivate ? '🔒' : '🔓',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Gasto Privado",
                    style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.bold,
                      color: widget.isPrivate
                          ? primaryPurple
                          : Colors.grey[700],
                    ),
                  ),
                  Text(
                    "Solo tú verás este detalle",
                    style: GoogleFonts.quicksand(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: isPrivate,
              onChanged: (v) {
                setState(() => isPrivate = v);
                widget.onPrivateChanged(v);
              },
              activeThumbColor: primaryPurple,
            ),
          ],
        ),
      ),
    );
  }
}
