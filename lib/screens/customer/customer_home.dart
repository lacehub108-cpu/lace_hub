import 'dart:convert'; 
import 'package:flutter/material.dart';
import '../../models/lace_model.dart';
import '../../services/firebase_service.dart';
import '../../widgets/top_bar.dart';
import 'photo_detail.dart';

class CustomerHome extends StatelessWidget {
  const CustomerHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const TopBar(isAdmin: false),
            Expanded(
              child: StreamBuilder<List<LaceModel>>(
                stream: FirebaseService.getLacesStream(), 
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No laces available'));
                  }
                  
                  final laces = snapshot.data!;
                  
                  return ListView.builder(
                    padding: const EdgeInsets.all(16), // બહારથી પેડિંગ
                    itemCount: laces.length,
                    itemBuilder: (context, index) {
                      final lace = laces[index];
                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.only(bottom: 16),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () => Navigator.push(
                            context, 
                            MaterialPageRoute(builder: (_) => PhotoDetailScreen(lace: lace))
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // ડાબી બાજુ નાનો ફોટો
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.memory(
                                    base64Decode(lace.imagePath),
                                    width: 110, 
                                    height: 110, 
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 24), // <-- ફોટા અને લખાણ વચ્ચેની જગ્યા વધારી
                                
                                // જમણી બાજુ માહિતી
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        lace.name,
                                        style: const TextStyle(
                                          fontSize: 18, 
                                          fontWeight: FontWeight.bold
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Material: ${lace.material}',
                                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        'Price: ₹${lace.price.toStringAsFixed(2)}',
                                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.green),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Price/Roll: ₹${lace.pricePerRoll.toStringAsFixed(2)}',
                                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
    );
  }
}