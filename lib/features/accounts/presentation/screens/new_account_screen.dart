import 'package:family_budget/core/widgets/color_picker.dart';
import 'package:family_budget/core/widgets/custom_labeled_textfield.dart.dart';
import 'package:family_budget/features/accounts/domain/entities/account_entity.dart';
import 'package:family_budget/features/accounts/presentation/bloc/account_bloc.dart';
import 'package:family_budget/features/accounts/presentation/bloc/account_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

// NOTA: Asegúrate de tener tu AccountBloc creado para manejar el guardado
// import 'package:family_budget/features/accounts/presentation/bloc/account_bloc.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

class NewAccountScreen extends StatefulWidget {
  const NewAccountScreen({super.key});

  @override
  State<NewAccountScreen> createState() => _NewAccountScreenState();
}

class _NewAccountScreenState extends State<NewAccountScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController balanceController = TextEditingController();
  Color accountColor = Colors.grey;
  AccountType selectedType = AccountType.bank;

  final Color primaryPurple = const Color(0xFF9333EA);

  @override
  void dispose() {
    nameController.dispose();
    balanceController.dispose();
    super.dispose();
  }

  IconData getBackgroundColor() {
    switch (selectedType) {
      case AccountType.bank:
        return TablerIcons.building_bank;
      case AccountType.cash:
        return TablerIcons.cash;
      case AccountType.creditCard:
        return TablerIcons.credit_card;
    }
  }

  void _onColorPicked(Color color) {
    setState(() {
      accountColor = color;
    });
    // Aquí puedes guardar el color, enviarlo a una API, etc.
    print('Color recibido: $color');
  }

  void _saveAccount() {
    if (nameController.text.isEmpty || balanceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor llena todos los campos')),
      );
      return;
    }

    final newAccount = AccountEntity(
      id: '', // Se genera en el mapper/Isar
      remoteId: Uuid().v4(),
      name: nameController.text,
      type: selectedType,
      balance: double.tryParse(balanceController.text) ?? 0.0,
      isPrivate: false,
      ownerId: 'current_user_id',
      icon: getBackgroundColor(),
      color: accountColor,
    );

    context.read<AccountBloc>().add(CreateAccountEvent(newAccount));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFFDFBFF),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(TablerIcons.arrow_back, color: Colors.grey),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Nueva Cuenta',
            style: GoogleFonts.quicksand(
              color: const Color(0xFF1F2937),
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Selector de Tipo de Cuenta
              Text(
                "TIPO DE CUENTA",
                style: GoogleFonts.quicksand(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[500],
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _buildTypeOption(
                    AccountType.cash,
                    'Efectivo',
                    TablerIcons.cash,
                    accountColor,
                  ),
                  const SizedBox(width: 12),
                  _buildTypeOption(
                    AccountType.bank,
                    'Banco',
                    TablerIcons.building_bank,
                    accountColor,
                  ),
                  const SizedBox(width: 12),
                  _buildTypeOption(
                    AccountType.creditCard,
                    'Crédito',
                    TablerIcons.credit_card,
                    accountColor,
                  ),
                ],
              ),
              SizedBox(height: 15),
              ColorPicker(
                title: 'Color de la cuenta',
                initialColor: accountColor,
                onColorSelected: _onColorPicked,
              ),
              const SizedBox(height: 20),

              CustomLabeledTextField(
                label: 'Nombre de la Cuenta',
                hint: 'Ej: Tarjeta Visa, Cuenta Nómina...',
                controller: nameController,
              ),
              const SizedBox(height: 24),

              // Saldo Inicial
              CustomLabeledTextField(
                label: 'Saldo / Balance Inicial',
                hint: '\$0.00',
                controller: balanceController,
                keyboardType: TextInputType.numberWithOptions(),
              ),

              const SizedBox(height: 12),
              Text(
                selectedType == AccountType.creditCard
                    ? "💡 Nota: En tarjetas de crédito, si debes dinero, ingresa el monto en negativo (ej: -500)."
                    : "💡 Ingresa el dinero actual disponible en esta cuenta.",
                style: GoogleFonts.quicksand(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[500],
                ),
              ),

              const SizedBox(height: 60),

              // Botón Guardar
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _saveAccount,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 5,
                    shadowColor: primaryPurple.withOpacity(0.4),
                  ),
                  child: Text(
                    "Crear Cuenta",
                    style: GoogleFonts.quicksand(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeOption(
    AccountType type,
    String label,
    IconData icon,
    Color color,
  ) {
    final isSelected = selectedType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedType = type),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? color.withValues(alpha: 0.1) : Colors.grey[50],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? color : Colors.grey[200]!,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? color : Colors.grey[400],
                size: 28,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: GoogleFonts.quicksand(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected ? color : Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
