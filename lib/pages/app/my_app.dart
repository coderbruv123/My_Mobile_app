import 'package:bca_student_app/pages/screens/My_Home_page.dart';
import 'package:flutter/material.dart';



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Counter App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 234, 11, 11)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Prashant First Application'),
    );
  }
}
