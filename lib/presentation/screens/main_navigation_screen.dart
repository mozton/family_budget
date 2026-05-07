import 'package:family_budget/presentation/screens/dream_screen.dart';
import 'package:family_budget/presentation/screens/home_screen.dart';
import 'package:family_budget/presentation/screens/list_screen.dart';
import 'package:family_budget/presentation/screens/new_entry_screen.dart';
import 'package:family_budget/presentation/screens/profile_screen.dart';
import 'package:flutter/material.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  // Lista de pantallas principales
  final List<Widget> _screens = [
    const HomeScreen(), // La que ya hicimos
    const HistoryScreen(), // Nueva
    const DreamsScreen(), // Nueva
    const ProfileScreen(), // Nueva
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
      // Botón Flotante Central para "Nueva Entrada"
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewEntryScreen()),
          );
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
            _buildNavItem('assets/home.png', "Inicio", 0),
            _buildNavItem('assets/list.png', "Movimientos", 1),
            const SizedBox(width: 40),
            _buildNavItem('assets/clock.png', "Metas", 2),
            _buildNavItem('assets/user.png', "Perfil", 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(String assetName, String label, int index) {
    bool isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image(
            image: AssetImage(assetName),
            width: 28,
            height: 28,
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
