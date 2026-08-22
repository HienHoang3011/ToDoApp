import 'package:flutter/foundation.dart';

import '../data/todo_store.dart';
import '../models/todo_item.dart';

class TodoController extends ChangeNotifier {
  TodoController(this._store, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final TodoStore _store;
  final DateTime Function() _clock;
  final List<TodoItem> _todos = <TodoItem>[];

  bool _isLoading = false;

  List<TodoItem> get todos => List<TodoItem>.unmodifiable(_todos);
  bool get isLoading => _isLoading;
  int get completedCount =>
      _todos.where((TodoItem todo) => todo.isCompleted).length;

  Future<void> loadTodos() async {
    _isLoading = true;
    notifyListeners();

    try {
      final List<TodoItem> storedTodos = await _store.loadTodos();
      _todos
        ..clear()
        ..addAll(storedTodos);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addTodo(String title) async {
    final String normalizedTitle = title.trim();
    if (normalizedTitle.isEmpty) {
      return false;
    }

    _todos.add(
      TodoItem(
        id: _clock().microsecondsSinceEpoch.toString(),
        title: normalizedTitle,
      ),
    );
    notifyListeners();
    await _persist();
    return true;
  }

  Future<void> toggleTodo(String id) async {
    final int index = _todos.indexWhere((TodoItem todo) => todo.id == id);
    if (index == -1) {
      return;
    }

    final TodoItem todo = _todos[index];
    _todos[index] = todo.copyWith(isCompleted: !todo.isCompleted);
    notifyListeners();
    await _persist();
  }

  Future<void> deleteTodo(String id) async {
    final int previousLength = _todos.length;
    _todos.removeWhere((TodoItem todo) => todo.id == id);
    if (_todos.length == previousLength) {
      return;
    }

    notifyListeners();
    await _persist();
  }

  Future<void> _persist() => _store.saveTodos(_todos);
}
