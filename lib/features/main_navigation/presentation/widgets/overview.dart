import 'package:family_budget/features/accounts/domain/entities/account_entity.dart';
import 'package:family_budget/features/accounts/presentation/bloc/account_bloc.dart';
import 'package:family_budget/features/accounts/presentation/bloc/account_state.dart';
import 'package:family_budget/features/categories/domain/entities/category_entity.dart';
import 'package:family_budget/features/categories/presentation/bloc/category_bloc.dart';
import 'package:family_budget/features/categories/presentation/bloc/category_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AccountsOverviewWidget extends StatelessWidget {
  const AccountsOverviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAccountsSection(context),
        const SizedBox(height: 24),
        _buildCategoriesSection(context),
      ],
    );
  }

  // --- SECCIÓN DE CUENTAS ---

  Widget _buildAccountsSection(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, state) {
        if (state.isLoading && state.accounts.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF9333EA)),
          );
        }

        final accounts = state.accounts;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Mis Cuentas",
                    style: GoogleFonts.quicksand(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF374151),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/new_account'),
                    child: Text(
                      "AÑADIR",
                      style: GoogleFonts.quicksand(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF9333EA),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 140,
              child: accounts.isEmpty
                  ? _buildEmptyAccountsState(context)
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      physics: const BouncingScrollPhysics(),
                      itemCount:
                          accounts.length +
                          1, // +1 para el botón de "Añadir" al final
                      itemBuilder: (context, index) {
                        if (index == accounts.length) {
                          return _buildAddAccountCard(context);
                        }
                        return _buildAccountCard(accounts[index]);
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAccountCard(AccountEntity account) {
    Color startColor;
    Color endColor;
    IconData icon;

    switch (account.type) {
      case AccountType.creditCard:
        startColor = const Color(0xFFA18CD1);
        endColor = const Color(0xFFFBC2EB);
        icon = TablerIcons.credit_card;
        break;
      case AccountType.cash:
        startColor = const Color(0xFF84fab0);
        endColor = const Color(0xFF8fd3f4);
        icon = TablerIcons.cash;
        break;
      case AccountType.bank:
        startColor = const Color(0xFF60A5FA);
        endColor = const Color(0xFF3B82F6);
        icon = TablerIcons.building_bank;
        break;
    }

    return Container(
      width: 140,
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [startColor, endColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: startColor.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              if (account.isPrivate)
                const Icon(TablerIcons.lock, color: Colors.white, size: 16),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                account.name,
                style: GoogleFonts.quicksand(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                "\$${NumberFormat("#,##0.00", "en_US").format(account.balance)}",
                style: GoogleFonts.quicksand(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddAccountCard(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/new_account'),
      child: Container(
        width: 100,
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.grey[300]!,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: const Icon(TablerIcons.plus, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              "Nueva",
              style: GoogleFonts.quicksand(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyAccountsState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, '/new_account'),
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            color: const Color(0xFFF3E8FF),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFE9D5FF), width: 2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                TablerIcons.building_bank,
                color: Color(0xFF9333EA),
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                "Aún no tienes cuentas",
                style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF701A75),
                ),
              ),
              Text(
                "Toca aquí para crear una",
                style: GoogleFonts.quicksand(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF9333EA).withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- SECCIÓN DE CATEGORÍAS ---

  Widget _buildCategoriesSection(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state.isLoading && state.categories.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF9333EA)),
          );
        }

        final categories = state.categories;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Categorías Frecuentes",
                    style: GoogleFonts.quicksand(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF374151),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/new_category',
                        arguments: {
                          'type': 'expense',
                          'title': 'Nueva Categoría',
                          'action': 'Guardar Categoría',
                        },
                      );
                    },
                    child: Text(
                      "AÑADIR",
                      style: GoogleFonts.quicksand(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF9333EA),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height:
                  120, // Altura ligeramente menor que las tarjetas de cuenta
              child: categories.isEmpty
                  ? _buildEmptyCategoriesState(context)
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      physics: const BouncingScrollPhysics(),
                      itemCount: categories.length + 1,
                      itemBuilder: (context, index) {
                        if (index == categories.length) {
                          return _buildAddCategoryCard(context);
                        }
                        return _buildCategoryCard(categories[index]);
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategoryCard(CategoryEntity category) {
    final catColor = category.color ?? const Color(0xFF9333EA);
    // Calculamos el porcentaje, protegiendo contra división por cero
    final limit = category.targetAmount ?? 0.0;
    final percent = limit > 0
        ? (category.currentAmount / limit).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      width: 110,
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              color: catColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(category.icon, color: catColor, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            category.name,
            style: GoogleFonts.quicksand(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1F2937),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          // Mini barra de progreso
          Container(
            height: 4,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percent,
              child: Container(
                decoration: BoxDecoration(
                  color: catColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "\$${NumberFormat("#,##0", "en_US").format(category.currentAmount)}",
            style: GoogleFonts.quicksand(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.grey[500],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildAddCategoryCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/new_category',
          arguments: {
            'type': 'expense',
            'title': 'Nueva Categoría',
            'action': 'Guardar Categoría',
          },
        );
      },
      child: Container(
        width: 110,
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.grey[200]!,
            width: 2,
            style: BorderStyle.solid, // Dashed para diferenciar
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                shape: BoxShape.circle,
              ),
              child: const Icon(TablerIcons.plus, color: Colors.grey, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              "Nueva Categoría",
              style: GoogleFonts.quicksand(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.grey[400],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCategoriesState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/new_category',
            arguments: {
              'type': 'expense',
              'title': 'Nueva Categoría',
              'action': 'Guardar Categoría',
            },
          );
        },
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.grey[200]!,
              width: 2,
              style: BorderStyle.solid,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(TablerIcons.category, color: Colors.grey[400], size: 32),
              const SizedBox(height: 8),
              Text(
                "No hay categorías",
                style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
