import 'package:edugo/screens/presentations/presentation1.dart';
import 'package:flutter/material.dart';
import 'package:edugo/screens/principales/exercice/exercice2.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: ExerciseMatiereListScreen(matiere: 'Mathématiques'),
      debugShowCheckedModeBanner: false,
    );
  }
}