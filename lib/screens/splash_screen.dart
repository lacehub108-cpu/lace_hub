import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'customer/customer_home.dart';
import 'admin/admin_home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override void initState() { super.initState(); _nav(); }
  Future<void> _nav() async {
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    final auth = context.read<AuthProvider>();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => auth.isAdminLoggedIn ? const AdminHome() : const CustomerHome()));
  }
  @override Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Icon(Icons.diamond, size: 80, color: Theme.of(context).primaryColor)));
  }
}