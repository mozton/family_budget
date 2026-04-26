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
            MaterialPageRoute(builder: (context) => const NewEntryScreen()),
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
            _buildNavItem(Icons.home_rounded, "Inicio", 0),
            _buildNavItem(Icons.list_alt_rounded, "Lista", 1),
            const SizedBox(width: 40), // Espacio para el FAB
            _buildNavItem(Icons.favorite_rounded, "Sueños", 2),
            _buildNavItem(Icons.person_rounded, "Perfil", 3),
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
