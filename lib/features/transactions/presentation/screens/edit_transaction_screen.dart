import 'package:family_budget/core/widgets/date_time_picker.dart';
import 'package:family_budget/features/categories/domain/entities/category_entity.dart'
    hide CategoryType;
import 'package:family_budget/features/categories/presentation/bloc/category_bloc.dart';
import 'package:family_budget/features/categories/presentation/bloc/category_state.dart';

import 'package:family_budget/features/transactions/domiain/entities/transaction_entity.dart';
import 'package:family_budget/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:family_budget/features/transactions/presentation/bloc/transaction_event.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class EditTransactionScreen extends StatefulWidget {
  final TransactionEntity transaction;

  const EditTransactionScreen({super.key, required this.transaction});

  @override
  State<EditTransactionScreen> createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountController;
  late TextEditingController _noteController;
  late DateTime _dateTime;

  late TransactionType _selectedType;

  late bool _isPrivate;
  CategoryEntity? _selectedCategory;

  @override
  void initState() {
    super.initState();
    // Inicializamos los valores con los datos existentes de la transacción
    _amountController = TextEditingController(
      text: widget.transaction.amount.toStringAsFixed(2),
    );
    _noteController = TextEditingController(text: widget.transaction.note);
    _selectedType = widget.transaction.transactionType;
    _dateTime = widget.transaction.date;
    _isPrivate = widget.transaction.isPrivate;
    _selectedCategory = widget.transaction.category;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF1F2937),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Editar Transacción",
          style: GoogleFonts.quicksand(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1F2937),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Selector de Tipo (Gasto / Ingreso / Transferencia)
                _buildTypeSelector(),
                const SizedBox(height: 32),

                // Input de Monto Estilizado
                _buildAmountInput(),
                const SizedBox(height: 32),

                // Lista de Categorías de tu CategoryBloc
                Text(
                  "Selecciona una Categoría",
                  style: GoogleFonts.quicksand(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 12),
                _buildCategoryList(),
                const SizedBox(height: 32),

                // Nota de Transacción
                _buildNoteInput(),
                const SizedBox(height: 20),

                // Fecha de Transacción
                DateTimePicker(
                  selectedDate: _dateTime,
                  onDateSelected: (date) {
                    setState(() {
                      _dateTime = date;
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Toggle de Privacidad (Bóveda Personal vs Compartida 🔒)
                _buildPrivacyToggle(),
                const SizedBox(height: 40),

                // Botón para Guardar Cambios
                _buildSaveButton(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: TransactionType.values.map((type) {
          final isSelected = _selectedType == type;
          String label = "";
          Color activeColor = const Color(0xFF9333EA);

          switch (type) {
            case TransactionType.expense:
              label = "Gasto";
              activeColor = Colors.redAccent;
              break;
            case TransactionType.income:
              label = "Ingreso";
              activeColor = Colors.green;
              break;
            case TransactionType.transfer:
              label = "Traspaso";
              activeColor = Colors.blueAccent;
              break;
          }

          return Expanded(
            child: GestureDetector(
              onTap: () => setState(
                () => _selectedType = type,
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Center(
                  child: Text(
                    label,
                    style: GoogleFonts.quicksand(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? activeColor : Colors.grey[400],
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAmountInput() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "CANTIDAD",
            style: GoogleFonts.quicksand(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.grey[400],
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "\$",
                style: GoogleFonts.quicksand(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: _selectedType == TransactionType.expense
                      ? Colors.red[300]
                      : _selectedType == TransactionType.income
                      ? Colors.green[300]
                      : Colors.blue[300],
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 180,
                child: TextFormField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.quicksand(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1F2937),
                  ),
                  decoration: const InputDecoration(
                    hintText: "0.00",
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Ingresa un monto";
                    }
                    if (double.tryParse(value) == null) {
                      return "Monto no válido";
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList() {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        // En tu estado real, asumo que tienes 'state.categories' o similar.
        // Si no está cargado o tu lista es dinámica:
        final categories = state.categories;

        if (categories.isEmpty) {
          return Center(
            child: Text(
              "No hay categorías creadas aún",
              style: GoogleFonts.quicksand(color: Colors.grey),
            ),
          );
        }

        return SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              final isSelected = _selectedCategory?.id == cat.id;

              return Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedCategory = cat),
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 64,
                        width: 64,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFF3E8FF)
                              : Colors.grey[50],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFFD8B4FE)
                                : Colors.transparent,
                            width: 2,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF9333EA,
                                    ).withValues(alpha: 0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : [],
                        ),
                        child: Center(
                          child: Icon(
                            cat.icon,
                            size: 28,
                            color: isSelected
                                ? const Color(0xFF9333EA)
                                : const Color(0xFF1F2937),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        cat.name,
                        style: GoogleFonts.quicksand(
                          fontSize: 10,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color: isSelected
                              ? const Color(0xFF1F2937)
                              : Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildNoteInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "NOTA / DESCRIPCIÓN",
            style: GoogleFonts.quicksand(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: Colors.grey[400],
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          TextFormField(
            controller: _noteController,
            style: GoogleFonts.quicksand(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1F2937),
            ),
            decoration: const InputDecoration(
              hintText: "Ej: Supermercado semanal",
              border: InputBorder.none,
              isDense: true,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Ingresa una descripción";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyToggle() {
    return InkWell(
      onTap: () => setState(() => _isPrivate = !_isPrivate),
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _isPrivate ? const Color(0xFFFAF5FF) : Colors.grey[50],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _isPrivate ? const Color(0xFFE9D5FF) : Colors.grey[100]!,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  _isPrivate ? "🔒" : "🔓",
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Gasto Privado",
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.bold,
                        color: _isPrivate
                            ? const Color(0xFF701A75)
                            : const Color(0xFF1F2937),
                      ),
                    ),
                    Text(
                      "No se mostrará en el feed de tu pareja",
                      style: GoogleFonts.quicksand(
                        fontSize: 10,
                        color: Colors.grey[400],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Switch(
              value: _isPrivate,
              activeColor: const Color(0xFF9333EA),
              onChanged: (value) => setState(() => _isPrivate = value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          final amount = double.parse(_amountController.text);
          final note = _noteController.text;
          final updatedTransaction = TransactionEntity(
            id: widget.transaction.id,
            remoteId: widget.transaction.remoteId,
            amount: amount,
            note: note,
            date: _dateTime,
            isPrivate: _isPrivate,
            ownerId: widget.transaction.ownerId,
            transactionType: _selectedType,
            category: _selectedCategory,
          );

          // Disparamos el evento de actualización en nuestro BLoC de transacciones
          context.read<TransactionBloc>().add(
            UpdateTransactionEvent(updatedTransaction),
          );

          // Regresamos a la pantalla anterior
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF9333EA),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 4,
          shadowColor: const Color(0xFF9333EA).withOpacity(0.2),
        ),
        child: Text(
          "GUARDAR CAMBIOS",
          style: GoogleFonts.quicksand(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}
