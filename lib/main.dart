import 'package:family_budget/features/categories/data/repository/category_repository_imp.dart';
import 'package:family_budget/features/categories/domain/usercases/get_category.dart';
import 'package:family_budget/features/categories/domain/usercases/save_category.dart';
import 'package:family_budget/features/categories/domain/usercases/delete_category.dart';
import 'package:family_budget/features/categories/presentation/bloc/category_bloc.dart';
import 'package:family_budget/features/categories/presentation/bloc/category_state.dart';
import 'package:family_budget/features/trasnsactions/data/repository/transaction_repository_impl.dart';
import 'package:family_budget/features/trasnsactions/domiain/usecases/save_transaction.dart' as trans;
import 'package:family_budget/features/trasnsactions/presentation/bloc/transaction_bloc.dart';
import 'package:family_budget/features/categories/presentation/screens/new_category_screen.dart';
import 'package:family_budget/presentation/screens/budget_screen.dart';
import 'package:family_budget/presentation/screens/dream_screen.dart';
import 'package:family_budget/presentation/screens/list_screen.dart';
import 'package:family_budget/presentation/screens/main_navigation_screen.dart';
import 'package:family_budget/features/trasnsactions/presentation/screens/new_entry_screen.dart';
import 'package:family_budget/presentation/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final categoryRepository = CategoryRepositoryFake();
  final saveCategoryUseCase = SaveCategory(categoryRepository);
  final getCategoriesUseCase = GetCategories(categoryRepository);
  final deleteCategoryUseCase = DeleteCategory(categoryRepository);

  final transactionRepository = TransactionRepositoryFake();
  final saveTransactionUseCase = trans.SaveTransaction(transactionRepository);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => CategoryBloc(
            CategoryState(),
            saveCategoryUseCase,
            getCategoriesUseCase,
            deleteCategoryUseCase,
          ),
        ),
        BlocProvider(
          create: (_) => TransactionBloc(saveTransactionUseCase),
        ),
      ],
      child: const MyApp(),
    ),
  );
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
        '/new_entry': (context) => NewEntryScreen(),
        '/new_category': (context) {
          final type =
              ModalRoute.of(context)?.settings.arguments as String? ??
              'expense';
          return NewCategoryScreen(type: type);
        },
        '/history': (context) => const HistoryScreen(),
        '/dreams': (context) => const DreamsScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/budget_screenm': (context) => const BudgetPage(),
      },
    );
  }
}
