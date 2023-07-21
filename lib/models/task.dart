class Task {
  final String taskId;
  final String title;
  final String description;
  final DateTime dueDate;
  final int isCompleted;
  final String userId;

  Task({
    required this.taskId,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.isCompleted,
    required this.userId,
  });

  Task copyWith(
      {String? taskId,
      String? title,
      String? description,
      DateTime? dueDate,
      int? isCompleted,
      String? userId}) {
    return Task(
        taskId: taskId ?? this.taskId,
        title: title ?? this.title,
        description: description ?? this.description,
        dueDate: dueDate ?? this.dueDate,
        isCompleted: isCompleted ?? this.isCompleted,
        userId: userId ?? this.userId);
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
        taskId: map['taskId'],
        title: map['title'],
        description: map['description'],
        dueDate: DateTime.parse(map['dueDate']),
        isCompleted: map['isCompleted'],
        userId: map['userId']);
  }

  Map<String, dynamic> toMap() {
    return {
      'taskId': taskId,
      'title': title,
      'description': description,
      'dueDate': dueDate.toString(),
      'isCompleted': isCompleted,
      'userId': userId
    };
  }
}
