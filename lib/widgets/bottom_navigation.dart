import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';

class BottomNavigation extends ConsumerStatefulWidget {
  const BottomNavigation({super.key});

  @override
  ConsumerState<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends ConsumerState<BottomNavigation> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;

    // Only show bottom nav if user is logged in
    if (user == null) return const SizedBox.shrink();

    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() => _currentIndex = index);
        switch (index) {
          case 0:
            context.go('/home');
            break;
          case 1:
            context.go('/orders');
            break;
          case 2:
            context.go('/profile');
            break;
        }
      },
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.delivery_dining),
          activeIcon: Icon(Icons.delivery_dining),
          label: 'Orders',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.delivery_dining_outlined),
        //   activeIcon: Icon(Icons.delivery_dining),
        //   label: 'Deliveries',
        // ),
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.history_outlined),
        //   activeIcon: Icon(Icons.history),
        //   label: 'History',
        // ),
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.analytics_outlined),
        //   activeIcon: Icon(Icons.analytics),
        //   label: 'Stats',
        // ),
      ],
    );
  }
}