import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:todo/data/model/project.dart';

class ProjectInfoCard extends StatelessWidget {
  final Function onDeleteClicked;

  final Project project;

  ProjectInfoCard({required this.project, required this.onDeleteClicked});

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
                    GestureDetector(
                        onTapDown: (TapDownDetails details) {
                          _showPopupMenu(details, context);
                        },
                        child: Icon(Icons.more_vert)),
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
    await showMenu(
      context: context,
      items: [
        PopupMenuItem(
          child: Text("Edit"),
        ),
        PopupMenuItem(
          child: InkWell(
              onTap: () {
                onDeleteClicked(project.id);
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

  String _getProjectTitle(String originalText) {
    if (originalText.length > 15) return originalText.substring(0, 15) + "...";
    return originalText;
  }
}
