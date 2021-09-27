import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:project_tracker/data/model/project.dart';

typedef OnEditClicked = void Function(Project project);

class ProjectInfoCard extends StatelessWidget {
  final Function? onDeleteClicked;
  final OnEditClicked? onEditClicked;
  final Function? onActiveInactiveClicked;
  final String? deleteMessage;
  final String? deleteText;

  final Project project;

  ProjectInfoCard(
      {required this.project,
      this.onDeleteClicked,
      this.onEditClicked,
      this.deleteMessage,
      this.deleteText,
      this.onActiveInactiveClicked});

  @override
  Widget build(BuildContext context) {
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
                    Text(_getProjectTitle(project.description)),
                    Visibility(
                      visible: onDeleteClicked != null || onEditClicked != null,
                      child: GestureDetector(
                          onTapDown: (TapDownDetails details) {
                            _showPopupMenu(details, context);
                          },
                          child: Icon(Icons.more_vert)),
                    ),
                  ],
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: CircularPercentIndicator(
                    lineWidth: 4.0,
                    center: Text(
                      "${project.progress != null ? project.progress : 0}%",
                      textAlign: TextAlign.center,
                    ),
                    percent: project.progress != null
                        ? project.progress! / 100
                        : 0.0,
                    backgroundColor: Colors.grey,
                    progressColor: Colors.green,
                    radius: 60,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Status"),
                    Container(
                      width: 10.0,
                      height: 10.0,
                      decoration: new BoxDecoration(
                        color: (project.isActive != null && project.isActive!)
                            ? Colors.green
                            : Colors.red,
                        shape: BoxShape.circle,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Deadline",
                        style: Theme.of(context).textTheme.caption!),
                    Text(project.deadline ?? "----"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _showPopupMenu(TapDownDetails tapDownDetails, BuildContext context) async {
    final RenderObject? overlay =
        Overlay.of(context)?.context.findRenderObject();
    var activeInactiveText = "Active";
    var activeInactiveTextColor = Colors.green;
    var projectStatus = true;
    if (project.isActive != null && project.isActive!) {
      activeInactiveText = "Inactive";
      activeInactiveTextColor = Colors.red;
      projectStatus = false;
    }
    var selected = await showMenu(
      context: context,
      items: [
        if (onActiveInactiveClicked != null)
          PopupMenuItem(
            child: Text(
              activeInactiveText,
              style: TextStyle(color: activeInactiveTextColor),
            ),
            value: 3,
          ),
        PopupMenuItem(
          child: Text("Edit"),
          value: 1,
        ),
        PopupMenuItem(
          child: Text(deleteText ?? "Delete"),
          value: 2,
        ),
      ],
      elevation: 8.0,
      position: RelativeRect.fromRect(
          tapDownDetails.globalPosition & Size(40, 40), overlay!.paintBounds),
    );

    if (selected == 1) {
      if (onEditClicked != null) onEditClicked!(project);
    } else if (selected == 2) {
      final title = deleteText ?? "Delete";
      final bodyText = deleteMessage ?? "Do you want to delete this data?";
      _showConfirmationDialog(title, bodyText, onDeleteClicked);
    } else if (selected == 3) {
      final bodyText = "Do you want to $activeInactiveText this data?";
      _showConfirmationDialog(
          activeInactiveText, bodyText, onActiveInactiveClicked,
          status: projectStatus);
    }
  }

  String _getProjectTitle(String originalText) {
    if (originalText.length > 15) return originalText.substring(0, 15) + "...";
    return originalText;
  }

  void _showConfirmationDialog(
      String title, String message, Function? onConfirmClicked,
      {bool? status}) {
    Get.defaultDialog(
        title: title,
        middleText: message,
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
            if (status != null)
              onConfirmClicked?.call(project.id!, status);
            else
              onConfirmClicked?.call(project.id!);
            Get.back();
          },
          child: Text(
            "Confirm",
            style: TextStyle(color: Colors.red),
          ),
        ));
  }
}
