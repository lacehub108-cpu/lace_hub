import 'package:flutter/material.dart';
import '../../services/storage_service.dart';

class WhatsAppSettingScreen extends StatefulWidget {
  const WhatsAppSettingScreen({super.key});

  @override
  State<WhatsAppSettingScreen> createState() => _WhatsAppSettingScreenState();
}

class _WhatsAppSettingScreenState extends State<WhatsAppSettingScreen> {
  final _numberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _numberController.text = StorageService.whatsappNumber;
  }

  void _save() {
    StorageService.setWhatsAppNumber(_numberController.text.trim());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('WhatsApp Number Saved Successfully!')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WhatsApp Setting')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _numberController,
              decoration: const InputDecoration(
                labelText: 'WhatsApp Number (with country code)',
                hintText: '+919999999999',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                child: const Text('Save Number'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}