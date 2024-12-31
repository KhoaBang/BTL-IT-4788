import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/api/firebase_api.dart';
import 'package:frontend/pages/signin_page.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables if needed
  await dotenv.load(fileName: ".env");

  // Initialize Firebase with options from the Firebase console
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCe-VPLtvgXILVMEpXxFKDNcpN_GHICPJ0",
      appId: "1:382306244702:android:e2f90ce90670bf1137fccf",
      messagingSenderId: "382306244702",  // Added messagingSenderId
      projectId: "it4788-5bb29",  // Added projectId
      storageBucket: "it4788-5bb29.firebasestorage.app",
    ),
  );

  // Initialize Firebase notifications (if needed)
  await FirebaseApi().initNotification();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MealPrep',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SignInPage(),  // Your app's home page
      debugShowCheckedModeBanner: false,  // Disable debug banner
    );
  }
}
