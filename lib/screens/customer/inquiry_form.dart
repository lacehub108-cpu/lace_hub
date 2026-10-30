import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/lace_model.dart';
import '../../models/inquiry_model.dart';
import '../../models/order_model.dart';
import '../../services/firebase_service.dart';
import 'customer_auth_screen.dart'; // <-- લોગિન સ્ક્રીન ઈમ્પોર્ટ કરી

class InquiryFormScreen extends StatefulWidget {
  final LaceModel lace;
  final bool isOrder;
  const InquiryFormScreen({super.key, required this.lace, required this.isOrder});

  @override
  State<InquiryFormScreen> createState() => _InquiryFormScreenState();
}

class _InquiryFormScreenState extends State<InquiryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();
  final _qty = TextEditingController();
  bool _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // લોગિન ચેક કરો
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const CustomerAuthScreen()));
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ઓર્ડર કરવા માટે પહેલા લોગિન કરો!')));
      return;
    }

    setState(() => _isLoading = true);
    final id = DateTime.now().millisecondsSinceEpoch.toString();

    try {
      if (widget.isOrder) {
        await FirebaseService.addOrder(OrderModel(
          id: id, 
          customerId: user.uid, // <-- યુઝર આઈડી પાસ કરી
          laceId: widget.lace.id, designNumber: widget.lace.designNumber,
          laceName: widget.lace.name, imagePath: widget.lace.imagePath,
          customerName: _name.text.trim(), phone: _phone.text.trim(), address: _address.text.trim(),
          quantity: int.parse(_qty.text), status: 'pending', isRead: false, createdAt: DateTime.now(),
        ));
      } else {
        await FirebaseService.addInquiry(InquiryModel(
          id: id, 
          customerId: user.uid, // <-- યુઝર આઈડી પાસ કરી
          laceId: widget.lace.id, designNumber: widget.lace.designNumber,
          laceName: widget.lace.name, imagePath: widget.lace.imagePath,
          customerName: _name.text.trim(), phone: _phone.text.trim(), address: _address.text.trim(),
          status: 'pending', isRead: false, createdAt: DateTime.now(),
        ));
      }

      final msg = Uri.encodeComponent(
        'Hi, I want ${widget.isOrder ? "to order" : "to inquire"} - ${widget.lace.name} '
        '(Design No: ${widget.lace.designNumber}). Name: ${_name.text}, Phone: ${_phone.text}'
        '${widget.isOrder ? ", Qty: ${_qty.text}" : ""}',
      );
      final waUri = Uri.parse('https://wa.me/?text=$msg');
      if (await canLaunchUrl(waUri)) {
        await launchUrl(waUri, mode: LaunchMode.externalApplication);
      }

      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(widget.isOrder ? 'ઓર્ડર સફળતાપૂર્વક મોકલાયો!' : 'ઇન્ક્વાયરી સફળતાપૂર્વક મોકલાઈ!'),
      ));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.isOrder ? 'WhatsApp Order' : 'WhatsApp Inquiry'), centerTitle: true),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(widget.isOrder ? Icons.shopping_cart : Icons.message, size: 60, color: Theme.of(context).primaryColor),
                const SizedBox(height: 30),
                _buildTextField(_name, 'Full Name', Icons.person),
                const SizedBox(height: 16),
                _buildTextField(_phone, 'Phone Number', Icons.phone, keyboard: TextInputType.phone, validator: (v) => (v == null || v.length < 10) ? 'Enter valid phone' : null),
                const SizedBox(height: 16),
                _buildTextField(_address, 'Address', Icons.location_on, maxLines: 2),
                const SizedBox(height: 16),
                if (widget.isOrder)
                  _buildTextField(_qty, 'Quantity (pieces)', Icons.numbers, keyboard: TextInputType.number, validator: (v) => int.tryParse(v ?? '') == null ? 'Enter quantity' : null),
                const SizedBox(height: 30),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    child: _isLoading 
                      ? const CircularProgressIndicator(color: Colors.white) 
                      : Text(widget.isOrder ? 'Place Order' : 'Send Inquiry', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String label, IconData icon, {TextInputType? keyboard, int maxLines = 1, String? Function(String?)? validator}) {
    return TextFormField(
      controller: ctrl,
      keyboardType: keyboard,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: validator ?? (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
    );
  }
}