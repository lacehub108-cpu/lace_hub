import 'dart:convert';
import 'package:flutter/material.dart';
import '../../models/lace_model.dart';
import 'inquiry_form.dart';

class PhotoDetailScreen extends StatelessWidget {
  final LaceModel lace;
  final bool isAdmin; // <-- નવું વેરીએબલ
  
  const PhotoDetailScreen({super.key, required this.lace, this.isAdmin = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lace.name),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ઉપર ફોટો
              Center(
                child: GestureDetector(
                  onTap: () => showDialog(
                    context: context,
                    builder: (_) => Dialog(
                      child: InteractiveViewer(
                        child: Image.memory(base64Decode(lace.imagePath)),
                      ),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.memory(
                      base64Decode(lace.imagePath),
                      height: 350, 
                      fit: BoxFit.contain, 
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 30),

              // નીચે લેસની વિગતો
              Text(
                lace.name,
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Divider(thickness: 1.5),
              const SizedBox(height: 16),
              
              _buildInfoRow('Material', lace.material),
              _buildInfoRow('Price', '₹${lace.price.toStringAsFixed(2)}'),
              _buildInfoRow('Price per Roll', '₹${lace.pricePerRoll.toStringAsFixed(2)}'),
              _buildInfoRow('Design No', lace.designNumber, isHighlight: true),
              
              const SizedBox(height: 40),
              
              // જો એડમિન હોય તો આ બટન્સ દેખાશે નહીં (if (!isAdmin) નો ઉપયોગ)
              if (!isAdmin) ...[
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.info_outline, color: Colors.white),
                    label: const Text('WhatsApp Inquiry', style: TextStyle(color: Colors.white, fontSize: 16)),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => InquiryFormScreen(lace: lace, isOrder: false)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.shopping_cart, color: Colors.white),
                    label: const Text('WhatsApp Order', style: TextStyle(color: Colors.white, fontSize: 16)),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => InquiryFormScreen(lace: lace, isOrder: true)),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
                color: isHighlight ? Colors.amber : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}