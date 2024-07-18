// ignore_for_file: library_private_types_in_public_api, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:ngonitodolist/screens/home_page.dart';

void navigateToEditTask(BuildContext context, ToDoItem task) {
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
    var todoItems;
    final index = todoItems.indexOf(oldTask);
    todoItems[index] = editedTask;
  });
}

void setState(Null Function() param0) {
}

// ...

class EditTaskPage extends StatefulWidget {
  final ToDoItem task;

  const EditTaskPage({super.key, required this.task});

  @override
  _EditTaskPageState createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  late String editedTitle;
  late String editedDescription;
  late DateTime editedDueDate;
  late TimeOfDay editedDueTime;

  @override
  void initState() {
    super.initState();
    editedTitle = widget.task.title;
    editedDescription = widget.task.description;
    editedDueDate = widget.task.dueDate;
    editedDueTime = widget.task.dueTime;
  }

  void saveChanges() {
    final editedTask = ToDoItem(
      title: editedTitle,
      description: editedDescription,
      dueDate: editedDueDate,
      dueTime: editedDueTime,
      completed: widget.task.completed,
    );
    Navigator.pop(context, editedTask);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  editedTitle = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
              controller: TextEditingController(text: editedTitle),
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  editedDescription = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
              controller: TextEditingController(text: editedDescription),
            ),
            ListTile(
              title: const Text('Due Date'),
              subtitle: Text(
                '${editedDueDate.year}-${editedDueDate.month}-${editedDueDate.day}',
              ),
              onTap: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: editedDueDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (selectedDate != null) {
                  setState(() {
                    editedDueDate = selectedDate;
                  });
                }
              },
            ),
            ListTile(
              title: const Text('Due Time'),
              subtitle: Text(editedDueTime.format(context)),
              onTap: () async {
                final selectedTime = await showTimePicker(
                  context: context,
                  initialTime: editedDueTime,
                );
                if (selectedTime != null) {
                  setState(() {
                    editedDueTime = selectedTime;
                  });
                }
              },
            ),
            ElevatedButton(
              onPressed: saveChanges,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}