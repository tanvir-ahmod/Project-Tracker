import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:todo/controller/todo_controller.dart';
import 'package:todo/controller/view_projects_controller.dart';
import 'package:todo/data/model/project.dart';
import 'package:todo/ui/projects/components/project_info_card.dart';

import '../loading.dart';
import 'add_project.dart';

class ViewProject extends StatefulWidget {
  @override
  _ViewProjectState createState() => _ViewProjectState();
}

class _ViewProjectState extends State<ViewProject> {
  final ViewProjectController _viewProjectController = Get.find();
  final TodoController _todoController = Get.find();

  @override
  void initState() {
    final project = Get.arguments as Project;
    _viewProjectController.setProject(project);
    if (project.id != null)
      _viewProjectController.getSubProjectsById(project.id!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => _todoController.isLoading.value
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text("View project"),
              actions: [
                Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: GestureDetector(
                      onTap: () =>
                          _onEditClicked(_viewProjectController.project.value),
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
                        _viewProjectController.project.value.description,
                        style: TextStyle(
                            fontSize: 26, fontWeight: FontWeight.w700)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.date_range_rounded,
                          color: Colors.deepPurpleAccent,
                          size: 45,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 4.0),
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
                            _viewProjectController.project.value.deadline ??
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
                                            .project.value.progress !=
                                        null
                                    ? _viewProjectController
                                            .project.value.progress! /
                                        100
                                    : 0.0,
                                center: Text(
                                  "${_viewProjectController.project.value.progress != null ? _viewProjectController.project.value.progress!.toInt() : 0}%",
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
                            .project.value.checkLists.length !=
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
                                padding:
                                    const EdgeInsets.only(left: 8.0, top: 4.0),
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
                              itemCount: _viewProjectController
                                  .project.value.checkLists.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: CheckboxListTile(
                                      title: Text(_viewProjectController.project
                                          .value.checkLists[index].description),
                                      value: _viewProjectController
                                          .project.value.checkLists[index].done,
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
                                          textStyle: TextStyle(fontSize: 18)),
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
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: 150,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: _viewProjectController
                                        .subProjects.length,
                                    itemBuilder: (context, index) {
                                      return SizedBox(
                                        height: 40,
                                        width: 200,
                                        child: InkWell(
                                          onTap: () {
                                            Get.delete<ViewProjectController>();
                                            Get.to(ViewProject(),
                                                arguments:
                                                    _viewProjectController
                                                        .subProjects[index]);
                                          },
                                          child: ProjectInfoCard(
                                            project: _viewProjectController
                                                .subProjects[index],
                                            onDeleteClicked: _removeSubItem,
                                            onEditClicked: _onEditClicked,
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            )));
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
            Get.back(closeOverlays: true);
          },
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.black),
          ),
        ),
        confirm: TextButton(
          onPressed: () {
            _todoController
                .deleteTodoById(_viewProjectController.project.value.id!)
                .then((isDelete) {
              if (isDelete) {
                Future.delayed(Duration(microseconds: 500), () {
                  Get.back(closeOverlays: true);
                });
              }
            });
            Get.back(closeOverlays: true);
          },
          child: Text(
            "Confirm",
            style: TextStyle(color: Colors.red),
          ),
        ));
  }

  void _onEditClicked(Project project) {
    Get.to(() => AddTodoScreen(), arguments: project);
  }

  void _removeSubItem(int projectId) {
    _viewProjectController.removeSubItem(projectId);
  }

  void _showSubProjectAddDialog() async {
    await _viewProjectController.showSubProjectsToAdd();
    Get.defaultDialog(
        title: "Click to as sub project",
        content: Container(
          height: 300.0, // Change as per your requirement
          width: 300.0, // Change as per your requirement
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _viewProjectController.subProjectsToAdd.length,
            itemBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 150.0, // Change as per your requirement
                width: 100.0,
                child: InkWell(
                  onTap: () async {
                    await _viewProjectController.setAsSubProject(
                        _viewProjectController.subProjectsToAdd[index]);
                    Get.back();
                  },
                  child: ProjectInfoCard(
                      project: _viewProjectController.subProjectsToAdd[index]),
                ),
              );
            },
          ),
        ));
  }
}
