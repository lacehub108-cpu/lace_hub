import 'dart:convert';
import 'package:flutter/material.dart';
import '../../models/inquiry_model.dart';
import '../../services/firebase_service.dart';

class AdminInquiriesScreen extends StatelessWidget {
  const AdminInquiriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WhatsApp Inquiries'), centerTitle: true),
      body: StreamBuilder<List<InquiryModel>>(
        stream: FirebaseService.getInquiriesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('કોઈ ઈન્ક્વાયરી નથી'));
          }

          final inquiries = snapshot.data!;

          // જેવી સ્ક્રીન ખૂલે એટલે બધી અનરીડ ઈન્ક્વાયરીને રીડ કરી દો (બેજ દૂર કરવા માટે)
          for (var inq in inquiries) {
            if (!inq.isRead) {
              FirebaseService.markInquiryRead(inq.id);
            }
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: inquiries.length,
            itemBuilder: (context, index) {
              final inq = inquiries[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // લેસનો ફોટો
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.memory(
                              base64Decode(inq.imagePath),
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          // લેસની વિગતો
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Lace: ${inq.laceName}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                Text('Design No: ${inq.designNumber}', style: const TextStyle(color: Colors.amber)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 20),
                      // ગ્રાહકની વિગતો
                      Text('Customer: ${inq.customerName}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('Phone: ${inq.phone}'),
                      Text('Address: ${inq.address}'),
                      const SizedBox(height: 10),
                      // સ્ટેટસ અને બટન્સ
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: inq.status == 'confirmed' ? Colors.green : inq.status == 'cancelled' ? Colors.red : Colors.orange,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              inq.status.toUpperCase(),
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                          Row(
                            children: [
                              if (inq.status == 'pending') ...[
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(horizontal: 8)),
                                  onPressed: () => FirebaseService.updateInquiryStatus(inq.id, 'confirmed'),
                                  child: const Text('Confirm', style: TextStyle(color: Colors.white, fontSize: 12)),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, padding: const EdgeInsets.symmetric(horizontal: 8)),
                                  onPressed: () => FirebaseService.updateInquiryStatus(inq.id, 'cancelled'),
                                  child: const Text('Cancel', style: TextStyle(color: Colors.white, fontSize: 12)),
                                ),
                              ],
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => FirebaseService.deleteInquiry(inq.id),
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