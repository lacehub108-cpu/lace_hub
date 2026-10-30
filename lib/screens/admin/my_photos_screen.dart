import 'dart:convert';
import 'package:flutter/material.dart';
import '../../models/lace_model.dart';
import '../../services/firebase_service.dart';
import '../customer/photo_detail.dart';
import 'add_photo.dart';

class MyPhotosScreen extends StatelessWidget {
  const MyPhotosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Photos'),
        centerTitle: true,
      ),
      body: StreamBuilder<List<LaceModel>>(
        stream: FirebaseService.getLacesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Photos Available'));
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
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // ડાબી બાજુ ફોટો
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
                            width: 80, 
                            height: 80, 
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16), 
                      
                      // વચ્ચે માહિતી
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lace.name,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Design: ${lace.designNumber} | ₹${lace.price.toStringAsFixed(0)}',
                              style: const TextStyle(fontSize: 13, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      
                      // જમણી બાજુ Edit અને Delete ના આઈકન
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.push(
                                context, 
                                MaterialPageRoute(builder: (_) => AddPhotoScreen(laceToEdit: lace))
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('Delete Photo?'),
                                  content: const Text('શું તમે ખરેખર આ ફોટો ડિલીટ કરવા માંગો છો?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel'),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                      onPressed: () {
                                        FirebaseService.deleteLace(lace.id);
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Delete', style: TextStyle(color: Colors.white)),
                                    ),
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
              );
            },
          );
        },
      ),
    );
  }
}