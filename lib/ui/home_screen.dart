import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todo/controller/auth_controller.dart';
import 'package:todo/controller/todo_controller.dart';
import 'package:get/get.dart';
import 'package:todo/data/model/project.dart';
import 'package:todo/helpers/Constants.dart';
import 'package:todo/ui/projects/components/project_info_card.dart';
import 'package:todo/ui/projects/view_project.dart';

import 'projects/add_project.dart';
import 'loading.dart';
import 'login_ui.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
            body: RefreshIndicator(
                onRefresh: () async {
                  return _todoController.getAllProjects();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      image: _todoController.projects.length == 0
                          ? AssetImage("assets/images/no_items_found.jpeg")
                          : AssetImage("assets/images/home_background.png"),
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: GridView.builder(
                    itemCount: _todoController.projects.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 2.0,
                      mainAxisSpacing: 2.0,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height / 3),
                    ),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Get.to(() => ViewProject(
                              onUpdateClicked: updateWidget,
                              project: _todoController.projects[index]));
                        },
                        child: ProjectInfoCard(
                          project: _todoController.projects[index],
                          onDeleteClicked: _todoController.deleteTodoById,
                          onEditClicked: _onEditClicked,
                        ),
                      );
                    },
                  ),
                )),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Get.to(() => AddTodoScreen(),
                    arguments: {UPDATE_LISTENER: updateWidget});
              },
              tooltip: "Add Task",
              child: Icon(Icons.add),
            ),
          ));
  }

  @override
  void initState() {
    _todoController.getAllProjects();
    super.initState();
  }

  void _onEditClicked(Project project) {
    Get.to(() => AddTodoScreen(),
        arguments: {PROJECT: project, UPDATE_LISTENER: updateWidget});
  }

  void updateWidget() {
    _todoController.getAllProjects();
  }
}
