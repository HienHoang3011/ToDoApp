import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_mobile_app/controllers/todo_controller.dart';
import 'package:todo_mobile_app/models/todo_item.dart';
import 'package:todo_mobile_app/todo_app.dart';

import 'helpers/memory_todo_store.dart';

void main() {
  testWidgets('user can add a new todo', (WidgetTester tester) async {
    final TodoController controller = TodoController(
      MemoryTodoStore(),
      clock: () => DateTime.fromMicrosecondsSinceEpoch(100),
    );
    addTearDown(() => _disposeTestApp(tester, controller));
    await tester.pumpWidget(TodoApp(controller: controller));

    await tester.tap(find.byKey(const Key('add-todo-button')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.enterText(
      find.byKey(const Key('new-todo-field')),
      'Chuẩn bị demo',
    );
    await tester.tap(find.byKey(const Key('confirm-add-todo')));
    await tester.pumpAndSettle();

    expect(find.text('Chuẩn bị demo'), findsOneWidget);
    expect(find.text('0/1 công việc hoàn thành'), findsOneWidget);
  });

  testWidgets('user can mark a todo as completed', (
    WidgetTester tester,
  ) async {
    const TodoItem todo = TodoItem(id: 'demo-task', title: 'Build APK');
    final TodoController controller = TodoController(
      MemoryTodoStore(<TodoItem>[todo]),
    );
    addTearDown(() => _disposeTestApp(tester, controller));
    await controller.loadTodos();
    await tester.pumpWidget(TodoApp(controller: controller));

    Checkbox checkbox = tester.widget<Checkbox>(
      find.byKey(const Key('todo-checkbox-demo-task')),
    );
    expect(checkbox.value, isFalse);

    final Finder checkboxFinder = find.byKey(
      const Key('todo-checkbox-demo-task'),
    );
    await tester.ensureVisible(checkboxFinder);
    await tester.tap(checkboxFinder);
    await tester.pumpAndSettle();

    checkbox = tester.widget<Checkbox>(
      find.byKey(const Key('todo-checkbox-demo-task')),
    );
    final Text title = tester.widget<Text>(
      find.byKey(const Key('todo-title-demo-task')),
    );
    expect(checkbox.value, isTrue);
    expect(title.style?.decoration, TextDecoration.lineThrough);
    expect(find.text('1/1 công việc hoàn thành'), findsOneWidget);
  });

  testWidgets('user can delete a todo', (WidgetTester tester) async {
    const TodoItem todo = TodoItem(id: 'remove-me', title: 'Việc cần xóa');
    final TodoController controller = TodoController(
      MemoryTodoStore(<TodoItem>[todo]),
    );
    addTearDown(() => _disposeTestApp(tester, controller));
    await controller.loadTodos();
    await tester.pumpWidget(TodoApp(controller: controller));

    final Finder deleteFinder = find.byKey(
      const Key('delete-todo-remove-me'),
    );
    await tester.ensureVisible(deleteFinder);
    await tester.tap(deleteFinder);
    await tester.pumpAndSettle();

    expect(find.text('Việc cần xóa'), findsNothing);
    expect(find.text('Chưa có công việc nào'), findsOneWidget);
  });
}

Future<void> _disposeTestApp(
  WidgetTester tester,
  TodoController controller,
) async {
  await tester.pumpWidget(const SizedBox.shrink());
  controller.dispose();
}
