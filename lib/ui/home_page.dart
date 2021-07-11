import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todo/controller/auth_controller.dart';
import 'package:todo/controller/todo_controller.dart';
import 'package:get/get.dart';
import 'package:todo/ui/projects/components/project_info_card.dart';

import 'projects/add_project.dart';
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
        return ProjectInfoCard(
          title: _getProjectTitle(_todoController.projects[index].description),
          deadline: _todoController.projects[index].deadline ?? "----",
          progress: _todoController.projects[index].progress != null
              ? _todoController.projects[index].progress! / 100
              : 0.0,
          projectId: _todoController.projects[index].id!,
          onDeleteClicked: _todoController.deleteTodoById,
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
}
