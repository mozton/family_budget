import 'package:family_budget/features/accounts/presentation/bloc/account_bloc.dart';
import 'package:family_budget/features/accounts/presentation/bloc/account_event.dart';
import 'package:family_budget/features/accounts/presentation/bloc/account_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:google_fonts/google_fonts.dart';

class DeleteAccountOrCategoryDialog extends StatelessWidget {
  final String title;
  final String detail;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const DeleteAccountOrCategoryDialog({
    super.key,
    required this.title,
    required this.detail,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          32.0,
        ), // Bordes súper redondeados acorde a la app
      ),
      elevation: 0,
      backgroundColor: Colors
          .transparent, // Permite que el Container maneje el fondo y las sombras
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 28.0),
        decoration: BoxDecoration(
          color: const Color(0xFFFDFBFF), // Color de fondo Canvas de la app
          borderRadius: BorderRadius.circular(32.0),
          boxShadow: [
            BoxShadow(
              color: const Color(
                0xFF9333EA,
              ).withValues(alpha: 0.1), // Sombra suave morada
              blurRadius: 20.0,
              offset: const Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Ocupa solo el espacio necesario
          children: [
            // --- HEADER VISUAL (Icono de alerta estilizado) ---
            const Icon(
              TablerIcons.alert_circle,
              color: Color(0xFFEF4444),
              size: 42,
            ),
            const SizedBox(height: 20.0),

            // --- TÍTULO ---
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.quicksand(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 12.0),

            // --- DETALLE ---
            Text(
              detail,
              textAlign: TextAlign.center,
              style: GoogleFonts.quicksand(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                color: Colors.grey[500],
                height: 1.4,
              ),
            ),
            const SizedBox(height: 28.0),

            // --- BOTONES ---
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      onEdit();
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3E8FF), // Lila pastel de fondo
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFE9D5FF),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Editar',
                          style: GoogleFonts.quicksand(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF9333EA),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),

                // Botón de Eliminar (Acción destructiva - Rojo coral con sombra)
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      onDelete();
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFFEF4444,
                            ).withValues(alpha: 0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'Eliminar',
                          style: GoogleFonts.quicksand(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
