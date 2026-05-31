// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class GenericButton extends StatelessWidget {
//   final String label;
//   final VoidCallback onPressed;
//   final List<Color> colors;

//   const GenericButton({
//     super.key,
//     required this.label,
//     required this.onPressed,
//     required this.colors,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       height: 60,
//       decoration: BoxDecoration(
//         gradient: LinearGradient(colors: colors),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Color(0xFFA18CD1).withOpacity(0.3),
//             blurRadius: 20,
//             offset: const Offset(0, 10),
//           ),
//         ],
//       ),
//       child: ElevatedButton(
//         onPressed: onPressed,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.transparent,
//           shadowColor: Colors.transparent,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//         ),
//         child: Text(
//           label,
//           style: GoogleFonts.quicksand(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:family_budget/features/transactions/domiain/entities/transaction_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// Definimos el tipo para saber qué sonidos y vibraciones usar

class AnimatedGenericButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final List<Color> colors;
  final TransactionType
  type; // 🔑 Requerido para saber el comportamiento de feedback
  final bool isLoading; // Muestra un spinner si el guardado tarda

  const AnimatedGenericButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.colors,
    required this.type,
    this.isLoading = false,
  });

  @override
  State<AnimatedGenericButton> createState() => _AnimatedGenericButtonState();
}

class _AnimatedGenericButtonState extends State<AnimatedGenericButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    // Controlador para la micro-interacción de compresión elástica
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.92,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // 🔑 Ejecuta el patrón de vibración física correspondiente
  void _triggerHapticFeedback() {
    switch (widget.type) {
      case TransactionType.expense:
        HapticFeedback.mediumImpact(); // Golpe seco y firme
        break;
      case TransactionType.income:
        HapticFeedback.lightImpact(); // Ligero y positivo
        Future.delayed(const Duration(milliseconds: 80), () {
          HapticFeedback.lightImpact(); // Doble toque sutil
        });
        break;
      case TransactionType.transfer:
        HapticFeedback.selectionClick(); // Sensación de deslizamiento de rueda
        break;
    }
  }

  // 🔑 Lógica para disparar el sonido correspondiente
  void _triggerSoundFeedback() {
    // NOTA: Aquí invocarás tu servicio de audio en el futuro.
    // De momento, reproducimos el clic de sistema por defecto para que funcione de inmediato.
    SystemSound.play(SystemSoundType.click);

    // Cuando agregues tus assets .mp3, esta lógica se verá así:
    /*
    switch (widget.type) {
      case TransactionType.expense:
        AudioService.play('sounds/expense_swoosh.mp3');
        break;
      case TransactionType.income:
        AudioService.play('sounds/income_coins.mp3');
        break;
      case TransactionType.transfer:
        AudioService.play('sounds/transfer_flow.mp3');
        break;
    }
    */
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.isLoading) {
      _controller.forward(); // Achica el botón al poner el dedo
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.isLoading) {
      _controller.reverse(); // Lo devuelve a su tamaño normal con rebote
    }
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = widget.colors.isNotEmpty
        ? widget.colors.first
        : const Color(0xFFA18CD1);

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: () {
        if (widget.isLoading) return;

        // Disparamos las sensaciones físicas y auditivas al mismo milisegundo
        _triggerHapticFeedback();
        _triggerSoundFeedback();

        // Ejecutamos la acción original de registrar
        widget.onPressed();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: widget.colors),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: activeColor.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Center(
                child: widget.isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Text(
                        widget.label,
                        style: GoogleFonts.quicksand(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}
