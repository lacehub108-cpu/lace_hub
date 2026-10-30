import 'dart:convert';
import 'package:flutter/material.dart';
import '../../models/order_model.dart';
import '../../services/firebase_service.dart';

class AdminOrdersScreen extends StatelessWidget {
  const AdminOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WhatsApp Orders'), centerTitle: true),
      body: StreamBuilder<List<OrderModel>>(
        stream: FirebaseService.getOrdersStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('કોઈ ઓર્ડર નથી'));
          }

          final orders = snapshot.data!;

          // બેજ દૂર કરવા માટે બધા ઓર્ડર રીડ કરો
          for (var ord in orders) {
            if (!ord.isRead) {
              FirebaseService.markOrderRead(ord.id);
            }
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final ord = orders[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.memory(
                              base64Decode(ord.imagePath),
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Lace: ${ord.laceName}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                Text('Design No: ${ord.designNumber}', style: const TextStyle(color: Colors.amber)),
                                Text('Qty: ${ord.quantity} pcs', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 20),
                      Text('Customer: ${ord.customerName}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('Phone: ${ord.phone}'),
                      Text('Address: ${ord.address}'),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: ord.status == 'confirmed' ? Colors.green : ord.status == 'cancelled' ? Colors.red : Colors.orange,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              ord.status.toUpperCase(),
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                          Row(
                            children: [
                              if (ord.status == 'pending') ...[
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(horizontal: 8)),
                                  onPressed: () => FirebaseService.updateOrderStatus(ord.id, 'confirmed'),
                                  child: const Text('Confirm', style: TextStyle(color: Colors.white, fontSize: 12)),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, padding: const EdgeInsets.symmetric(horizontal: 8)),
                                  onPressed: () => FirebaseService.updateOrderStatus(ord.id, 'cancelled'),
                                  child: const Text('Cancel', style: TextStyle(color: Colors.white, fontSize: 12)),
                                ),
                              ],
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => FirebaseService.deleteOrder(ord.id),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}