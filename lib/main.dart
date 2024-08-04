import 'package:flutter/material.dart';
import 'package:login/LoginScreen.dart';
import 'package:login/ProfileScreen.dart';
import 'package:login/addTaskScreen.dart';
import 'package:login/onboardingScreen.dart';
import 'package:login/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://prdkkbxfibwpgtcckgqw.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InByZGtrYnhmaWJ3cGd0Y2NrZ3F3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjI1MzY5ODMsImV4cCI6MjAzODExMjk4M30.r2eZJMBsLc9NLKN0-ZztAok7Bakhw-kw8hkRaWzOV50',
  );
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MisTasks',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
           seedColor: const Color( 0xFF4563DB),
          
          brightness: Brightness.light, // Tema claro
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7B51D3),
          brightness: Brightness.dark, // Tema oscuro
        ),
      ),
      themeMode: ThemeMode.system,
      initialRoute: supabase.auth.currentSession != null ? '/home' : '/',
      routes: {
        '/': (context) =>  OnboardingScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
