// lib/screens/task_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';
import 'task_editor_screen.dart';
import '../services/parse_config.dart';
import 'login_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});
  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<TaskProvider>(context, listen: false);
    provider.loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Tasks'),
        actions: [
          IconButton(
            onPressed: () =>
                Provider.of<TaskProvider>(context, listen: false).loadTasks(),
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Confirm Logout'),
                  content: const Text('Are you sure you want to log out?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );

              if (confirm != true) return;

              await ParseConfig.logout();
              if (!mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logged out successfully.'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );

              await Future.delayed(const Duration(seconds: 1));
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, prov, _) {
          if (prov.loading)
            return const Center(child: CircularProgressIndicator());
          final tasks = prov.tasks;
          if (tasks.isEmpty)
            return const Center(child: Text('No tasks yet. Tap + to add one.'));
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (ctx, i) {
              final t = tasks[i];
              return ListTile(
                title: Text(
                  t.title,
                  style: TextStyle(
                    decoration: t.isDone ? TextDecoration.lineThrough : null,
                  ),
                ),
                subtitle: Text(t.description),
                leading: Checkbox(
                  value: t.isDone,
                  onChanged: (_) => prov.toggleDone(t),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () async => await prov.deleteTask(t),
                ),
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => TaskEditorScreen(task: t),
                    ),
                  );
                  await prov.loadTasks();
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const TaskEditorScreen()));
          await Provider.of<TaskProvider>(context, listen: false).loadTasks();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _LoggedOut extends StatelessWidget {
  const _LoggedOut();
  @override
  Widget build(BuildContext context) => const Scaffold(
    body: Center(child: Text('Logged out. Restart app to login.')),
  );
}
