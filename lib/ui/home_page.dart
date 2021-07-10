import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:todo/controller/auth_controller.dart';
import 'package:todo/controller/todo_controller.dart';
import 'package:get/get.dart';

import 'add_todo.dart';
import 'loading.dart';
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
    return Obx(() => _todoController.isLoading.value
        ? Loading()
        : Scaffold(
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
            body: _showProjects(context),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Get.to(() => AddTodoScreen());
              },
              tooltip: "Add Task",
              child: Icon(Icons.add),
            ),
          ));
  }

  Widget _showProjects(BuildContext context) {
    return GridView.builder(
      itemCount: _todoController.projects.length,
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_getProjectTitle(
                            _todoController.projects[index].description)),
                        GestureDetector(
                            onTapDown: (TapDownDetails details) {
                              _showPopupMenu(details, index);
                            },
                            child: Icon(Icons.more_vert)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: LinearPercentIndicator(
                      lineHeight: 4.0,
                      percent: _todoController.projects[index].progress != null
                          ? _todoController.projects[index].progress! / 100
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
                          Text(_todoController.projects[index].deadline ?? "",
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
      },
    );
  }

  @override
  void initState() {
    _todoController.getAllProjects();
    super.initState();
  }

  String _getProjectTitle(String originalText) {
    if (originalText.length > 15) return originalText.substring(0, 15) + "...";
    return originalText;
  }

  _showPopupMenu(TapDownDetails tapDownDetails, int index) async {
    final RenderObject? overlay =
        Overlay.of(context)?.context.findRenderObject();
    await showMenu(
      context: context,
      items: [
        PopupMenuItem(
          child: Text("Edit"),
        ),
        PopupMenuItem(
          child: InkWell(
              onTap: () {
                _todoController.deleteTodoById(index);
                Get.back();
              },
              child: Text("Delete")),
        ),
      ],
      elevation: 8.0,
      position: RelativeRect.fromRect(
          tapDownDetails.globalPosition & Size(40, 40), overlay!.paintBounds),
    );
  }
}
