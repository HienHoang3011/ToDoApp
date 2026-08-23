import 'package:flutter/material.dart';

import '../controllers/todo_controller.dart';
import '../models/todo_item.dart';

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({required this.controller, super.key});

  final TodoController controller;

  @override
  State<TodoHomePage> createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  Future<void> _showAddTodoDialog() async {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    String title = '';

    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Thêm công việc cần làm'),
          content: Form(
            key: formKey,
            child: TextFormField(
              key: const Key('new-todo-field'),
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Ví dụ: Hoàn thành báo cáo',
                labelText: 'Tên công việc',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.done,
              validator: (String? value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Vui lòng nhập tên công việc';
                }
                return null;
              },
              onChanged: (String value) => title = value,
              onFieldSubmitted: (_) => _submitTodo(
                dialogContext,
                formKey,
                title,
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Hủy'),
            ),
            FilledButton(
              key: const Key('confirm-add-todo'),
              onPressed: () => _submitTodo(
                dialogContext,
                formKey,
                title,
              ),
              child: const Text('Thêm'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitTodo(
    BuildContext dialogContext,
    GlobalKey<FormState> formKey,
    String title,
  ) async {
    if (formKey.currentState?.validate() != true) {
      return;
    }

    await widget.controller.addTodo(title);
    if (dialogContext.mounted) {
      Navigator.of(dialogContext).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (BuildContext context, Widget? child) {
        final List<TodoItem> todos = widget.controller.todos;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Việc cần làm'),
            centerTitle: false,
          ),
          body: SafeArea(
            child: Column(
              children: <Widget>[
                _SummaryCard(
                  total: todos.length,
                  completed: widget.controller.completedCount,
                ),
                Expanded(
                  child: widget.controller.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : todos.isEmpty
                      ? const _EmptyState()
                      : ListView.separated(
                          key: const Key('todo-list'),
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
                          itemCount: todos.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 10),
                          itemBuilder: (BuildContext context, int index) {
                            final TodoItem todo = todos[index];
                            return _TodoCard(
                              todo: todo,
                              onToggle: () =>
                                  widget.controller.toggleTodo(todo.id),
                              onDelete: () =>
                                  widget.controller.deleteTodo(todo.id),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            key: const Key('add-todo-button'),
            onPressed: _showAddTodoDialog,
            icon: const Icon(Icons.add),
            label: const Text('Thêm việc'),
          ),
        );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.total, required this.completed});

  final int total;
  final int completed;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '$completed/$total công việc hoàn thành',
            key: const Key('todo-summary'),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: colors.onPrimaryContainer,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: total == 0 ? 0 : completed / total,
            minHeight: 8,
            borderRadius: BorderRadius.circular(8),
          ),
        ],
      ),
    );
  }
}

class _TodoCard extends StatelessWidget {
  const _TodoCard({
    required this.todo,
    required this.onToggle,
    required this.onDelete,
  });

  final TodoItem todo;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Material(
      color: todo.isCompleted
          ? colors.secondaryContainer.withValues(alpha: 0.55)
          : colors.surface,
      elevation: todo.isCompleted ? 0 : 1,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        leading: Checkbox(
          key: Key('todo-checkbox-${todo.id}'),
          value: todo.isCompleted,
          onChanged: (_) => onToggle(),
        ),
        title: Text(
          todo.title,
          key: Key('todo-title-${todo.id}'),
          style: TextStyle(
            color: todo.isCompleted ? colors.onSurfaceVariant : null,
            decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: IconButton(
          key: Key('delete-todo-${todo.id}'),
          tooltip: 'Xóa công việc',
          onPressed: onDelete,
          icon: const Icon(Icons.delete_outline),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.task_alt,
              size: 72,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Chưa có công việc nào',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'Nhấn “Thêm việc” để tạo công việc đầu tiên.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
