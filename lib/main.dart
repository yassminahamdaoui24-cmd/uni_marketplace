import 'package:flutter/material.dart';
import 'app_theme.dart';

void main() {
  runApp(const UniMarketApp());
}

class UniMarketApp extends StatelessWidget {
  const UniMarketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Uni Marketplace',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme, 
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UniMarket'),
      ),
      body: Center(
        child: Text(
          'welcome to Uni Marketplace!',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.brunFonce,
          ),
        ),
      ),
    );
  }
}