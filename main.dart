import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quản lý công việc cá nhân',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  final List<Task> tasks = [
    Task(
      name: "Đi làm",
      description: "Nhân viên siêu thị",
      deadline: DateTime(2023, 3, 23),
    ),
    Task(
      name: "Làm bài tập",
      description: "Viết báo cáo cho môn di dộng",
      deadline: DateTime(2023, 3, 20),
    ),
    Task(
      name: "housework",
      description: "dọn dẹp",
      deadline: DateTime(2023, 3,25),
    ),
  ];

  @override
  _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {
  void _addNewTask(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return AddTaskPage();
    })).then((newTask) {
      if (newTask != null) {
        setState(() {
          widget.tasks.add(newTask);
        });
      }
    });
  }
  void _deleteTask(int index) {
    setState(() {
      widget.tasks.removeAt(index);
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Danh sách công việc"),
      ),
      body: TaskList(tasks: widget.tasks),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNewTask(context),
        tooltip: 'Thêm',
        child: Icon(Icons.add),
      ),
    );
  }
}

class TaskList extends StatelessWidget {
  final List<Task> tasks;

  TaskList({required this.tasks});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return TaskItem(task: tasks[index]);
      },
    );
  }
}

class TaskItem extends StatelessWidget {
  final Task task;

  TaskItem({required this.task});

  @override
  Widget build(BuildContext context) {
    final bool isOverdue = task.deadline.isBefore(DateTime.now());

    return ListTile(
      title: Text(
        task.name,
        style: TextStyle(
          color: isOverdue ? Colors.red : Colors.black,
        ),
      ),
      subtitle: Text(
        task.description,
        style: TextStyle(
          color: isOverdue ? Colors.red : Colors.black,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            task.deadline.toString(),
            style: TextStyle(
              color: isOverdue ? Colors.red : Colors.black,
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _deleteTask(context, task);
            },
          ),
          // IconButton(
          //   icon: Icon(Icons.edit),
          //   onPressed: () {
          //     _editTask(context, task);
          //   },
          // ),
        ],
      ),
      leading: Checkbox(
        value: task.isCompleted,
        onChanged: (value) {
          // Xử lý sự kiện khi checkbox được thay đổi
        },
      ),
    );
  }
}

void _deleteTask(BuildContext context, Task task) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Xóa '),
        content: Text('Bạn có chắc chắn muốn xóa công việc này?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Xóa'),
          ),
        ],
      );
    },
  );
}

void _editTask(BuildContext context, Task task) {}

class Task {
  String name;
  String description;
  DateTime deadline;
  bool isOverdue;
  bool isCompleted;
  Task({
    required this.name,
    required this.description,
    required this.deadline,
    this.isOverdue = false,
    this.isCompleted = false,
  });
}

class AddTaskPage extends StatefulWidget {
  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();
  late String _taskName;
  late String _taskDescription;
  late DateTime _taskDeadline;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Tên công việc',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'nhập tên công việc';
                  }
                  return null;
                },
                onSaved: (value) {
                  _taskName = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Mô tả',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'nhập mô tả ';
                  }
                  return null;
                },
                onSaved: (value) {
                  _taskDescription = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Ngày hết hạn',
                ),
                onTap: () async {
                  DateTime? date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    TimeOfDay? time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (time != null) {
                      setState(() {
                        _taskDeadline = DateTime(
                          date.year,
                          date.month,
                          date.day,
                          time.hour,
                          time.minute,
                        );
                      });
                    }
                  }
                },
                readOnly: true,
                validator: (value) {
                  if (_taskDeadline == null) {
                    return 'chọn ngày hết hạn';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      Task newTask = Task(
                        name: _taskName,
                        description: _taskDescription,
                        deadline: _taskDeadline,
                      );
                      Navigator.of(context).pop(newTask);
                    }
                  },
                  child: Text('Lưu'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
