import 'package:family_budget/features/accounts/presentation/screens/new_account_screen.dart';
import 'package:family_budget/features/categories/data/datasources/category_local_datasource_impl.dart';
import 'package:family_budget/features/categories/data/repository/category_repository_imp.dart';
import 'package:family_budget/features/categories/domain/usercases/get_category.dart';
import 'package:family_budget/features/categories/domain/usercases/save_category.dart';
import 'package:family_budget/features/categories/domain/usercases/delete_category.dart';
import 'package:family_budget/features/categories/domain/entities/category_entity.dart';
import 'package:family_budget/features/categories/domain/usercases/update_category.dart';
import 'package:family_budget/features/categories/presentation/bloc/category_bloc.dart';
import 'package:family_budget/features/categories/presentation/bloc/category_event.dart';
import 'package:family_budget/features/categories/presentation/bloc/category_state.dart';
import 'package:family_budget/features/transactions/data/repository/transaction_repository_impl.dart';
import 'package:family_budget/features/transactions/domiain/entities/transaction_entity.dart';
import 'package:family_budget/features/transactions/domiain/usecases/get_transactions.dart';
import 'package:family_budget/features/transactions/domiain/usecases/save_transaction.dart'
    as trans;
import 'package:family_budget/features/transactions/domiain/usecases/update_transaction.dart';
import 'package:family_budget/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:family_budget/features/categories/presentation/screens/new_category_screen.dart';
import 'package:family_budget/features/transactions/presentation/bloc/transaction_event.dart';
import 'package:family_budget/features/categories/presentation/screens/budget_page.dart';
import 'package:family_budget/features/dreams/dream_screen.dart';
import 'package:family_budget/features/main_navigation/presentation/pages/dashboard_page.dart';
import 'package:family_budget/features/main_navigation/presentation/pages/main_navigation_screen.dart';
import 'package:family_budget/features/transactions/presentation/screens/edit_transaction_screen.dart';
import 'package:family_budget/features/transactions/presentation/screens/new_entry_screen.dart';
import 'package:family_budget/features/profile/presentation/pages/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:path_provider/path_provider.dart'; // Necesario para Isar
import 'package:isar/isar.dart';
import 'package:family_budget/features/categories/data/models/category_isar_model.dart';
import 'package:family_budget/features/transactions/data/models/transaction_isar_model.dart';
import 'package:family_budget/features/accounts/data/models/account_isar_model.dart';
import 'package:family_budget/features/transactions/data/datasources/transaction_local_datasource_impl.dart';

// ... (tus otros imports) ...

void main() async {
  // 1. Asegurar que los bindings de Flutter estén listos
  WidgetsFlutterBinding.ensureInitialized();

  // 2. INICIALIZAR ISAR (La base de datos real)
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [
      CategoryIsarModelSchema,
      TransactionIsarModelSchema,
      AccountIsarModelSchema,
    ], // Aquí pones los schemas que generaste
    directory: dir.path,
  );

  // 3. INYECTAR DATA SOURCE (Pasamos la instancia de Isar)
  // Aquí usamos la implementación (Impl), no la interfaz.
  final categoryLocalDataSource = CategoryLocalDataSourceImpl(isar: isar);

  // 4. INYECTAR REPOSITORIO (Pasamos la instancia del DataSource)
  final categoryRepository = CategoryRepositoryImpl(
    categoryLocalDataSource: categoryLocalDataSource,
  );

  // 5. INYECTAR CASOS DE USO (Pasamos el Repositorio)
  final saveCategoryUseCase = SaveCategory(categoryRepository);
  final getCategoriesUseCase = GetCategories(categoryRepository);
  final deleteCategoryUseCase = DeleteCategory(categoryRepository);
  final updateCategoryUseCase = UpdateCategory(categoryRepository);

  // (Inyección real de transacciones)
  final transactionLocalDataSource = TransactionLocalDataSourceImpl(isar: isar);
  final transactionRepository = TransactionRepositoryImpl(
    localDataSource: transactionLocalDataSource,
  );
  final saveTransactionUseCase = trans.SaveTransaction(transactionRepository);
  final getTransactionsUseCase = GetTransactionsUsecase(transactionRepository);
  final updateTransactionUseCase = UpdateTransaction(transactionRepository);

  // 6. CORRER LA APP
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => CategoryBloc(
            CategoryState(),
            saveCategoryUseCase,
            getCategoriesUseCase,
            deleteCategoryUseCase,
            updateCategoryUseCase,
          )..add(LoadCategories()),
        ),
        BlocProvider(
          create: (_) => TransactionBloc(
            saveTransactionUseCase,
            getTransactionsUseCase,
            updateTransactionUseCase,
          )..add(GetTransactionsEvent()),
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
          final args = ModalRoute.of(context)?.settings.arguments;
          String type = 'expense';
          CategoryEntity? categoryToEdit;
          if (args is String) {
            type = args;
          } else if (args is Map<String, dynamic>) {
            type = args['type'] as String? ?? 'expense';
            categoryToEdit = args['category'] as CategoryEntity?;
          }
          return NewCategoryScreen(type: type, categoryToEdit: categoryToEdit);
        },
        '/edit_transaction': (context) {
          final transaction =
              ModalRoute.of(context)!.settings.arguments as TransactionEntity;

          return EditTransactionScreen(transaction: transaction);
        },
        '/history': (context) => const DashBoardPage(),
        '/dreams': (context) => const DreamsScreen(),
        '/profile': (context) => const ProfileScreen(),
        // Corregido: de '/budget_screenm' a '/budget_screen'
        '/budget_screen': (context) => const BudgetPage(),
        '/new_account': (context) => const NewAccountScreen(),
      },
    );
  }
}
