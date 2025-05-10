import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/order_model.dart';
import '../providers/orders_provider.dart';
import 'custom_button.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OrderCard extends ConsumerWidget {
  final Order order;
  final VoidCallback onTap;
  final bool isUpcoming;

  const OrderCard({
    super.key,
    required this.order,
    required this.onTap,
    this.isUpcoming = false,
  });

  Color getStatusColor(String status) {
    switch (status) {
      case 'assigned':
        return Colors.green.shade100;
      case 'in_progress':
        return Colors.blue.shade100;
      case 'completed':
        return Colors.grey.shade300;
      default:
        return Colors.grey.shade200;
    }
  }

  String getStatusText(String status) {
    switch (status) {
      case 'assigned':
        return 'Assigned';
      case 'in_progress':
        return 'In Progress';
      case 'completed':
        return 'Completed';
      default:
        return 'Scheduled';
    }
  }

  Color getOrderTypeColor(String type) {
    switch (type) {
      case 'pickup':
        return Colors.orange;
      case 'delivery':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersNotifier = ref.read(ordersProvider.notifier);

    if (isUpcoming) {
      return Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 2,
        color: Colors.grey.shade50,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Order #${order.orderNumber}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('${order.itemCount} items • ${order.orderType}',
                          style: TextStyle(color: getOrderTypeColor(order.orderType)))
                    ],
                  ),
                  const Chip(label: Text('Scheduled')),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 20, color: Colors.grey),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(DateFormat('EEEE, h:mm a').format(order.scheduledDate ?? DateTime.now())),
                      Text(order.customerAddress, style: const TextStyle(fontSize: 12)),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      );
    }

    return InkWell(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Order #${order.orderNumber}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('${order.itemCount} items • ${order.orderType}',
                          style: TextStyle(color: getOrderTypeColor(order.orderType)))
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: getStatusColor(order.status),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(getStatusText(order.status), style: const TextStyle(fontSize: 12)),
                  )
                ],
              ),
              const Divider(height: 24),
              Row(
                children: [
                  const Icon(Icons.location_pin, color: Colors.grey),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(order.customerName, style: const TextStyle(fontWeight: FontWeight.w500)),
                      Text(order.customerAddress, style: const TextStyle(fontSize: 12)),
                    ],
                  )
                ],
              ),
              const Divider(height: 24),
              Row(
                children: [
                  const Icon(Icons.payment, color: Colors.grey),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Payment: ${order.paymentMethod}'),
                      Text('Amount: ${(order.totalAmount / 100).toStringAsFixed(2)} SAR',
                          style: const TextStyle(fontSize: 12)),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 12),
              if (order.status == 'assigned')
                CustomButton(
                  text: 'Start Delivery',
                  onPressed: () async {
                    ordersNotifier.startDelivery(order.id);
                    Fluttertoast.showToast(msg: 'Started delivery of order ${order.orderNumber}');
                  },
                ),
              if (order.status == 'in_progress')
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => onTap(),
                      child: const Text('View Route'),
                    ),
                    const SizedBox(width: 8),
                    CustomButton(
                      text: 'Complete',
                      onPressed: () {
                        Navigator.pushNamed(context, '/payment/${order.id}');
                      },
                    )
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
