import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/order_model.dart';

final ordersProvider = StateNotifierProvider<OrdersNotifier, List<Order>>((ref) {
  return OrdersNotifier();
});

class OrdersNotifier extends StateNotifier<List<Order>> {
  OrdersNotifier() : super([]);

  Future<void> updatePayment(int orderId, Map<String, dynamic> paymentData) async {
    final index = state.indexWhere((order) => order.id == orderId);

    if (index != -1) {
      // Update the order with the new payment details
      final updatedOrder = state[index].copyWith(
        paymentMethod: paymentData['paymentMethod'],
        paymentStatus: paymentData['paymentStatus'],
      );
      state = [
        ...state..removeAt(index),
        updatedOrder,
      ];
    }
  }

  void loadSampleOrders() {
    state = [
      Order(
        id: 1,
        orderNumber: 'ORD-12345',
        status: 'assigned',
        customerName: 'Ahmed Residence',
        customerAddress: '123 Main St, Riyadh, Saudi Arabia',
        customerPhone: '123-456-7890',
        totalAmount: 7500,
        itemCount: 3,
        orderType: 'pickup',
        paymentMethod: 'cash',
        paymentStatus: 'pending',
        scheduledDate: DateTime.now().add(const Duration(days: 1)),
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        completedAt: null,
        items: [
          {'name': 'Queen Bedsheet', 'quantity': 2},
          {'name': 'Pillow Covers', 'quantity': 1},
        ],
      ),
      Order(
        id: 2,
        orderNumber: 'ORD-12346',
        status: 'in_progress',
        customerName: 'Mohammed Apartment',
        customerAddress: '456 Second Ave, Jeddah',
        customerPhone: '987-654-3210',
        totalAmount: 12000,
        itemCount: 2,
        orderType: 'delivery',
        paymentMethod: 'card',
        paymentStatus: 'pending',
        scheduledDate: null,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        completedAt: null,
        items: [
          {'name': 'Queen Bedsheet Set', 'quantity': 1},
          {'name': 'Duvet Cover', 'quantity': 1},
        ],
      ),
    ];
  }

  void startDelivery(int orderId) {
    state = [
      for (final order in state)
        if (order.id == orderId)
          Order(
            id: order.id,
            orderNumber: order.orderNumber,
            status: 'in_progress',
            customerName: order.customerName,
            customerAddress: order.customerAddress,
            customerPhone: order.customerPhone,
            totalAmount: order.totalAmount,
            itemCount: order.itemCount,
            orderType: order.orderType,
            paymentMethod: order.paymentMethod,
            paymentStatus: order.paymentStatus,
            scheduledDate: order.scheduledDate,
            createdAt: order.createdAt,
            completedAt: order.completedAt,
            items: order.items,
          )
        else
          order
    ];
  }
}
