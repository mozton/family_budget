import 'package:family_budget/features/categories/domain/entities/category_entity.dart';
import 'package:family_budget/features/categories/presentation/bloc/category_bloc.dart';
import 'package:family_budget/features/categories/presentation/bloc/category_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // 💡 Asegúrate de tener este import para el formato de moneda

class CategoryItem extends StatelessWidget {
  final String name;
  final IconData icon;
  final CategoryType type;
  final Color color;
  final bool isSelected;
  final double amount; // 💡 1. Nueva propiedad para el monto
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const CategoryItem({
    required this.name,
    required this.icon,
    required this.type,
    required this.color,
    required this.isSelected,
    this.amount =
        0.0, // 💡 2. Valor inicial en 0.0 para no romper tu código actual
    this.onTap,
    this.onLongPress,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: onTap,
          onLongPress: onLongPress,
          child: Column(
            mainAxisSize: MainAxisSize.min, // Mantiene la columna compacta
            children: [
              // El contenedor y el icono se quedan EXACTAMENTE igual (64x64)
              AnimatedContainer(
                duration: const Duration(milliseconds: 0),
                height: 64,
                width: 64,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? color.withValues(alpha: .5)
                        : Colors.transparent,
                    width: 2,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(
                              0xFF9333EA,
                            ).withValues(alpha: .1),
                            blurRadius: 10,
                          ),
                        ]
                      : [],
                ),
                child: Center(child: Icon(icon, color: color, size: 30)),
              ),
              const SizedBox(height: 5),

              // Nombre de la categoría
              Text(
                name,
                style: GoogleFonts.quicksand(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? const Color(0xFF1F2937)
                      : Colors.grey[500],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 2), // Un pequeño espacio
              // 💡 3. Nuevo Text para el Balance
              Text(
                "\$${NumberFormat("#,##0", "en_US").format(amount)}",
                style: GoogleFonts.quicksand(
                  fontSize: 9, // Letra un poco más pequeña que el título
                  fontWeight: FontWeight.w700,
                  color: isSelected
                      ? const Color(0xFF1F2937)
                      : Colors.grey[400],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
}
