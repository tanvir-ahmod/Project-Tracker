import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:project_tracker/controller/project_controller.dart';
import 'package:project_tracker/data/model/project.dart';
import 'package:project_tracker/helpers/Constants.dart';
import 'package:project_tracker/ui/loading.dart';

class AddProject extends StatelessWidget {
  final ProjectController _projectController = Get.put(ProjectController());

  final Project? project =
      Get.arguments != null ? Get.arguments[PROJECT] : null;
  final int? parentId = Get.arguments != null ? Get.arguments[PARENT_ID] : null;

  final Function? updateWidget =
      Get.arguments != null ? Get.arguments[UPDATE_LISTENER] : null;

  @override
  Widget build(BuildContext context) {
    _projectController.clearCache();
    _projectController.setProjectToEdit(project, parentId);
    _projectController.setOnUpdateClick(updateWidget);
    return Obx(() => _projectController.isLoading.value
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text(_projectController.isEditable.value
                  ? "Edit Project"
                  : "Add Project"),
              actions: [
                Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        if (_projectController
                            .titleController.text.isNotEmpty) {
                          _projectController.isTitleValidated.value = true;
                          _projectController.addOrModifyProject();
                        } else
                          _projectController.isTitleValidated.value = false;
                      },
                      child: Icon(
                        Icons.done,
                        size: 26.0,
                      ),
                    )),
              ],
            ),
            body: Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: _projectController.titleController,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.done,
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
                      decoration: InputDecoration(
                        hintText: 'Enter a title',
                        hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 26,
                            fontWeight: FontWeight.w700),
                        border: InputBorder.none,
                        errorText: _projectController.isTitleValidated.value
                            ? null
                            : 'Value Can\'t Be Empty',
                      ),
                    ),
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
                            _projectController.dateTimeText.value,
                            style: GoogleFonts.nunito(
                                textStyle: TextStyle(fontSize: 18)),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _selectDate(context);
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          child: Icon(
                            Icons.arrow_drop_down,
                            size: 24.0,
                          ),
                        ),
                        Visibility(
                          visible:
                              _projectController.showDateTimeRemoveIcon.value,
                          child: InkWell(
                            onTap: () {
                              _projectController.clearSelectedDate();
                            },
                            child: Icon(
                              Icons.clear,
                              size: 24.0,
                              color: Colors.red,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        CircularPercentIndicator(
                          radius: 45.0,
                          lineWidth: 5.0,
                          percent: _projectController.progress.value,
                          center: Text(
                            "${(_projectController.progress.value * 100).toInt()}%",
                            textAlign: TextAlign.center,
                          ),
                          progressColor: Colors.green,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                          child: Text(
                            "CheckLists",
                            style: GoogleFonts.nunito(
                                textStyle: TextStyle(fontSize: 18)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Spacer(),
                        InkWell(
                          child: Icon(
                            Icons.add,
                            color: Colors.green,
                            size: 24.0,
                          ),
                          onTap: () {
                            _projectController.showAddCheckListWidget(true);
                          },
                        ),
                      ],
                    ),
                  ),
                  _addChecklistWidget(),
                  Expanded(
                    child: ListView.builder(
                        itemCount: _projectController.checkLists.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: CheckboxListTile(
                                      title: Text(_projectController
                                          .checkLists[index].description),
                                      value: _projectController
                                          .checkLists[index].done,
                                      onChanged: (bool? value) {
                                        if (value != null)
                                          _projectController
                                              .updateCheckListStatus(
                                                  index, value);
                                      },
                                      activeColor: Colors.green,
                                      controlAffinity:
                                          ListTileControlAffinity.leading),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: InkWell(
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.green,
                                      size: 24.0,
                                    ),
                                    onTap: () {
                                      _projectController.editCheckList(index);
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 4.0, right: 8.0),
                                  child: InkWell(
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: 24.0,
                                    ),
                                    onTap: () {
                                      _projectController.removeCheckList(index);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          ));
  }

  Widget _addChecklistWidget() {
    return Visibility(
      visible: _projectController.isShowAddCheckListWidget.value,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Checkbox(
                  value: _projectController.isAddItemChecked.value,
                  onChanged: (bool? value) {
                    if (value != null)
                      _projectController.isAddItemChecked.value = value;
                  }),
            ),
            Expanded(
              child: TextField(
                controller: _projectController.inputCheckListController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: 'Enter description',
                  errorText: _projectController.isAddItemValidate.value
                      ? null
                      : 'Value Can\'t Be Empty',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: InkWell(
                child: Icon(
                  Icons.done,
                  color: Colors.green,
                  size: 24.0,
                ),
                onTap: () {
                  if (_projectController
                      .inputCheckListController.text.isNotEmpty) {
                    _projectController.saveCheckList();
                    FocusManager.instance.primaryFocus?.unfocus();
                  } else {
                    _projectController.isAddItemValidate.value = false;
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: InkWell(
                child: Icon(
                  Icons.clear,
                  color: Colors.red,
                  size: 24.0,
                ),
                onTap: () {
                  _projectController.showAddCheckListWidget(false);
                  FocusManager.instance.primaryFocus?.unfocus();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _projectController.selectedDate != null
          ? _projectController.selectedDate!
          : DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    _projectController.setSelectedDate(picked);
  }
}
