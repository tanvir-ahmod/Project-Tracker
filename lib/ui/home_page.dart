import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterapp/bloc/task_bloc.dart';
import 'package:flutterapp/controller/todo_controller.dart';
import 'package:flutterapp/data/model/Task.dart';
import 'package:get/get.dart';

class MyHomePage extends StatelessWidget {
  final TasksBlock _tasksBlock = TasksBlock();
  final TodoController _todoController = Get.put(TodoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: _buildTaskList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTodoSheet(context),
        tooltip: "Add Task",
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskList() {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            flex: 8,
            child: GetBuilder<TodoController>(
              builder: (_dx) => ListView.builder(
                  itemCount: _dx.totoItems.length,
                  itemBuilder: (context, index) {
                    return Card(
                        shape: RoundedRectangleBorder(
                          side:
                              BorderSide(color: Colors.grey[200]!, width: 0.5),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        color: Colors.white,
                        child: ListTile(
                          title: Text(
                            _dx.totoItems[index].taskName,
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete,
                              size: 40,
                            ),
                            onPressed: () => {
                              // _promptRemoveDialog(task)
                            },
                          ),
                        ));
                  }),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddTodoSheet(BuildContext context) {
    final _todoDescriptionFormController = TextEditingController();
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: new Container(
              color: Colors.transparent,
              child: new Container(
                height: 230,
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(10.0),
                        topRight: const Radius.circular(10.0))),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 15, top: 25.0, right: 15, bottom: 30),
                  child: ListView(
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              controller: _todoDescriptionFormController,
                              textInputAction: TextInputAction.newline,
                              maxLines: 4,
                              style: TextStyle(
                                  fontSize: 21, fontWeight: FontWeight.w400),
                              autofocus: true,
                              decoration: const InputDecoration(
                                  hintText: 'I have to...',
                                  labelText: 'New Task',
                                  labelStyle: TextStyle(
                                      color: Colors.indigoAccent,
                                      fontWeight: FontWeight.w500)),
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Empty description!';
                                }
                                return value.contains('')
                                    ? 'Do not use the @ char.'
                                    : null;
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5, top: 15),
                            child: CircleAvatar(
                              backgroundColor: Colors.indigoAccent,
                              radius: 18,
                              child: IconButton(
                                icon: Icon(
                                  Icons.save,
                                  size: 22,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  final task = Task(
                                      taskName: _todoDescriptionFormController
                                          .value.text);
                                  if (task.taskName.isNotEmpty) {
                                    _tasksBlock.insertTask(task);

                                    Navigator.pop(context);
                                  }
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
