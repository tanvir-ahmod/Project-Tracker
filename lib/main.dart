import 'package:flutter/material.dart';
import 'package:flutterapp/databaseHelper.dart';

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

  final dbHelper = DatabaseHelper.instance;

  void _addToList(String task) {
    if (task.length > 0) {
      setState(() {
        _insertTask(task);
//        _todoItems.add(task);
      });
    }
  }

  void _insertTask(String task) async {
    Map<String, dynamic> row = {DatabaseHelper.columnTask: task};
    await dbHelper.insert(row);
  }

  void _removeFromList(int id) {
    setState(()  {
      _deleteRow(id);
    });
  }

  void _deleteRow(int id) async{
    await dbHelper.deleteData(id);
  }

  Widget _buildTodoList() {
    return FutureBuilder<List<Map<String, dynamic>>>(
        future: dbHelper.queryAllRows(),
        initialData: List(),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView(
            children: snapshot.data
                .map((e) => ListTile(
              title: Text(e[DatabaseHelper.columnTask]),
              onTap: () => _promptRemoveDialog(e[DatabaseHelper.columnId]),
            ))
                .toList(),
          )
              : null;
        });
  }

  void _promptRemoveDialog(int id) async {
    List<Map<String, dynamic>> text = await dbHelper.queryOneRow(id);
//    print(text);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('remove "${text[0][DatabaseHelper.columnTask]}"?'),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                child: Text('Remove'),
                onPressed: () {
                  _removeFromList(text[0][DatabaseHelper.columnId]);
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
      body: _buildTodoList(),
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
