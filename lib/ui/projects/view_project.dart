import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:project_tracker/controller/project_controller.dart';
import 'package:project_tracker/controller/view_projects_controller.dart';
import 'package:project_tracker/data/model/project.dart';
import 'package:project_tracker/helpers/Constants.dart';
import 'package:project_tracker/ui/projects/components/project_info_card.dart';

import '../loading.dart';
import 'add_project.dart';

class ViewProject extends StatefulWidget {
  final Function? onUpdateClicked;
  final Project? project;

  const ViewProject({Key? key, this.onUpdateClicked, this.project})
      : super(key: key);

  @override
  _ViewProjectState createState() =>
      _ViewProjectState(onUpdateClicked, project);
}

class _ViewProjectState extends State<ViewProject> {
  final ViewProjectController _viewProjectController = Get.find();
  final ProjectController _projectController = Get.find();
  final Project? project;
  final Function? onUpdateClicked;

  _ViewProjectState(this.onUpdateClicked, this.project);

  @override
  void initState() {
    if (project != null) {
      _viewProjectController.setProject(project!);
      _viewProjectController.setOnUpdateClick(onUpdateClicked);
      _projectController.setOnUpdateClick(onUpdateClicked);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => _viewProjectController.isLoading.value
        ? Loading()
        : RefreshIndicator(
            onRefresh: () {
              return _viewProjectController.updateCurrentProject();
            },
            child: Scaffold(
                appBar: AppBar(
                  title: Text("View project"),
                  actions: [
                    Padding(
                        padding: EdgeInsets.only(right: 20.0),
                        child: GestureDetector(
                          onTap: () => _onEditClicked(
                              _viewProjectController.currentProject.value),
                          child: Icon(
                            Icons.edit,
                            size: 26.0,
                          ),
                        )),
                    Padding(
                        padding: EdgeInsets.only(right: 20.0),
                        child: GestureDetector(
                          onTap: () => _showConfirmationDialog(),
                          child: Icon(
                            Icons.delete,
                            size: 26.0,
                          ),
                        )),
                  ],
                ),
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            _viewProjectController
                                .currentProject.value.description,
                            style: TextStyle(
                                fontSize: 26, fontWeight: FontWeight.w700)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.date_range_rounded,
                              color: Colors.blue[800],
                              size: 45,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, top: 4.0),
                              child: Text(
                                "Deadline",
                                style: GoogleFonts.nunito(
                                    textStyle: TextStyle(fontSize: 18)),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _viewProjectController
                                        .currentProject.value.deadline ??
                                    "----",
                                style: GoogleFonts.nunito(
                                    textStyle: TextStyle(fontSize: 18)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Divider(
                          height: 10,
                          thickness: 2,
                          indent: 20,
                          endIndent: 20,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Overall progress",
                                    style: GoogleFonts.nunito(
                                        textStyle: TextStyle(fontSize: 18)),
                                    textAlign: TextAlign.center),
                                Center(
                                  child: CircularPercentIndicator(
                                    radius: 200.0,
                                    lineWidth: 5.0,
                                    percent: _viewProjectController
                                                .currentProject
                                                .value
                                                .progress !=
                                            null
                                        ? _viewProjectController.currentProject
                                                .value.progress! /
                                            100
                                        : 0.0,
                                    center: Text(
                                      "${_viewProjectController.currentProject.value.progress != null ? _viewProjectController.currentProject.value.progress : 0}%",
                                      textAlign: TextAlign.center,
                                    ),
                                    progressColor: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _viewProjectController
                                .currentProject.value.checkLists.length !=
                            0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Divider(
                                height: 10,
                                thickness: 2,
                                indent: 20,
                                endIndent: 20,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  CircularPercentIndicator(
                                    radius: 45.0,
                                    lineWidth: 5.0,
                                    percent: _viewProjectController
                                        .checkListProgress.value,
                                    center: Text(
                                      "${(_viewProjectController.checkListProgress.value * 100).toInt()}%",
                                      textAlign: TextAlign.center,
                                    ),
                                    progressColor: Colors.green,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, top: 4.0),
                                    child: Text(
                                      "CheckLists",
                                      style: GoogleFonts.nunito(
                                          textStyle: TextStyle(fontSize: 18)),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: _viewProjectController
                                      .currentProject.value.checkLists.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: CheckboxListTile(
                                          title: Text(_viewProjectController
                                              .currentProject
                                              .value
                                              .checkLists[index]
                                              .description),
                                          value: _viewProjectController
                                              .currentProject
                                              .value
                                              .checkLists[index]
                                              .done,
                                          onChanged: (bool? value) {},
                                          activeColor: Colors.green,
                                          controlAffinity:
                                              ListTileControlAffinity.leading),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                      _viewProjectController.isParentProjectsLoading.value
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Divider(
                                  height: 10,
                                  thickness: 2,
                                  indent: 20,
                                  endIndent: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Parent projects",
                                          style: GoogleFonts.nunito(
                                              textStyle:
                                                  TextStyle(fontSize: 18)),
                                          textAlign: TextAlign.center),
                                      TextButton(
                                          onPressed: () {
                                            _showParentProjectAddDialog();
                                          },
                                          child: Text("+Add new"))
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: _viewProjectController
                                      .isParentProjectsLoading.value,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                                _viewProjectController.parentProjects.length ==
                                        0
                                    ? Container(
                                        alignment: Alignment.center,
                                        child: Image.asset(
                                          'assets/images/no_sub_item.png',
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                          height: 220,
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: _viewProjectController
                                                  .parentProjects.length,
                                              itemBuilder: (context, index) {
                                                return InkWell(
                                                  onTap: () {
                                                    Get.delete<
                                                        ViewProjectController>();

                                                    // Get.to() not working for multiple click
                                                    navigator!.push(
                                                      MaterialPageRoute(
                                                        builder: (_) {
                                                          return ViewProject(
                                                            onUpdateClicked:
                                                                _viewProjectController
                                                                    .updateCurrentProject,
                                                            project:
                                                                _viewProjectController
                                                                        .parentProjects[
                                                                    index],
                                                          );
                                                        },
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2.5,
                                                    child: ProjectInfoCard(
                                                        project:
                                                            _viewProjectController
                                                                    .parentProjects[
                                                                index],
                                                        onDeleteClicked:
                                                            _removeParentItem,
                                                        onEditClicked:
                                                            _onEditClicked,
                                                        deleteMessage:
                                                            "Do you want to remove it from parent project?",
                                                        deleteText: "Remove",
                                                        onActiveInactiveClicked:
                                                            _updateProjectStatus),
                                                  ),
                                                );
                                              }),
                                        ),
                                      ),
                              ],
                            ),
                      _viewProjectController.isLoading.value
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Divider(
                                  height: 10,
                                  thickness: 2,
                                  indent: 20,
                                  endIndent: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Dependent projects",
                                          style: GoogleFonts.nunito(
                                              textStyle:
                                                  TextStyle(fontSize: 18)),
                                          textAlign: TextAlign.center),
                                      TextButton(
                                          onPressed: () {
                                            _showSubProjectAddDialog();
                                          },
                                          child: Text("+Add new"))
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: _viewProjectController
                                      .isSubProjectsToAddLoading.value,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                                _viewProjectController.subProjects.length == 0
                                    ? Container(
                                        alignment: Alignment.center,
                                        child: Image.asset(
                                          'assets/images/no_sub_item.png',
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                          height: 220,
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: _viewProjectController
                                                  .subProjects.length,
                                              itemBuilder: (context, index) {
                                                return InkWell(
                                                  onTap: () {
                                                    Get.delete<
                                                        ViewProjectController>();

                                                    // Get.to() not working for multiple click
                                                    navigator!.push(
                                                      MaterialPageRoute(
                                                        builder: (_) {
                                                          return ViewProject(
                                                            onUpdateClicked:
                                                                _viewProjectController
                                                                    .updateCurrentProject,
                                                            project:
                                                                _viewProjectController
                                                                        .subProjects[
                                                                    index],
                                                          );
                                                        },
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2.5,
                                                    child: ProjectInfoCard(
                                                        project: _viewProjectController
                                                                .subProjects[
                                                            index],
                                                        onDeleteClicked:
                                                            _removeSubItem,
                                                        onEditClicked:
                                                            _onEditClicked,
                                                        deleteMessage:
                                                            "Do you want to remove it from sub project?",
                                                        deleteText: "Remove",
                                                        onActiveInactiveClicked:
                                                        _updateProjectStatus),
                                                  ),
                                                );
                                              }),
                                        ),
                                      ),
                              ],
                            ),
                    ],
                  ),
                )),
          ));
  }

