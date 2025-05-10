import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/order_model.dart';
import '../providers/auth_provider.dart';
import '../providers/orders_provider.dart';
import '../widgets/order_card.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  int notificationCount = 0;

  @override
  void initState() {
    super.initState();

    // Fix: Delay the provider modification to avoid modifying during build
    Future.microtask(() {
      ref.read(ordersProvider.notifier).loadSampleOrders();
    });

    notificationCount = DateTime.now().second % 5; // simulate count
  }

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(ordersProvider);
    final user = ref.watch(authProvider).user;
    final isLoading = false; // Simulate loading state
    final activeOrders = orders.where((o) => o.status == 'assigned' || o.status == 'in_progress').toList();
    final upcomingOrders = orders.where((o) => o.scheduledDate != null && o.scheduledDate!.isAfter(DateTime.now())).toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // HEADER
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
            ),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).primaryColor.withOpacity(0.1),
                        ),
                        child: const Icon(Icons.home, color: Colors.green),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "Your Orders",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      const Icon(Icons.notifications_none, size: 28, color: Colors.black54),
                      if (notificationCount > 0)
                        Positioned(
                          right: 0,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                notificationCount.toString(),
                                style: const TextStyle(color: Colors.white, fontSize: 10),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ORDER LIST
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                children: [
                  // Today's Summary
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Today's Deliveries", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          Text(DateFormat('MMMM d, yyyy').format(DateTime.now()), style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text("${orders.length} Orders", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Active Orders
                  const Text("ACTIVE ORDERS", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black54)),
                  const SizedBox(height: 12),
                  if (activeOrders.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                      ),
                      child: const Center(child: Text("No active orders at the moment", style: TextStyle(color: Colors.black54))),
                    )
                  else
                    ...activeOrders.map(
                          (order) => OrderCard(
                        order: order,
                        onTap: () => Navigator.pushNamed(context, '/map/${order.id}'),
                      ),
                    ),

                  // Upcoming Orders
                  if (upcomingOrders.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    const Text("UPCOMING ORDERS", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black54)),
                    const SizedBox(height: 12),
                    ...upcomingOrders.map(
                          (order) => OrderCard(
                        order: order,
                        onTap: () {
                          openInGoogleMaps;
                        },
                        isUpcoming: true,
                      ),
                    ),
                  ]
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Future<void> openInGoogleMaps() async {
    final String googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=${24.904277},${67.113809}';
    final Uri uri = Uri.parse(googleMapsUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch Google Maps at $uri');
    }
  }
}

