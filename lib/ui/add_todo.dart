import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:todo/controller/todo_controller.dart';

class AddTodoScreen extends StatelessWidget {
  TodoController _todoController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Todo"),
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                autofocus: false,
                controller: null,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                textInputAction: TextInputAction.done,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
                decoration: InputDecoration.collapsed(
                  hintText: 'Enter a title',
                  hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 26,
                      fontWeight: FontWeight.w700),
                  border: InputBorder.none,
                ),
              ),
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
                  Obx(() => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _todoController.dateTimeText.value,
                          style: GoogleFonts.nunito(
                              textStyle: TextStyle(fontSize: 18)),
                        ),
                      )),
                  InkWell(
                    onTap: () {
                      _selectDate(context);
                    },
                    child: Icon(
                      Icons.arrow_drop_down,
                      size: 24.0,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Obx(() => CircularPercentIndicator(
                        radius: 45.0,
                        lineWidth: 5.0,
                        percent: _todoController.progress.value,
                        center: Text(
                          "${(_todoController.progress.value * 100).toInt()}%",
                          textAlign: TextAlign.center,
                        ),
                        progressColor: Colors.green,
                      )),
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
                      _todoController.showAddCheckListWidget(true);
                    },
                  ),
                ],
              ),
            ),
            Obx(() => _addTodoWidget()),
            Expanded(
              child: Obx(
                () => ListView.builder(
                    itemCount: _todoController.checkLists.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: CheckboxListTile(
                                  title: Text(_todoController
                                      .checkLists[index].description),
                                  value: _todoController.checkLists[index].done,
                                  onChanged: (bool? value) {
                                    if (value != null)
                                      _todoController.updateCheckListStatus(
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
                                  _todoController.editCheckList(index);
                                },
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 4.0, right: 8.0),
                              child: InkWell(
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 24.0,
                                ),
                                onTap: () {
                                  _todoController.removeCheckList(index);
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _addTodoWidget() {
    return Visibility(
      visible: _todoController.isShowAddCheckListWidget.value,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Container(
          child: Row(
            children: [
              Checkbox(
                  value: _todoController.isAddItemChecked.value,
                  onChanged: (bool? value) {
                    if (value != null)
                      _todoController.isAddItemChecked.value = value;
                  }),
              Expanded(
                child: TextField(
                  controller: _todoController.inputCheckListController,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: 'Enter description',
                    errorText: _todoController.isAddItemValidate.value
                        ? null
                        : 'Value Can\'t Be Empty',
                  ),
                ),
              ),
              InkWell(
                child: Icon(
                  Icons.done,
                  color: Colors.green,
                  size: 24.0,
                ),
                onTap: () {
                  if (_todoController
                      .inputCheckListController.text.isNotEmpty) {
                    _todoController.saveCheckList();
                  } else {
                    _todoController.isAddItemValidate.value = false;
                  }
                },
              ),
              InkWell(
                child: Icon(
                  Icons.clear,
                  color: Colors.red,
                  size: 24.0,
                ),
                onTap: () {
                  _todoController.showAddCheckListWidget(false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _todoController.selectedDate != null
          ? _todoController.selectedDate!
          : DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    _todoController.setSelectedDate(picked);
    Get.back();
  }
}
