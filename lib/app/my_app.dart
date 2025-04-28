import 'package:bca_student_app/app/currencyconverter_material_page.dart';
import 'package:bca_student_app/widgets/bottom_nav_bar.dart';
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
home: BottomNavigationBarExample(),    );
  }
}
