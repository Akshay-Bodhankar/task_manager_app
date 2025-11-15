// lib/providers/task_provider.dart
import 'package:flutter/foundation.dart';
import '../models/task.dart';
import '../helpers/db_helper.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  bool _loading = false;

  List<Task> get tasks => _tasks;
  bool get loading => _loading;

  Future<void> loadTasks() async {
    _loading = true;
    notifyListeners();
    try {
      _tasks = await DBHelper.fetchTasksForCurrentUser();
    } catch (e) {
      _tasks = [];
      if (kDebugMode) print('loadTasks error: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> addTask(Task t) async {
    _loading = true;
    notifyListeners();
    final ok = await DBHelper.createTask(t);
    if (ok) await loadTasks();
    _loading = false;
    notifyListeners();
    return ok;
  }

  Future<bool> editTask(Task t) async {
    _loading = true;
    notifyListeners();
    final ok = await DBHelper.updateTask(t);
    if (ok) await loadTasks();
    _loading = false;
    notifyListeners();
    return ok;
  }

  Future<bool> toggleDone(Task t) async {
    final ok = await DBHelper.toggleTaskDone(t);
    if (ok) {
      // update local model quickly (optimistic)
      final idx = _tasks.indexWhere((x) => x.id == t.id);
      if (idx != -1) {
        _tasks[idx].isDone = !_tasks[idx].isDone;
        notifyListeners();
      } else {
        await loadTasks();
      }
    }
    return ok;
  }

  Future<bool> deleteTask(Task t) async {
    _loading = true;
    notifyListeners();
    final ok = await DBHelper.deleteTask(t);
    if (ok) await loadTasks();
    _loading = false;
    notifyListeners();
    return ok;
  }
}
