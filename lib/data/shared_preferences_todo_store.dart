import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/todo_item.dart';
import 'todo_store.dart';

class SharedPreferencesTodoStore implements TodoStore {
  SharedPreferencesTodoStore({SharedPreferencesAsync? preferences})
    : _preferences = preferences ?? SharedPreferencesAsync();

  static const String _storageKey = 'todo_items_v1';

  final SharedPreferencesAsync _preferences;

  @override
  Future<List<TodoItem>> loadTodos() async {
    final String? rawTodos = await _preferences.getString(_storageKey);
    if (rawTodos == null || rawTodos.isEmpty) {
      return <TodoItem>[];
    }

    try {
      final List<Object?> decoded = jsonDecode(rawTodos) as List<Object?>;
      return decoded
          .map(
            (Object? item) => TodoItem.fromJson(
              Map<String, Object?>.from(item! as Map<Object?, Object?>),
            ),
          )
          .toList(growable: false);
    } on FormatException {
      return <TodoItem>[];
    } on TypeError {
      return <TodoItem>[];
    }
  }

  @override
  Future<void> saveTodos(List<TodoItem> todos) async {
    final String encoded = jsonEncode(
      todos.map((TodoItem todo) => todo.toJson()).toList(growable: false),
    );
    await _preferences.setString(_storageKey, encoded);
  }
}
