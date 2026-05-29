import 'package:family_budget/features/dreams/dream_screen.dart';

import 'package:family_budget/features/transactions/presentation/screens/home_screen.dart';
import 'package:family_budget/features/main_navigation/presentation/pages/dashboard_page.dart';
import 'package:family_budget/features/profile/presentation/pages/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  // Lista de pantallas principales
  final List<Widget> _screens = [
    const HomeScreen(),
    const DashBoardPage(),
    const DreamsScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/tfScreen');
        },
        backgroundColor: const Color(0xFF9333EA),
        elevation: 8,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // Bottom Bar Personalizado
      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 70,
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildNavItem(TablerIcons.home, "Inicio", 0),
            _buildNavItem(TablerIcons.list, "Movimientos", 1),
            const SizedBox(width: 40),
            _buildNavItem(TablerIcons.clock, "Metas", 2),
            _buildNavItem(TablerIcons.user, "Perfil", 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 28,

            color: isSelected ? const Color(0xFF9333EA) : Colors.grey[300],
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isSelected ? const Color(0xFF9333EA) : Colors.grey[300],
            ),
          ),
        ],
      ),
    );
  }
}
