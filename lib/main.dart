import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'services/storage_service.dart';
import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/lace_provider.dart';
import 'providers/inquiry_provider.dart';
import 'providers/order_provider.dart';
import 'screens/splash_screen.dart';
import 'utils/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. સૌથી પહેલા સ્ટોરેજ ઇનિશિયલાઇઝ કરો (ખૂબ જરૂરી)
  await StorageService.init();
  
  // 2. પછી ફાયરબેઝ
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const LaceHubApp());
}

class LaceHubApp extends StatelessWidget {
  const LaceHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => LaceProvider()),
        ChangeNotifierProvider(create: (_) => InquiryProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProv, _) => MaterialApp(
          title: 'Lace Hub',
          debugShowCheckedModeBanner: false,
          themeMode: themeProv.mode,
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: AppColors.primary,
            scaffoldBackgroundColor: AppColors.lightBg,
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: AppColors.primary,
            scaffoldBackgroundColor: AppColors.darkBg,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primary, 
              brightness: Brightness.dark
            ),
            useMaterial3: true,
          ),
          home: const SplashScreen(),
        ),
      ),
    );
  }
}