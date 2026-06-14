import 'package:flutter/material.dart';

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
        borderRadius: BorderRadius.circular(16.0), // Bordes redondeados
      ),
      elevation: 0,
      backgroundColor:
          Colors.transparent, // Para que el Container dibuje la sombra
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor, // Se adapta al modo claro/oscuro
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize
              .min, // Hace que el diálogo ocupe solo el espacio necesario
          children: [
            // --- TÍTULO ---
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),

            // --- DETALLE ---
            Text(
              detail,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0,
                color:
                    Colors.grey[700], // Un color más sutil para la descripción
              ),
            ),
            const SizedBox(height: 24.0),

            // --- BOTONES ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Botón de Editar (Acción secundaria)
                OutlinedButton(
                  onPressed: onEdit,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text('Editar'),
                ),

                // Botón de Eliminar (Acción destructiva - Rojo)
                ElevatedButton(
                  onPressed: onDelete,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text('Eliminar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
