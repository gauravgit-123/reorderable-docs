
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reorder_doc/screens/view.dart';


void main() {
  runApp(const ProviderScope(
      child:
      MyApp()));
  // Wrap the app in ProviderScope to allow Riverpod to manage state
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('')),
        body: const Center(
          child:
          AnimatedIconsView(), // The main widget that displays draggable icons
        ),
      ),
    );
  }
}
