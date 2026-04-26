import 'package:family_budget/presentation/screens/dream_screen.dart';
import 'package:family_budget/presentation/screens/list_screen.dart';
import 'package:family_budget/presentation/screens/main_screen.dart';
import 'package:family_budget/presentation/screens/new_entry_screen.dart';
import 'package:family_budget/presentation/screens/profile_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: '/',
      routes: {
        '/': (context) => const MainNavigation(),
        '/new_entry': (context) => const NewEntryScreen(),
        '/history': (context) => const HistoryScreen(),
        '/dreams': (context) => const DreamsScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
