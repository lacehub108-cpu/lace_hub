import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/inquiry_model.dart';
import '../../models/order_model.dart';
import '../../services/firebase_service.dart';
import 'customer_auth_screen.dart'; // <-- લોગિન સ્ક્રીન ઈમ્પોર્ટ કરી

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // જો લોગિન ના હોય તો આ સ્ક્રીન દેખાશે
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Orders')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, size: 80, color: Colors.grey),
              const SizedBox(height: 16),
              const Text('તમારા ઓર્ડર જોવા માટે લોગિન કરો', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CustomerAuthScreen())),
                child: const Text('Login Now'),
              ),
            ],
          ),
        ),
      );
    }

    // જો લોગિન હોય તો આ સ્ક્રીન દેખાશે
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                leading: const Icon(Icons.message, size: 40, color: Colors.blue),
                title: const Text('1. WhatsApp Inquiry', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: const Text('ગ્રાહક દ્વારા કરેલી ઈન્ક્વાયરી જુઓ'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CustomerInquiryListScreen(userId: user.uid))),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                leading: const Icon(Icons.shopping_bag, size: 40, color: Colors.orange),
                title: const Text('2. WhatsApp Order', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: const Text('ગ્રાહક દ્વારા કરેલો ઓર્ડર જુઓ'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CustomerOrderListScreen(userId: user.uid))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= ઈન્ક્વાયરી લિસ્ટ (Filtered) =================
class CustomerInquiryListScreen extends StatelessWidget {
  final String userId;
  const CustomerInquiryListScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Inquiries'), centerTitle: true),
      body: StreamBuilder<List<InquiryModel>>(
        stream: FirebaseService.getCustomerInquiriesStream(userId), // <-- ફિલ્ટર કરેલી સ્ટ્રીમ
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text('કોઈ ઈન્ક્વાયરી કરેલી નથી'));

          final inquiries = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: inquiries.length,
            itemBuilder: (context, index) {
              final inq = inquiries[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.memory(base64Decode(inq.imagePath), width: 70, height: 70, fit: BoxFit.cover),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(inq.laceName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 4),
                            Text('Status: ${inq.status.toUpperCase()}', 
                              style: TextStyle(fontWeight: FontWeight.bold, color: inq.status == 'confirmed' ? Colors.green : inq.status == 'cancelled' ? Colors.red : Colors.orange)
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (inq.status == 'pending')
                                  TextButton(
                                    onPressed: () => FirebaseService.updateInquiryStatus(inq.id, 'cancelled'),
                                    child: const Text('Cancel', style: TextStyle(color: Colors.orange)),
                                  ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: const Text('Delete?'),
                                        content: const Text('શું તમે આ ઈન્ક્વાયરી ડિલીટ કરવા માંગો છો?'),
                                        actions: [
                                          TextButton(onPressed: () => Navigator.pop(context), child: const Text('No')),
                                          TextButton(onPressed: () {
                                            FirebaseService.deleteInquiry(inq.id);
                                            Navigator.pop(context);
                                          }, child: const Text('Yes', style: TextStyle(color: Colors.red))),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
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

// ================= ઓર્ડર લિસ્ટ (Filtered) =================
class CustomerOrderListScreen extends StatelessWidget {
  final String userId;
  const CustomerOrderListScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders'), centerTitle: true),
      body: StreamBuilder<List<OrderModel>>(
        stream: FirebaseService.getCustomerOrdersStream(userId), // <-- ફિલ્ટર કરેલી સ્ટ્રીમ
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text('કોઈ ઓર્ડર કરેલો નથી'));

          final orders = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final ord = orders[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.memory(base64Decode(ord.imagePath), width: 70, height: 70, fit: BoxFit.cover),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(ord.laceName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text('Qty: ${ord.quantity} pcs', style: const TextStyle(color: Colors.grey)),
                            const SizedBox(height: 4),
                            Text('Status: ${ord.status.toUpperCase()}', 
                              style: TextStyle(fontWeight: FontWeight.bold, color: ord.status == 'confirmed' ? Colors.green : ord.status == 'cancelled' ? Colors.red : Colors.orange)
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (ord.status == 'pending')
                                  TextButton(
                                    onPressed: () => FirebaseService.updateOrderStatus(ord.id, 'cancelled'),
                                    child: const Text('Cancel', style: TextStyle(color: Colors.orange)),
                                  ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: const Text('Delete?'),
                                        content: const Text('શું તમે આ ઓર્ડર ડિલીટ કરવા માંગો છો?'),
                                        actions: [
                                          TextButton(onPressed: () => Navigator.pop(context), child: const Text('No')),
                                          TextButton(onPressed: () {
                                            FirebaseService.deleteOrder(ord.id);
                                            Navigator.pop(context);
                                          }, child: const Text('Yes', style: TextStyle(color: Colors.red))),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
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