  void _showConfirmationDialog() {
    Get.defaultDialog(
        title: "Delete",
        middleText: "Do you want to delete this data?",
        textConfirm: "Confirm",
        cancelTextColor: Colors.black,
        confirmTextColor: Colors.red,
        barrierDismissible: false,
        radius: 20,
        cancel: TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.black),
          ),
        ),
        confirm: TextButton(
          onPressed: () {
            _projectController.deleteProjectById(
                _viewProjectController.currentProject.value.id!,
                isPopup: true);
          },
          child: Text(
            "Confirm",
            style: TextStyle(color: Colors.red),
          ),
        ));
  }

  void _onEditClicked(Project project) {
    Get.to(() => AddProject(), arguments: {
      PROJECT: project,
      UPDATE_LISTENER: _viewProjectController.updateCurrentProject
    });
  }

  void _removeSubItem(int subProjectId) {
    _viewProjectController.removeSubItem(subProjectId);
  }

  void _removeParentItem(int parentId) {
    _viewProjectController.removeParentItem(parentId);
  }

  void _updateProjectStatus(int projectId, bool status) {
    _projectController.updateProjectStatus(projectId, status,
        onUpdate: _viewProjectController.updateCurrentProject);
  }

  void _showParentProjectAddDialog() async {
    await _viewProjectController.showParentProjectsToAdd();
    if (_viewProjectController.parentProjectsToAdd.isEmpty) {
      Fluttertoast.showToast(
          msg: "No parent project to add", toastLength: Toast.LENGTH_LONG);
      return;
    }
    Get.defaultDialog(
        title: "Click to set as parent project",
        content: Container(
          height: 300.0,
          width: 300.0,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _viewProjectController.parentProjectsToAdd.length,
            itemBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: (MediaQuery.of(context).size.height / 3.5),
                width: 100.0,
                child: InkWell(
                  onTap: () async {
                    await _viewProjectController.setAsParentProject(
                        _viewProjectController.parentProjectsToAdd[index]);
                    Get.back();
                  },
                  child: ProjectInfoCard(
                      project:
                          _viewProjectController.parentProjectsToAdd[index]),
                ),
              );
            },
          ),
        ));
  }

  void _showSubProjectAddDialog() async {
    await _viewProjectController.showSubProjectsToAdd();
    if (_viewProjectController.subProjectsToAdd.isEmpty) {
      _viewProjectController
          .gotoAddToDoPage(_viewProjectController.updateCurrentProject);
      return;
    }
    Get.defaultDialog(
        title: "Click to set as sub project",
        content: Column(
          children: [
            Center(
              child: TextButton(
                  onPressed: () async {
                    _viewProjectController.gotoAddToDoPage(
                        _viewProjectController.updateCurrentProject);
                  },
                  child: Text("+Add new")),
            ),
            Container(
              width: 300,
              height: 300,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _viewProjectController.subProjectsToAdd.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () async {
                      await _viewProjectController.setAsSubProject(
                          _viewProjectController.subProjectsToAdd[index]);
                      Get.back();
                    },
                    child: SizedBox(
                      height: (MediaQuery.of(context).size.height / 3.5),
                      width: 300,
                      child: ProjectInfoCard(
                          project:
                              _viewProjectController.subProjectsToAdd[index]),
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }
}
