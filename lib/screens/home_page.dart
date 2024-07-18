// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:ngonitodolist/task/edittask.dart';
import 'package:ngonitodolist/task/todo_list.dart';

class ToDoItem {
  final String title;
  final String description;
  final DateTime dueDate;
  final TimeOfDay dueTime;
  final bool completed;

  ToDoItem({
    required this.title,
    required this.description,
    required this.dueDate,
    required this.dueTime,
    this.completed = false,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<ToDoItem> todoItems = [
    ToDoItem(
      title: 'Task 1',
      description: 'Description for Task 1',
      dueDate: DateTime(2024, 7, 15),
      dueTime: const TimeOfDay(hour: 9, minute: 0),
  
    ),
    ToDoItem(
      title: 'Task 2',
      description: 'Description for Task 2',
      dueDate: DateTime(2024, 7, 16),
      dueTime: const TimeOfDay(hour: 14, minute: 30),
      completed: true,
    ),
    
  ];

  String newTaskTitle = '';
  String newTaskDescription = '';
  DateTime newTaskDueDate = DateTime.now();
  TimeOfDay newTaskDueTime = TimeOfDay.now();
  
  get selectedTime => null;

  void addTask() {
    if (newTaskTitle.isNotEmpty) {
      setState(() {
        todoItems.add(
          ToDoItem(
            title: newTaskTitle,
            description: newTaskDescription,
            dueDate: newTaskDueDate,
            dueTime: newTaskDueTime,
          ),
        );
        newTaskTitle = '';
        newTaskDescription = '';
        newTaskDueDate = DateTime.now();
        newTaskDueTime = TimeOfDay.now();
      });
    }
  }

  void deleteTask(int index) {
    setState(() {
      todoItems.removeAt(index);
    });
  }

  void navigateToTaskDetails(ToDoItem task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailsPage(task: task),
      ),
    );
  }

  void navigateToEditTask(ToDoItem task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTaskPage(task: task),
      ),
    ).then((editedTask) {
      if (editedTask != null) {
        updateTask(task, editedTask);
      }
    });
  }

  void updateTask(ToDoItem oldTask, ToDoItem editedTask) {
    setState(() {
      final index = todoItems.indexOf(oldTask);
      todoItems[index] = editedTask;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 119, 116, 117),
        title: const Text(
          'NgoniToDoList',
          style: TextStyle(
            color: Colors.yellow,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: todoItems.length,
        itemBuilder: (context, index) {
          final item = todoItems[index];
          return ListTile(
            title: Text(item.title),
            subtitle: Text(item.description),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    navigateToEditTask(item);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    deleteTask(index);
                  },
                ),
              ],
            ),
            onTap: () {
              navigateToTaskDetails(item);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Add Task'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          newTaskTitle = value;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Title',
                      ),
                    ),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          newTaskDescription = value;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                    ),
                    ListTile(
                      title: const Text('Due Date'),
                      subtitle: Text(
                        '${newTaskDueDate.year}-${newTaskDueDate.month}-${newTaskDueDate.day}',
                      ),
                      onTap: () async {
                        if (selectedTime != null) {
                          setState(() {
                            newTaskDueTime = selectedTime;
                          });
                        }
                      },
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      addTask();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
