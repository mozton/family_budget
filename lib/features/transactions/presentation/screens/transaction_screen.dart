import 'package:family_budget/features/transactions/presentation/views/expense_view.dart';
import 'package:family_budget/features/transactions/presentation/views/income_view.dart';
import 'package:family_budget/features/transactions/presentation/views/transfer_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:google_fonts/google_fonts.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);

    // Escucha los cambios de pestaña
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _currentIndex = _tabController.index;
        });
      }
    });
  }

  // Color _getBackgroundColor() {
  //   switch (_currentIndex) {
  //     case 0:
  //       return const Color(0xFFF87171);
  //     case 1:
  //       return const Color(0xFF10B981);
  //     case 2:
  //       return const Color(0xFF3B82F6);
  //     default:
  //       return Colors.grey;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(TablerIcons.arrow_back, color: Colors.grey),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Nueva Entrada',
          style: GoogleFonts.quicksand(
            color: const Color(0xFF1F2937),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          AnimatedContainer(
            duration: Duration(microseconds: 0),
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: TabBar(
              controller: _tabController,
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,

              indicator: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 5,
                  ),
                ],
              ),

              labelColor: Colors.black,

              unselectedLabelColor: Colors.grey[500],

              labelStyle: GoogleFonts.quicksand(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),

              tabs: const [
                Tab(text: 'Gasto'),
                Tab(text: 'Ingreso'),
                Tab(text: 'Transferir'),
              ],
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [ExpenseView(), IncomeView(), TransferView()],
            ),
          ),
        ],
      ),
    );
  }
}
