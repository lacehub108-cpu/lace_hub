import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomerAuthScreen extends StatefulWidget {
  const CustomerAuthScreen({super.key});

  @override
  State<CustomerAuthScreen> createState() => _CustomerAuthScreenState();
}

class _CustomerAuthScreenState extends State<CustomerAuthScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _isLogin = true;
  bool _isLoading = false;

  Future<void> _submit() async {
    if (_email.text.isEmpty || _password.text.isEmpty) return;
    setState(() => _isLoading = true);
    try {
      if (_isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _email.text.trim(), password: _password.text.trim());
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _email.text.trim(), password: _password.text.trim());
      }
      if (!mounted) return;
      Navigator.pop(context); // સફળતાપૂર્વક લોગિન થયા પછી પાછા જાઓ
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? 'Error')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isLogin ? 'Customer Login' : 'Customer Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person, size: 80, color: Colors.amber),
            const SizedBox(height: 30),
            TextField(controller: _email, decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder())),
            const SizedBox(height: 16),
            TextField(controller: _password, decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()), obscureText: true),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : Text(_isLogin ? 'Login' : 'Sign Up', style: const TextStyle(fontSize: 16)),
              ),
            ),
            TextButton(
              onPressed: () => setState(() => _isLogin = !_isLogin),
              child: Text(_isLogin ? 'નવું એકાઉન્ટ બનાવો (Sign Up)' : 'પહેલેથી એકાઉન્ટ છે? (Login)'),
            )
          ],
        ),
      ),
    );
  }
}