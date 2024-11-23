import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:job_apply_hub/Screens/Features/ImageToPDF/imgToPdf.dart';
import 'package:job_apply_hub/Screens/Features/ImgToPDF/screens/main_screen/main_screen.dart';
import 'package:job_apply_hub/Screens/Features/Resume/ResumeHomeScreen.dart';
import 'package:job_apply_hub/Screens/homeScreen.dart';
import 'package:job_apply_hub/Screens/on_boading_screen.dart';
import 'package:job_apply_hub/Screens/splash_screen.dart';
import 'Screens/sign_in_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JobApplyHub',
      debugShowCheckedModeBanner: false ,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      
      home: SplashScreen(),
      routes: {
        '/home': (context) => HomeScreen(),
        '/login': (context) => SignInScreen(),
        '/onboarding': (context) => OnboardingScreen(),
        '/resumeBuilder' :(context)=> HtmlStringLoader(),
        '/imgToPdf':(context)=>  ImageToPDFPage(),// Route for Home screen
      },
    );
  }
}
