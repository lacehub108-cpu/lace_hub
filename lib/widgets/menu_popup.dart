import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// અહીં 'hide AuthProvider' ઉમેર્યું છે જેથી ફાયરબેઝનું AuthProvider કન્ફ્લિક્ટ ના કરે
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider; 

import '../providers/auth_provider.dart';
import '../screens/customer/my_orders.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/settings/help_support.dart';
import '../screens/auth/login_screen.dart';
import '../screens/customer/customer_home.dart';
import '../screens/admin/whatsapp_setting_screen.dart';
import '../screens/admin/admin_setting_screen.dart';
import '../screens/customer/customer_auth_screen.dart';

List<PopupMenuEntry<String>> buildMenuItems(bool isAdmin) {
  if (isAdmin) {
    return const [
      PopupMenuItem(value: 'whatsapp_setting', child: Text('1. WhatsApp Setting')),
      PopupMenuItem(value: 'admin_setting', child: Text('2. Admin Setting')),
      PopupMenuItem(value: 'logout', child: Text('3. Logout')),
    ];
  }
  
  final user = FirebaseAuth.instance.currentUser;
  
  return [
    const PopupMenuItem(value: 'my_orders', child: Text('My Order')),
    const PopupMenuItem(value: 'settings', child: Text('Setting')),
    const PopupMenuItem(value: 'help', child: Text('Help & Support')),
    if (user == null) 
      const PopupMenuItem(value: 'customer_login', child: Text('Customer Login'))
    else
      const PopupMenuItem(value: 'customer_logout', child: Text('Logout')),
    const PopupMenuItem(value: 'admin_login', child: Text('Admin Login')),
  ];
}

Future<void> handleMenu(BuildContext context, String value, bool isAdmin) async {
  if (value == 'whatsapp_setting') {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const WhatsAppSettingScreen()));
  } else if (value == 'admin_setting') {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminSettingScreen()));
  } else if (value == 'logout') {
    // અહીં હવે ઓથેન્ટિકેશનમાં કોઈ કન્ફ્લિક્ટ નહીં થાય
    await context.read<AuthProvider>().logout();
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const CustomerHome()), (r) => false);
    }
  } else if (value == 'my_orders') {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const MyOrdersScreen()));
  } else if (value == 'settings') {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
  } else if (value == 'help') {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpSupportScreen()));
  } else if (value == 'admin_login') {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
  } else if (value == 'customer_login') {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const CustomerAuthScreen()));
  } else if (value == 'customer_logout') {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const CustomerHome()), (r) => false);
    }
  }
}