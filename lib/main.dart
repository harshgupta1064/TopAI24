import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/auth/login_screen.dart';
import 'services/auth_service.dart';
import 'services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Supabase.initialize(
    // Replace these with your actual Supabase project URL and anon key
    url: 'https://kkflmstgbzlsvqyzomoe.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtrZmxtc3RnYnpsc3ZxeXpvbW9lIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDY1MTc5OTMsImV4cCI6MjA2MjA5Mzk5M30.tbOrkXky27hXJ0Ne6oaxynK9GjpCSfMbriqS4QuBEuM',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => SupabaseService()),
      ],
      child: MaterialApp(
        title: 'TopAI24 Assignment',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
