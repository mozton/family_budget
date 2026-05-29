import 'package:family_budget/core/router/route_names.dart';
import 'package:family_budget/features/main_navigation/presentation/pages/main_navigation_screen.dart';
import 'package:family_budget/features/transactions/presentation/screens/transaction_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final route = GoRouter(
    initialExtra: RouteNames.home,
    routes: [
      GoRoute(
        path: RouteNames.home,
        builder: (context, state) => MainNavigation(),
      ),
      GoRoute(
        path: RouteNames.transactionScreen,
        builder: (context, state) => TransactionScreen(),
      ),
    ],
  );
}
