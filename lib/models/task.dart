// lib/models/task.dart
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class Task {
  String? id;
  String title;
  String description;
  bool isDone;
  String? ownerId;

  Task({
    this.id,
    required this.title,
    required this.description,
    this.isDone = false,
    this.ownerId,
  });

  static const String className = 'Task';

  ParseObject toParseObject() {
    final obj = ParseObject(className);
    if (id != null) obj.objectId = id;
    obj.set<String>('title', title);
    obj.set<String>('description', description);
    obj.set<bool>('isDone', isDone);
    return obj;
  }

  static Task fromParse(ParseObject o) {
    final owner = o.get<ParseUser>('owner') as ParseUser?;
    return Task(
      id: o.objectId,
      title: o.get<String>('title') ?? '',
      description: o.get<String>('description') ?? '',
      isDone: o.get<bool>('isDone') ?? false,
      ownerId: owner?.objectId,
    );
  }
}
