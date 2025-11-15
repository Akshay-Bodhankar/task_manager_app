// lib/helpers/db_helper.dart
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import '../models/task.dart';
import '../services/parse_config.dart' as localConfig;

class DBHelper {
  // Fetch tasks for current user
  static Future<List<Task>> fetchTasksForCurrentUser() async {
    final user = await localConfig.ParseConfig.currentUser();
    if (user == null) return [];

    final query = QueryBuilder<ParseObject>(ParseObject(Task.className))
      ..whereEqualTo('owner', user)
      ..orderByDescending('createdAt');

    final res = await query.query();
    if (res.success && res.results != null) {
      return res.results!.map((e) => Task.fromParse(e as ParseObject)).toList();
    }
    return [];
  }

  // Create a new task and set owner ACL
  static Future<bool> createTask(Task task) async {
    final user = await localConfig.ParseConfig.currentUser();
    final obj = task.toParseObject();
    if (user != null) {
      obj.set('owner', ParseObject('_User')..objectId = user.objectId);
      obj.setACL(ParseACL(owner: user));
    }
    final res = await obj.save();
    return res.success;
  }

  // Update fields of an existing task
  static Future<bool> updateTask(Task task) async {
    if (task.id == null) return false;
    final obj = ParseObject(Task.className)
      ..objectId = task.id
      ..set('title', task.title)
      ..set('description', task.description)
      ..set('isDone', task.isDone);
    final res = await obj.save();
    return res.success;
  }

  // Toggle isDone quickly
  static Future<bool> toggleTaskDone(Task task) async {
    if (task.id == null) return false;
    final obj = ParseObject(Task.className)
      ..objectId = task.id
      ..set('isDone', !task.isDone);
    final res = await obj.save();
    return res.success;
  }

  // Delete task
  static Future<bool> deleteTask(Task task) async {
    if (task.id == null) return false;
    final obj = ParseObject(Task.className)..objectId = task.id;
    final res = await obj.delete();
    return res.success;
  }
}
