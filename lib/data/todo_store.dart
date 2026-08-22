import '../models/todo_item.dart';

abstract interface class TodoStore {
  Future<List<TodoItem>> loadTodos();

  Future<void> saveTodos(List<TodoItem> todos);
}
