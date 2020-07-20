import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'To Do'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> _todoItems = [];

  void _addToList(String task) {
    if (task.length > 0) {
      setState(() {
        _todoItems.add(task);
      });
    }
  }

  void _removeFromList(int index) {
    setState(() {
      _todoItems.removeAt(index);
    });
  }

  void _promptRemoveDialog(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('mark "${_todoItems[index]}" as done?'),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                child: Text('Mark as read'),
                onPressed: () {
                  _removeFromList(index);
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Widget _buildTodoList() {
    return ListView.builder(itemBuilder: (context, index) {
      if (index < _todoItems.length) {
        return ListTile(
          title: Text(_todoItems[index]),
          onTap: () => _promptRemoveDialog(index),
        );
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _buildTodoList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddTaskPage,
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
