import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:project_tracker/controller/auth_controller.dart';
import 'package:project_tracker/controller/project_controller.dart';
import 'package:get/get.dart';
import 'package:project_tracker/data/model/project.dart';
import 'package:project_tracker/helpers/Constants.dart';
import 'package:project_tracker/ui/profile/change_password.dart';
import 'package:project_tracker/ui/projects/components/project_info_card.dart';
import 'package:project_tracker/ui/projects/view_project.dart';

import 'projects/add_project.dart';
import 'loading.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthController _authController = Get.find();
  final ProjectController _projectController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() => _projectController.isLoading.value
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text("Home"),
              actions: [
                PopupMenuButton<String>(
                  onSelected: (value) {
                    _handleMenuClick(value);
                  },
                  itemBuilder: (BuildContext context) {
                    return {CHANGE_PASSWORD, LOGOUT}.map((String choice) {
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
                  return _projectController.getAllProjects();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      image: _projectController.projects.length == 0
                          ? AssetImage("assets/images/no_items_found.jpeg")
                          : AssetImage("assets/images/home_background.png"),
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: GridView.builder(
                    itemCount: _projectController.projects.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 2.0,
                      mainAxisSpacing: 2.0,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height / 1.85),
                    ),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Get.to(() => ViewProject(
                              onUpdateClicked: _updateWidget,
                              project: _projectController.projects[index]));
                        },
                        child: ProjectInfoCard(
                          project: _projectController.projects[index],
                          onDeleteClicked: _projectController.deleteProjectById,
                          onEditClicked: _onEditClicked,
                          onActiveInactiveClicked: _updateProjectStatus,
                        ),
                      );
                    },
                  ),
                )),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Get.to(() => AddProject(),
                    arguments: {UPDATE_LISTENER: _updateWidget});
              },
              tooltip: "Add Task",
              child: Icon(Icons.add),
            ),
          ));
  }

  @override
  void initState() {
    _projectController.getAllProjects();
    super.initState();
  }

  void _onEditClicked(Project project) {
    Get.to(() => AddProject(),
        arguments: {PROJECT: project, UPDATE_LISTENER: _updateWidget});
  }

  void _updateWidget() {
    _projectController.getAllProjects();
  }

  void _handleMenuClick(String value) {
    switch (value) {
      case LOGOUT:
        _authController.logout();
        break;
      case CHANGE_PASSWORD:
        Get.to(() => ChangePasswordScreen());
        break;
    }
  }

  void _updateProjectStatus(int projectId, bool status) {
    _projectController.updateProjectStatus(projectId, status,
        onUpdate: _updateWidget);
  }
}
