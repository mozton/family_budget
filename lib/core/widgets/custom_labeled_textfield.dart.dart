import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomLabeledTextField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final ValueChanged<String>? plusOrMinus;
  final bool plusMinus;

  const CustomLabeledTextField({
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType,
    this.plusOrMinus,
    this.plusMinus = false,
    super.key,
  });

  @override
  State<CustomLabeledTextField> createState() => _CustomLabeledTextFieldState();
}

class _CustomLabeledTextFieldState extends State<CustomLabeledTextField> {
  final TextEditingController _controller = TextEditingController(text: '-');
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
            widget.label.toUpperCase(),
            style: GoogleFonts.quicksand(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.grey[500],
            ),
          ),
          TextField(
            controller: widget.controller,
            keyboardType: widget.keyboardType ?? TextInputType.text,
            decoration: InputDecoration(
              hintText: widget.hint,
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
