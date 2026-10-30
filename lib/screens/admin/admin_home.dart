import 'dart:convert';
import 'package:flutter/material.dart';
import '../../models/lace_model.dart';
import '../../models/inquiry_model.dart';
import '../../models/order_model.dart';
import '../../services/firebase_service.dart';
import '../../widgets/top_bar.dart';
import '../customer/photo_detail.dart'; 
import 'add_photo.dart';
import 'admin_inquiries.dart';
import 'admin_orders.dart';
import 'my_photos_screen.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const TopBar(isAdmin: true),
            Expanded(
              child: StreamBuilder<List<LaceModel>>(
                stream: FirebaseService.getLacesStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No Laces Uploaded'));
                  }
                  
                  final laces = snapshot.data!;
                  
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: laces.length,
                    itemBuilder: (context, index) {
                      final lace = laces[index];
                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context, 
                                    MaterialPageRoute(builder: (_) => PhotoDetailScreen(lace: lace, isAdmin: true))
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.memory(
                                    base64Decode(lace.imagePath),
                                    width: 100, 
                                    height: 100, 
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20), 
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(lace.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                                    const SizedBox(height: 8),
                                    Text('Design No: ${lace.designNumber}', style: const TextStyle(fontSize: 14, color: Colors.amber)),
                                    const SizedBox(height: 4),
                                    Text('Price: ₹${lace.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
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
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 80, 
        color: Theme.of(context).cardColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildBottomIcon(
              context, 
              Icons.add_a_photo, 
              'Add Photo', 
              () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddPhotoScreen()))
            ),
            _buildBottomIcon(
              context, 
              Icons.photo_library, 
              'My Photos', 
              () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MyPhotosScreen()))
            ),
            
            // ઈન્ક્વાયરી આઈકન વિથ બેજ
            StreamBuilder<List<InquiryModel>>(
              stream: FirebaseService.getInquiriesStream(),
              builder: (context, snapshot) {
                int unread = 0;
                if (snapshot.hasData) {
                  unread = snapshot.data!.where((e) => !e.isRead).length;
                }
                return _buildBottomIcon(
                  context, 
                  Icons.message, 
                  'Inquiry', 
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminInquiriesScreen())),
                  badgeCount: unread,
                );
              }
            ),

            // ઓર્ડર આઈકન વિથ બેજ
            StreamBuilder<List<OrderModel>>(
              stream: FirebaseService.getOrdersStream(),
              builder: (context, snapshot) {
                int unread = 0;
                if (snapshot.hasData) {
                  unread = snapshot.data!.where((e) => !e.isRead).length;
                }
                return _buildBottomIcon(
                  context, 
                  Icons.shopping_bag, 
                  'Order', 
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminOrdersScreen())),
                  badgeCount: unread,
                );
              }
            ),
          ],
        ),
      ),
    );
  }

  // બેજ સાથેનું આઈકન બનાવવાનું ફંક્શન
  Widget _buildBottomIcon(BuildContext context, IconData icon, String label, VoidCallback onTap, {int badgeCount = 0}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // જો બેજ કાઉન્ટ 0 થી મોટું હોય તો જ Badge દેખાડો
          badgeCount > 0 
            ? Badge(
                label: Text('$badgeCount'),
                child: Icon(icon, color: Theme.of(context).primaryColor, size: 24),
              )
            : Icon(icon, color: Theme.of(context).primaryColor, size: 24),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}