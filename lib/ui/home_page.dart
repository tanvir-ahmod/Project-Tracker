import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterapp/bloc/task_bloc.dart';
import 'package:flutterapp/database/databaseHelper.dart';
import 'package:flutterapp/model/Task.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TasksBlock _tasksBlock = TasksBlock();

  void _addToList(String taskName) {
    if (taskName.length > 0) {
      setState(() {
        _tasksBlock.insertTask(Task(taskName: taskName));
      });
    }
  }


  Widget _buildTaskList() {
    return StreamBuilder(
        stream: _tasksBlock.tasks,
        builder: (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
          return _taskWidget(snapshot);
        });
  }

  Widget _taskWidget(AsyncSnapshot<List<Task>> snapshot) {
    if (snapshot.hasData) {
      return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (context, position) {
            Task task = snapshot.data[position];
            return Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.grey[200], width: 0.5),
                  borderRadius: BorderRadius.circular(5),
                ),
                color: Colors.white,
                child: ListTile(
                    onTap: () => _promptRemoveDialog(task),
                    title: Text(
                      task.taskName,
                      style: TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w500,
                      ),
                    )));
          });
    } else
      return Center(
        child: _loadingData(),
      );
  }

  Widget _loadingData() {
    _tasksBlock.fetchAllTasks();
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            Text("Loading...",
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  void _promptRemoveDialog(Task task) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('remove ${task.taskName}"?'),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                child: Text('Remove'),
                onPressed: () {
                  _tasksBlock.deleteRowByID(task.id);
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _buildTaskList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _goToAddTaskPage(),
        tooltip: "Add Task",
        child: Icon(Icons.add),
      ),
    );
  }

  void _goToAddTaskPage() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return Scaffold(
          appBar: AppBar(title: Text('Add a new task')),
          body: TextField(
            autofocus: true,
            onSubmitted: (val) {
              _addToList(val);
              Navigator.pop(context);
            },
            decoration: InputDecoration(
                hintText: 'Enter a new task',
                contentPadding: EdgeInsets.all(16.0)),
          ));
    }));
  }
}
