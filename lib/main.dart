import 'package:family_budget/presentation/screens/dream_screen.dart';
import 'package:family_budget/presentation/screens/list_screen.dart';
import 'package:family_budget/presentation/screens/main_navigation_screen.dart';

import 'package:family_budget/presentation/screens/new_category_screen.dart';
import 'package:family_budget/presentation/screens/new_entry_screen.dart';
import 'package:family_budget/presentation/screens/profile_screen.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/dreams/data/datasources/dream_local_data_source.dart';
import 'features/dreams/data/repositories/dream_repository_impl.dart';
import 'features/dreams/domain/usecases/add_dream.dart';
import 'features/dreams/domain/usecases/get_dreams.dart';
import 'features/dreams/domain/usecases/update_dream_progress.dart';
import 'features/dreams/presentation/bloc/dreams_bloc.dart';
import 'features/dreams/presentation/bloc/dreams_event.dart';
import 'features/transactions/data/datasources/transaction_local_data_source.dart';
import 'features/transactions/data/repositories/transaction_repository_impl.dart';
import 'features/transactions/domain/usecases/add_transaction.dart';
import 'features/transactions/domain/usecases/get_shared_balance.dart';
import 'features/transactions/domain/usecases/get_transactions.dart';
import 'features/transactions/presentation/bloc/transactions_bloc.dart';
import 'features/transactions/presentation/bloc/transactions_event.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Inicialización manual de dependencias (para este ejemplo sin get_it)
    final transactionDataSource = TransactionLocalDataSourceImpl();
    final transactionRepository = TransactionRepositoryImpl(
      localDataSource: transactionDataSource,
    );

    final dreamDataSource = DreamLocalDataSourceImpl();
    final dreamRepository = DreamRepositoryImpl(
      localDataSource: dreamDataSource,
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => TransactionsBloc(
            getTransactions: GetTransactions(transactionRepository),
            addTransaction: AddTransaction(transactionRepository),
            getSharedBalance: GetSharedBalance(transactionRepository),
          )..add(LoadTransactions()),
        ),
        BlocProvider(
          create: (_) => DreamsBloc(
            getDreams: GetDreams(dreamRepository),
            addDream: AddDream(dreamRepository),
            updateDreamProgress: UpdateDreamProgress(dreamRepository),
          )..add(LoadDreams()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: '/',
        routes: {
          '/': (context) => const MainNavigation(),
          '/new_entry': (context) => const NewEntryScreen(),
          '/new_category': (context) => const NewCategoryScreen(),
          '/history': (context) => const HistoryScreen(),
          '/dreams': (context) => const DreamsScreen(),
          '/profile': (context) => const ProfileScreen(),
        },
      ),
    );
  }
}
