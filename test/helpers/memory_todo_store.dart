import 'package:todo_mobile_app/data/todo_store.dart';
import 'package:todo_mobile_app/models/todo_item.dart';

class MemoryTodoStore implements TodoStore {
  MemoryTodoStore([List<TodoItem> initialTodos = const <TodoItem>[]])
    : _todos = List<TodoItem>.of(initialTodos);

  List<TodoItem> _todos;
  int saveCount = 0;

  List<TodoItem> get savedTodos => List<TodoItem>.unmodifiable(_todos);

  @override
  Future<List<TodoItem>> loadTodos() async => List<TodoItem>.of(_todos);

  @override
  Future<void> saveTodos(List<TodoItem> todos) async {
    _todos = List<TodoItem>.of(todos);
    saveCount += 1;
  }
}
