import 'package:flutter/material.dart';
import '../models/todo_model.dart';
import 'database.dart';

import 'addtask.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DatabaseHelper _db = DatabaseHelper.instance;
  Future<List<Todo>>? _data;

  @override
  void initState() {
    super.initState();
    _data = _db.getAllTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Todo App'),
      ),
      body: FutureBuilder<List<Todo>>(
        future: _data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Text('Erreur : ${snapshot.error}');
          }

          final todos = snapshot.data!;
          if (todos.isEmpty) {
            return const Center(
              child: Text("No Task"),
            );
          }

          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return CheckboxListTile(
                value: todo.isCompleted == 1,
                onChanged: (bool? value) async {
                  await _db.update(
                    Todo(
                        id: todo.id,
                        task: todo.task,
                        isCompleted: todo.isCompleted == 0 ? 1 : 0),
                  );
                  setState(() {
                    _data = _db.getAllTodos();
                  });
                },
                title: Text(todo.task),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskScreen()),
          );
          setState(() {
            _data = _db.getAllTodos();
          });
        },
        label: const Text('Add Task'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
