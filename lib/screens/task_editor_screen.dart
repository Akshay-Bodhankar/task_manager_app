// lib/screens/task_editor_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

class TaskEditorScreen extends StatefulWidget {
  final Task? task;
  const TaskEditorScreen({super.key, this.task});
  @override
  State<TaskEditorScreen> createState() => _TaskEditorScreenState();
}

class _TaskEditorScreenState extends State<TaskEditorScreen> {
  final _form = GlobalKey<FormState>();
  late TextEditingController _title;
  late TextEditingController _description;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.task?.title ?? '');
    _description = TextEditingController(text: widget.task?.description ?? '');
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() { _busy = true; });
    final provider = Provider.of<TaskProvider>(context, listen: false);
    final task = Task(
      id: widget.task?.id,
      title: _title.text.trim(),
      description: _description.text.trim(),
      isDone: widget.task?.isDone ?? false,
    );
    bool ok;
    if (widget.task == null) {
      ok = await provider.addTask(task);
    } else {
      ok = await provider.editTask(task);
    }
    setState(() { _busy = false; });
    if (ok && mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.task != null;
    return Scaffold(
      appBar: AppBar(title: Text(editing ? 'Edit Task' : 'New Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: Column(children: [
            TextFormField(controller: _title, decoration: const InputDecoration(labelText: 'Title'),
              validator: (v) => (v == null || v.isEmpty) ? 'Enter title' : null),
            TextFormField(controller: _description, decoration: const InputDecoration(labelText: 'Description'),
              minLines: 2, maxLines: 6),
            const SizedBox(height: 16),
            FilledButton(onPressed: _busy ? null : _save, child: _busy ? const CircularProgressIndicator() : Text(editing ? 'Update' : 'Create')),
          ]),
        ),
      ),
    );
  }
}
