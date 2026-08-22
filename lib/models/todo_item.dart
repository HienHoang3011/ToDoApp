class TodoItem {
  const TodoItem({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });

  final String id;
  final String title;
  final bool isCompleted;

  TodoItem copyWith({String? title, bool? isCompleted}) {
    return TodoItem(
      id: id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, Object> toJson() {
    return <String, Object>{
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
    };
  }

  factory TodoItem.fromJson(Map<String, Object?> json) {
    return TodoItem(
      id: json['id'] as String,
      title: json['title'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is TodoItem &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            title == other.title &&
            isCompleted == other.isCompleted;
  }

  @override
  int get hashCode => Object.hash(id, title, isCompleted);
}
