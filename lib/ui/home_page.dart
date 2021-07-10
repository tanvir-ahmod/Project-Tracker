import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:todo/controller/auth_controller.dart';
import 'package:todo/controller/todo_controller.dart';
import 'package:get/get.dart';

import 'add_todo.dart';
import 'login_ui.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final AuthController _authController = Get.find();

  final TodoController _todoController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              _authController.logout();
              Future.delayed(const Duration(milliseconds: 1500), () {
                Get.offAll(() => LoginScreen());
              });
            },
            itemBuilder: (BuildContext context) {
              return {"Logout"}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: _buildTaskList(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddTodoScreen());
        },
        tooltip: "Add Task",
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskList(BuildContext context) {
    return GetBuilder<TodoController>(
      builder: (_dx) => GridView.builder(
          itemCount: _dx.totoItems.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 2.0,
            mainAxisSpacing: 2.0,
            childAspectRatio: MediaQuery.of(context).size.width /
                (MediaQuery.of(context).size.height / 3),
          ),
          itemBuilder: (context, index) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(_dx.totoItems[index].description),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: LinearPercentIndicator(
                          lineHeight: 4.0,
                          percent: _dx.totoItems[index].progress != null
                              ? _dx.totoItems[index].progress! / 100
                              : 0.0,
                          backgroundColor: Colors.grey,
                          progressColor: Colors.green,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Deadline",
                                  style: Theme.of(context).textTheme.caption!),
                              Text(_dx.totoItems[index].deadline ?? "",
                                  style: Theme.of(context).textTheme.caption!),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  @override
  void initState() {
    _todoController.getAllProjects();
    super.initState();
  }
}
