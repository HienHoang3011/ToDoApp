import 'package:flutter_test/flutter_test.dart';
import 'package:todo_mobile_app/models/todo_item.dart';

void main() {
  test('TodoItem copyWith preserves unchanged values', () {
    const TodoItem todo = TodoItem(id: '1', title: 'Demo CI/CD');

    final TodoItem completed = todo.copyWith(isCompleted: true);

    expect(completed.id, todo.id);
    expect(completed.title, todo.title);
    expect(completed.isCompleted, isTrue);
  });
}
