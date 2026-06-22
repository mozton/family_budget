import 'package:family_budget/core/widgets/color_picker.dart';
import 'package:family_budget/core/widgets/custom_labeled_textfield.dart.dart';
import 'package:family_budget/core/widgets/custom_type_selector.dart';
import 'package:family_budget/features/transactions/presentation/widgets/generic_button.dart';
import 'package:family_budget/features/categories/presentation/bloc/category_bloc.dart';
import 'package:family_budget/features/categories/presentation/bloc/category_event.dart';
import 'package:family_budget/features/categories/presentation/bloc/category_state.dart';
import 'package:family_budget/features/transactions/domiain/entities/transaction_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

class NewCategoryScreen extends StatefulWidget {
  final String type;
  const NewCategoryScreen({super.key, required this.type});

  @override
  State<NewCategoryScreen> createState() => _NewCategoryScreenState();
}

class _NewCategoryScreenState extends State<NewCategoryScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController limitController = TextEditingController();

  late IconData selectedIcon;

  final List<IconData> availableIcons = [
    TablerIcons.shopping_cart,
    TablerIcons.shopping_bag,
    TablerIcons.home,
    TablerIcons.car,
    TablerIcons.heart,
    TablerIcons.device_gamepad_2,
    TablerIcons.coffee,
    TablerIcons.leaf,
    TablerIcons.plane,
    TablerIcons.cash,
    TablerIcons.school,
    TablerIcons.shirt,
    TablerIcons.bus,
    TablerIcons.tools,
    TablerIcons.gift,
    TablerIcons.moneybag,
    TablerIcons.building_community,
    TablerIcons.candle,
    TablerIcons.beach,
    TablerIcons.bottle,
    TablerIcons.pills,
    TablerIcons.palette,
    TablerIcons.building_store,
    TablerIcons.bulb,
    TablerIcons.gas_station,
    TablerIcons.briefcase,
    TablerIcons.network,
    TablerIcons.credit_card,
    TablerIcons.gift,
    TablerIcons.pig_money,

    // Nuevos iconos para Budget Family
    TablerIcons.wallet,
    TablerIcons.wallet_off,
    TablerIcons.coin,
    TablerIcons.coins,
    TablerIcons.receipt,
    TablerIcons.receipt_tax,
    TablerIcons.report_money,
    TablerIcons.chart_bar,
    TablerIcons.chart_pie,
    TablerIcons.chart_line,
    TablerIcons.trending_up,
    TablerIcons.trending_down,
    TablerIcons.calculator,
    TablerIcons.percentage,

    TablerIcons.building_bank,
    TablerIcons.users,
    TablerIcons.user_heart,
    TablerIcons.baby_carriage,
    TablerIcons.dog,
    TablerIcons.cat,
    TablerIcons.stethoscope,
    TablerIcons.medicine_syrup,
    TablerIcons.dental,
    TablerIcons.ambulance,
    TablerIcons.flame,
    TablerIcons.bolt,
    TablerIcons.device_tv,
    TablerIcons.wifi,
    TablerIcons.phone,
    TablerIcons.devices_pc,
    TablerIcons.smart_home,
    TablerIcons.router,
    TablerIcons.movie,
    TablerIcons.music,
    TablerIcons.book,
    TablerIcons.run,
    TablerIcons.barbell,
    TablerIcons.basket,
    TablerIcons.chef_hat,
    TablerIcons.tools_kitchen_2,
    TablerIcons.ice_cream_2,
    TablerIcons.pizza,
    TablerIcons.apple,
    TablerIcons.salad,

    TablerIcons.train,
    TablerIcons.bike,
    TablerIcons.motorbike,
    TablerIcons.map_pin,
    TablerIcons.package,
    TablerIcons.box,
    TablerIcons.clipboard_list,
    TablerIcons.calendar_month,
    TablerIcons.clock,
    TablerIcons.alarm,
    TablerIcons.camera,
    TablerIcons.device_mobile,
    TablerIcons.sofa,
    TablerIcons.wash_machine,
    TablerIcons.air_conditioning,
    TablerIcons.paint,
    TablerIcons.hammer,

    TablerIcons.brand_apple,
    TablerIcons.brand_spotify,
    TablerIcons.brand_netflix,
    TablerIcons.brand_amazon,
    TablerIcons.brand_paypal,
    TablerIcons.brand_visa,
    TablerIcons.brand_mastercard,
    TablerIcons.brand_tether,
  ];

  bool isPrivate = false;
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

    // Nuevos colores
    Color(0xFF7C3AED), // violeta intenso
    Color(0xFFFF8FAB), // rosado suave
    Color(0xFF00C2A8), // turquesa vivo
    Color(0xFFFFC75F), // amarillo cálido
    Color(0xFF3A86FF), // azul brillante
    Color(0xFF8338EC), // púrpura eléctrico
    Color(0xFFFF006E), // magenta fuerte
    Color(0xFF06D6A0), // verde aqua
    Color(0xFFFFBE0B), // amarillo dorado
    Color(0xFF118AB2), // azul océano
    Color(0xFFEF476F), // coral rosado
    Color(0xFF73C2FB), // azul cielo
    Color(0xFF52B788), // verde moderno
    Color(0xFFFF7F50), // coral
    Color(0xFF9D4EDD), // lila vibrante
    Color(0xFF2EC4B6), // aqua pastel
    Color(0xFFFF595E), // rojo suave
    Color(0xFF8AC926), // verde lima
    Color(0xFF1982C4), // azul limpio
    Color(0xFFC77DFF), // púrpura pastel
  ];

  late Color colorSelected;
  late String typeSelected;

  final Color primaryPurple = const Color(0xFF9333EA);
  final Color background = const Color(0xFFFDFBFF);

  @override
  void initState() {
    super.initState();
    colorSelected = colors.first;
    typeSelected = widget.type;
    selectedIcon = availableIcons.first;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: background,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.grey),
                onPressed: () => Navigator.pop(context),
              ),

              // ____Title______________________________________
              title: Text(
                'Nueva Categoría',
                style: GoogleFonts.quicksand(
                  color: const Color(0xFF1F2937),
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // _buildTypeSelector(),
                  CustomTypeSelector(
                    isLeftSelected: typeSelected == 'expense',
                    leftLabel: 'Gasto',
                    rightLabel: 'Ingreso',
                    onChanged: (type) {
                      setState(() {
                        typeSelected = type ? 'expense' : 'income';
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomLabeledTextField(
                    label: 'Nombre de la Categoria',
                    hint: 'Ej: Compras',
                    controller: titleController,
                  ),
                  const SizedBox(height: 20),
                  CustomLabeledTextField(
                    label: 'Presupuesto de la Categoria',
                    hint: 'Ej. 5,000.00',
                    controller: limitController,
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),

                  const SizedBox(height: 20),
                  _buildIconSelector(context),

                  const SizedBox(height: 30),

                  ColorPicker(
                    title: 'COLOR DE LA CATEGORIA',
                    initialColor: colorSelected,
                    onColorSelected: (color) {
                      setState(() {
                        colorSelected = color;
                      });
                    },
                  ),
                  const SizedBox(height: 30),

                  // _buildSubmitButton(),
                  AnimatedGenericButton(
                    label: ' Guardar Categoria',
                    onPressed: () {
                      final uuid = const Uuid().v4();
                      final newCategory = CreateCategory(
                        name: titleController.text,
                        icon: selectedIcon,
                        color: colorSelected,
                        type: typeSelected,
                        currentAmount: 0,
                        remoteId: uuid,
                        vaultId: 'vault_12345',
                        targetAmount: limitController.text.isNotEmpty
                            ? double.tryParse(limitController.text) ?? 0.0
                            : 0.0,
                      );
                      context.read<CategoryBloc>().add(newCategory);

                      Navigator.pop(context);
                    },
                    colors: [Colors.purple, Colors.purpleAccent],
                    type: TransactionType.values.firstWhere(
                      (e) => e.name == typeSelected,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIconSelector(BuildContext context) {
    return GestureDetector(
      onTap: () => _showIconPicker(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: colorSelected.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(selectedIcon, color: colorSelected),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "ICONO".toUpperCase(),
                    style: GoogleFonts.quicksand(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[500],
                    ),
                  ),
                  Text(
                    "Toca para cambiar",
                    style: GoogleFonts.quicksand(
                      color: const Color(0xFF1F2937),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  void _showIconPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      // isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * .8,
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                "Selecciona un icono",
                style: GoogleFonts.quicksand(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                  ),
                  itemCount: availableIcons.length,
                  itemBuilder: (context, index) {
                    final icon = availableIcons[index];
                    final isSelected = selectedIcon == icon;
                    return GestureDetector(
                      onTap: () {
                        setState(() => selectedIcon = icon);
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? primaryPurple : Colors.grey[50],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? primaryPurple
                                : Colors.transparent,
                          ),
                        ),
                        child: Icon(
                          icon,
                          color: isSelected ? Colors.white : Colors.grey[600],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}
