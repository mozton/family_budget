import 'package:family_budget/features/accounts/domain/entities/account_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:google_fonts/google_fonts.dart';

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

  AccountType selectedType = AccountType.bank;

  final Color primaryPurple = const Color(0xFF9333EA);

  @override
  void dispose() {
    nameController.dispose();
    balanceController.dispose();
    super.dispose();
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
      remoteId: '', // Se generará con UUID en el BLoC
      name: nameController.text,
      type: selectedType,
      balance: double.tryParse(balanceController.text) ?? 0.0,
      isPrivate: false,
      ownerId: 'current_user_id', // Reemplazar con tu lógica de usuario
    );

    // TODO: Descomenta esto cuando tengas tu AccountBloc listo
    // context.read<AccountBloc>().add(CreateAccountEvent(newAccount));

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
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildTypeOption(
                    AccountType.cash,
                    'Efectivo',
                    TablerIcons.cash,
                  ),
                  const SizedBox(width: 12),
                  _buildTypeOption(
                    AccountType.bank,
                    'Banco',
                    TablerIcons.building_bank,
                  ),
                  const SizedBox(width: 12),
                  _buildTypeOption(
                    AccountType.creditCard,
                    'Crédito',
                    TablerIcons.credit_card,
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Nombre de la cuenta
              _buildCustomTextField(
                label: "Nombre de la Cuenta",
                hint: "Ej: Tarjeta Visa, Cuenta Nómina...",
                controller: nameController,
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 24),

              // Saldo Inicial
              _buildCustomTextField(
                label: "Saldo / Balance Inicial",
                hint: "0.00",
                controller: balanceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                prefixIcon: const Icon(
                  TablerIcons.currency_dollar,
                  color: Colors.grey,
                ),
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

  Widget _buildTypeOption(AccountType type, String label, IconData icon) {
    final isSelected = selectedType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedType = type),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected
                ? primaryPurple.withOpacity(0.1)
                : Colors.grey[50],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? primaryPurple : Colors.grey[200]!,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? primaryPurple : Colors.grey[400],
                size: 28,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: GoogleFonts.quicksand(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected ? primaryPurple : Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required TextInputType keyboardType,
    Widget? prefixIcon,
  }) {
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
            label.toUpperCase(),
            style: GoogleFonts.quicksand(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.grey[500],
              letterSpacing: 1.2,
            ),
          ),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: GoogleFonts.quicksand(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1F2937),
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.quicksand(
                color: Colors.grey[400],
                fontWeight: FontWeight.w600,
              ),
              border: InputBorder.none,
              isDense: true,
              prefixIcon: prefixIcon,
              prefixIconConstraints: const BoxConstraints(
                minWidth: 40,
                minHeight: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
