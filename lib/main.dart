import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_budget/features/accounts/data/datasources/account_local_datasource_impl.dart';

import 'package:family_budget/features/accounts/data/datasources/account_remote_datasource_impl.dart';
import 'package:family_budget/features/accounts/data/repositories/account_repository_impl.dart';
import 'package:family_budget/features/accounts/domain/entities/account_entity.dart';
import 'package:family_budget/features/accounts/domain/usecases/delete_account.dart';
import 'package:family_budget/features/accounts/domain/usecases/get_accounts.dart';
import 'package:family_budget/features/accounts/domain/usecases/save_account.dart';
import 'package:family_budget/features/accounts/domain/usecases/update_account.dart';
import 'package:family_budget/features/accounts/presentation/bloc/account_bloc.dart';
import 'package:family_budget/features/accounts/presentation/bloc/account_event.dart';
import 'package:family_budget/features/accounts/presentation/screens/edit_account_screen.dart';
import 'package:family_budget/features/accounts/presentation/screens/new_account_screen.dart';
import 'package:family_budget/features/categories/data/datasources/category_local_datasource_impl.dart';
import 'package:family_budget/features/categories/data/datasources/category_remote_datasource_impl.dart';
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
import 'package:family_budget/features/transactions/data/datasources/transaction_remote_datasource_impl.dart';
import 'package:family_budget/features/transactions/domiain/entities/transaction_entity.dart';
import 'package:family_budget/features/transactions/domiain/usecases/get_transactions.dart';
import 'package:family_budget/features/transactions/domiain/usecases/save_transaction.dart'
    as trans;
import 'package:family_budget/features/transactions/domiain/usecases/update_transaction.dart';
import 'package:family_budget/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:family_budget/features/categories/presentation/screens/create_and_edit_category_screen.dart';
import 'package:family_budget/features/transactions/presentation/bloc/transaction_event.dart';
import 'package:family_budget/features/categories/presentation/screens/budget_page.dart';
import 'package:family_budget/features/dreams/dream_screen.dart';
import 'package:family_budget/features/main_navigation/presentation/pages/dashboard_page.dart';
import 'package:family_budget/features/main_navigation/presentation/pages/main_navigation_screen.dart';
import 'package:family_budget/features/transactions/presentation/screens/edit_transaction_screen.dart';
import 'package:family_budget/features/transactions/presentation/screens/new_entry_screen.dart';
import 'package:family_budget/features/profile/presentation/pages/profile_screen.dart';
import 'package:family_budget/features/transactions/presentation/screens/transaction_screen.dart';
import 'package:family_budget/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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

  // 2. Cargar variables de entorno desde el archivo .env
  await dotenv.load(fileName: '.env');

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final firestore = FirebaseFirestore.instance;

  // 2. INICIALIZAR ISAR (La base de datos real)
  final dir = await getApplicationDocumentsDirectory();
  final isar =
      Isar.getInstance() ??
      await Isar.open(
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

  // ⚠️ TODO: reemplazar este vaultId hardcodeado con el vault real del usuario
  // cuando implementes el login (e.g. traerlo de SharedPreferences o del AuthBloc).
  const currentVaultId = 'vault_12345';

  final categoryRemoteDataSource = CategoryRemoteDatasourceImpl(
    firestore: firestore,
    fallbackVaultId: currentVaultId,
    fallbackOwnerId: 'zamir_uid',
  );

  // 4. INYECTAR REPOSITORIO (Pasamos ambos DataSources + vaultId)
  final categoryRepository = CategoryRepositoryImpl(
    categoryLocalDataSource: categoryLocalDataSource,
    categoryRemoteDatasource: categoryRemoteDataSource,
    vaultId: currentVaultId,
  );

  // 5. INYECTAR CASOS DE USO (Pasamos el Repositorio)
  final saveCategoryUseCase = SaveCategory(categoryRepository);
  final getCategoriesUseCase = GetCategories(categoryRepository);
  final deleteCategoryUseCase = DeleteCategory(categoryRepository);
  final updateCategoryUseCase = UpdateCategory(categoryRepository);

  // (Inyección real de transacciones)
  final transactionLocalDataSource = TransactionLocalDataSourceImpl(isar: isar);
  final transactionRemoteDataSource = TransactionRemoteDataSourceImpl(
    firestore: firestore,
    fallbackVaultId: currentVaultId,
    fallbackOwnerId: 'zamir_uid',
  );

  final transactionRepository = TransactionRepositoryImpl(
    localDataSource: transactionLocalDataSource,
    remoteDataSource: transactionRemoteDataSource,
    vaultId: currentVaultId,
  );
  final saveTransactionUseCase = trans.SaveTransaction(transactionRepository);
  final getTransactionsUseCase = GetTransactionsUsecase(transactionRepository);
  final updateTransactionUseCase = UpdateTransaction(transactionRepository);

  // Inyección de dependencias - Accounts
  final accountLocalDataSource = AccountLocalDataSourceImpl(isar: isar);
  final accountRemoteDataSource = AccountRemoteDataSourceImpl(
    firestore: firestore,
  );
  final accountRepository = AccountRepositoryImpl(
    localDataSource: accountLocalDataSource,
    remoteDataSource: accountRemoteDataSource,
  );
  final getAccountsUseCase = GetAccountsUseCase(accountRepository);
  final saveAccountUseCase = SaveAccountUseCase(accountRepository);
  final updateAccountUseCase = UpdateAccountUseCase(accountRepository);
  final deleteAccountUseCase = DeleteAccountUseCase(accountRepository);

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
          )..add(LoadCategoriesEvent()),
        ),

        BlocProvider(
          create: (_) => AccountBloc(
            getAccountsUseCase: getAccountsUseCase,
            saveAccountUseCase: saveAccountUseCase,
            updateAccountUseCase: updateAccountUseCase,
            deleteAccountUseCase: deleteAccountUseCase,
          )..add(LoadAccountsEvent()),
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
          return CreateAndEditCategoryScreen(
            type: type,
            categoryToEdit: categoryToEdit,
          );
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
        '/tfScreen': (context) => TransactionScreen(),
        '/edit_account': (context) {
          final account =
              ModalRoute.of(context)!.settings.arguments as AccountEntity;
          return EditAccountScreen(account: account);
        },
      },
    );
  }
}
