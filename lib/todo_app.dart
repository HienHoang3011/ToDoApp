import 'package:flutter/material.dart';

import 'controllers/todo_controller.dart';
import 'screens/todo_home_page.dart';

class TodoApp extends StatelessWidget {
  const TodoApp({required this.controller, super.key});

  final TodoController controller;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo Mobile App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF006C67)),
        scaffoldBackgroundColor: const Color(0xFFF5F7F7),
        useMaterial3: true,
      ),
      home: TodoHomePage(controller: controller),
    );
  }
}
