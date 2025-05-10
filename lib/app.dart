import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'screens/login_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/map_screen.dart';
import 'screens/payment_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/not_found.dart';
import 'providers/auth_provider.dart';
import 'widgets/bottom_navigation.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Nasi Cleaning Delivery',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
        ),
      ),
      routerConfig: _router,
    );
  }
}

final _router = GoRouter(
  redirect: (BuildContext context, GoRouterState state) {
    final authState = ProviderScope.containerOf(context).read(authProvider);
    final isLoggedIn = authState.user != null;
    final isLoginRoute = state.matchedLocation == '/login';

    if (!isLoggedIn && !isLoginRoute) {
      return '/login';
    }

    if (isLoggedIn && isLoginRoute) {
      return '/orders';
    }

    return null;
  },
  routes: <RouteBase>[
    GoRoute(
      path: '/login',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return MaterialPage<void>(
          key: state.pageKey,
          child: const LoginPage(),
        );
      },
    ),
    ShellRoute(
      pageBuilder: (BuildContext context, GoRouterState state, Widget child) {
        return MaterialPage<void>(
          key: state.pageKey,
          child: Scaffold(
            body: child,
            bottomNavigationBar: const BottomNavigation(),
          ),
        );
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/orders',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return MaterialPage<void>(
              key: state.pageKey,
              child: const OrdersScreen(),
            );
          },
        ),
        GoRoute(
          path: '/map/:orderId',
          pageBuilder: (BuildContext context, GoRouterState state) {
            final orderId = int.parse(state.pathParameters['orderId']!);
            return MaterialPage<void>(
              key: state.pageKey,
              child: MapScreen(
                orderId: orderId,
                customerName: 'John Doe',
                customerAddress: '123 Main St',
                latitude: 24.7136,
                longitude: 46.6753,
                phoneNumber: '+966501234567',
                totalAmount: 10000,
                paymentMethod: 'cash',
                itemCount: 3,
                items: [
                  {'name': 'Cleaning Service', 'quantity': 1},
                  {'name': 'Detergent', 'quantity': 2},
                ],
              ),
            );
          },
        ),
        GoRoute(
          path: '/payment/:orderId',
          pageBuilder: (BuildContext context, GoRouterState state) {
            final orderId = int.parse(state.pathParameters['orderId']!);
            return MaterialPage<void>(
              key: state.pageKey,
              child: PaymentPage(orderId: orderId),
            );
          },
        ),
        GoRoute(
          path: '/profile',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return MaterialPage<void>(
              key: state.pageKey,
              child: const ProfileScreen(),
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: '/',
      redirect: (BuildContext context, GoRouterState state) => '/orders',
    ),
  ],
  errorPageBuilder: (BuildContext context, GoRouterState state) {
    return MaterialPage<void>(
      key: state.pageKey,
      child: const NotFoundPage(),
    );
  },
);