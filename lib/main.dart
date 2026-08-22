import 'package:flutter/material.dart';

import 'controllers/todo_controller.dart';
import 'data/shared_preferences_todo_store.dart';
import 'todo_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final TodoController controller = TodoController(
    SharedPreferencesTodoStore(),
  );
  await controller.loadTodos();

  runApp(TodoApp(controller: controller));
}
