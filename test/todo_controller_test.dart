import 'package:flutter_test/flutter_test.dart';
import 'package:todo_mobile_app/controllers/todo_controller.dart';
import 'package:todo_mobile_app/models/todo_item.dart';

import 'helpers/memory_todo_store.dart';

void main() {
  group('TodoController', () {
    test('loads existing todos from the store', () async {
      const TodoItem existing = TodoItem(
        id: 'existing-id',
        title: 'Việc đã lưu',
        isCompleted: true,
      );
      final TodoController controller = TodoController(
        MemoryTodoStore(<TodoItem>[existing]),
      );

      await controller.loadTodos();

      expect(controller.todos, <TodoItem>[existing]);
      expect(controller.completedCount, 1);
      expect(controller.isLoading, isFalse);
    });

    test('adds a trimmed todo and persists it', () async {
      final MemoryTodoStore store = MemoryTodoStore();
      final TodoController controller = TodoController(
        store,
        clock: () => DateTime.fromMicrosecondsSinceEpoch(42),
      );

      final bool wasAdded = await controller.addTodo('  Viết unit test  ');

      expect(wasAdded, isTrue);
      expect(
        controller.todos,
        const <TodoItem>[TodoItem(id: '42', title: 'Viết unit test')],
      );
      expect(store.savedTodos, controller.todos);
      expect(store.saveCount, 1);
    });

    test('does not add an empty todo', () async {
      final MemoryTodoStore store = MemoryTodoStore();
      final TodoController controller = TodoController(store);

      final bool wasAdded = await controller.addTodo('   ');

      expect(wasAdded, isFalse);
      expect(controller.todos, isEmpty);
      expect(store.saveCount, 0);
    });

    test('toggles completion and persists the change', () async {
      const TodoItem todo = TodoItem(id: 'todo-1', title: 'Build APK');
      final MemoryTodoStore store = MemoryTodoStore(<TodoItem>[todo]);
      final TodoController controller = TodoController(store);
      await controller.loadTodos();

      await controller.toggleTodo(todo.id);

      expect(controller.todos.single.isCompleted, isTrue);
      expect(controller.completedCount, 1);
      expect(store.savedTodos.single.isCompleted, isTrue);
      expect(store.saveCount, 1);
    });

    test('deletes a todo and persists the remaining list', () async {
      const TodoItem first = TodoItem(id: '1', title: 'Analyze');
      const TodoItem second = TodoItem(id: '2', title: 'Test');
      final MemoryTodoStore store = MemoryTodoStore(<TodoItem>[first, second]);
      final TodoController controller = TodoController(store);
      await controller.loadTodos();

      await controller.deleteTodo(first.id);

      expect(controller.todos, <TodoItem>[second]);
      expect(store.savedTodos, <TodoItem>[second]);
      expect(store.saveCount, 1);
    });
  });
}
