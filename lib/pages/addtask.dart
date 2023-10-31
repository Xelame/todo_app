import 'package:flutter/material.dart';
import 'package:tp_fiverpod_freezed/main.dart';
import 'package:tp_fiverpod_freezed/models/todo_model.dart';
import 'package:tp_fiverpod_freezed/pages/database.dart';

class AddTaskScreen extends StatefulWidget {

  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  
  final TextEditingController _taskNameController = TextEditingController();

  void _addTaskToList() {
    String taskTitle = _taskNameController.text;
    if (taskTitle.isNotEmpty) {
      DatabaseHelper.instance.insert(Todo(task: taskTitle, isCompleted: 0));
      _taskNameController.clear();
      Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyHomePage(title: "De Retour")),
          ); // Revenir à l'écran principal
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task name cannot be empty'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Add Task'),
      ),
      body: Center(
        child: Column(
          children: [
            TextFormField(
              controller: _taskNameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Task Name',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _addTaskToList();
              },
              child: const Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}