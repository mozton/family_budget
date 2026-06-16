import 'dart:math';

import 'package:family_budget/core/widgets/color_picker.dart';
import 'package:family_budget/core/widgets/custom_labeled_textfield.dart.dart';
import 'package:family_budget/features/accounts/presentation/bloc/account_bloc.dart';
import 'package:family_budget/features/accounts/presentation/bloc/account_event.dart';
import 'package:family_budget/features/accounts/presentation/widgets/widget_type_option.dart';
import 'package:flutter/material.dart';
import 'package:family_budget/features/accounts/domain/entities/account_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:google_fonts/google_fonts.dart';

class EditAccountScreen extends StatefulWidget {
  final AccountEntity account;

  const EditAccountScreen({super.key, required this.account});

  @override
  State<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _balanceController;
  Color? _color;
  AccountType _currentSelectedType = AccountType.bank;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.account.name);
    _balanceController = TextEditingController(
      text: widget.account.balance.toString(),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Editar Cuenta',
            style: GoogleFonts.quicksand(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(TablerIcons.arrow_back),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  WidgetTypeOption(
                    onTypeChange: (AccountType newType) {
                      setState(() {
                        _currentSelectedType = newType;
                      });
                    },
                    initialType: _currentSelectedType,
                  ),

                  SizedBox(height: 15),

                  ColorPicker(
                    title: 'Color de la cuenta',
                    initialColor: widget.account.color,
                    onColorSelected: (Color newColor) {
                      setState(() {
                        _color = newColor;
                      });
                    },
                  ),
                  const SizedBox(height: 15),

                  CustomLabeledTextField(
                    label: 'Nombre de la Cuenta',
                    hint: 'Ej: Tarjeta Visa, Cuenta Nómina...',
                    controller: _nameController,
                  ),
                  const SizedBox(height: 15),

                  // Saldo Inicial
                  CustomLabeledTextField(
                    label: 'Saldo / Balance Inicial',
                    hint: '\$0.00',
                    controller: _balanceController,
                    keyboardType: TextInputType.numberWithOptions(),
                  ),
                  SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        final updateAccount = AccountEntity(
                          id: widget.account.id,
                          remoteId: widget.account.remoteId,
                          name: _nameController.text,
                          icon: widget.account.icon,
                          color: _color ?? widget.account.color,
                          type: _currentSelectedType,
                          balance:
                              double.tryParse(_balanceController.text) ?? 0,
                          isPrivate: widget.account.isPrivate,
                          ownerId: widget.account.ownerId,
                        );

                        context.read<AccountBloc>().add(
                          UpdateAccountEvent(updateAccount),
                        );
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 5,
                        shadowColor: Colors.purple.withValues(alpha: 0.4),
                      ),
                      child: Text(
                        "Actualizar Cuenta",
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
        ),
      ),
    );
  }
}
