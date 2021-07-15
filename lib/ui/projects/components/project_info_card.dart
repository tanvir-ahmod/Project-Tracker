import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:todo/data/model/project.dart';

typedef OnEditClicked = void Function(Project project);

class ProjectInfoCard extends StatelessWidget {
  final Function? onDeleteClicked;
  final OnEditClicked? onEditClicked;

  final Project project;

  ProjectInfoCard(
      {required this.project, this.onDeleteClicked, this.onEditClicked});

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
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: LinearPercentIndicator(
                  lineHeight: 4.0,
                  percent:
                      project.progress != null ? project.progress! / 100 : 0.0,
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
                      Text(project.deadline ?? "----"),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _showPopupMenu(TapDownDetails tapDownDetails, BuildContext context) async {
    final RenderObject? overlay =
        Overlay.of(context)?.context.findRenderObject();
    var selected = await showMenu(
      context: context,
      items: [
        PopupMenuItem(
          child: Text("Edit"),
          value: 1,
        ),
        PopupMenuItem(
          child: Text("Delete"),
          value: 2,
        ),
      ],
      elevation: 8.0,
      position: RelativeRect.fromRect(
          tapDownDetails.globalPosition & Size(40, 40), overlay!.paintBounds),
    );

    if (selected == 1) {
      if (onEditClicked != null) onEditClicked!(project);
    } else
      _showConfirmationDialog();
  }

  String _getProjectTitle(String originalText) {
    if (originalText.length > 15) return originalText.substring(0, 15) + "...";
    return originalText;
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
            if (onDeleteClicked != null) onDeleteClicked!(project.id!);
            Get.back();
          },
          child: Text(
            "Confirm",
            style: TextStyle(color: Colors.red),
          ),
        ));
  }
}
