import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminSettingScreen extends StatefulWidget {
  const AdminSettingScreen({super.key});

  @override
  State<AdminSettingScreen> createState() => _AdminSettingScreenState();
}

class _AdminSettingScreenState extends State<AdminSettingScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController.text = FirebaseAuth.instance.currentUser?.email ?? '';
  }

  Future<void> _save() async {
    setState(() => _isLoading = true);
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // ઈમેલ બદલવા માટે ફાયરબેઝનું નવું ફંક્શન
        if (_emailController.text.trim() != user.email && _emailController.text.isNotEmpty) {
          await user.verifyBeforeUpdateEmail(_emailController.text.trim());
        }

        // પાસવર્ડ બદલવો
        if (_passwordController.text.isNotEmpty) {
          await user.updatePassword(_passwordController.text.trim());
        }

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('બદલાવ સફળ! (ઈમેલ બદલવા માટે વેરિફિકેશન લિંક આવશે)')),
        );
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('એરર: ${e.message}')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Setting')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'New Admin Email', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'New Password (ખાલી રાખો જો ના બદલવો હોય)', border: OutlineInputBorder()),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _save,
                child: _isLoading ? const CircularProgressIndicator() : const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}