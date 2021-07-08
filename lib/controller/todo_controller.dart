import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:todo/data/model/Task.dart';
import 'package:todo/data/model/request/add_todo_request.dart';
import 'package:todo/data/repositories/todo/todo_repository.dart';
import 'package:get/get.dart';

class TodoController extends GetxController {
  var isLoading = false.obs;
  TodoRepository _todoRepository = Get.find();

  List<Task> totoItems = <Task>[].obs;
  final checkLists = <CheckList>[].obs;

  var isShowAddCheckListWidget = false.obs;

  TextEditingController titleController = TextEditingController();
  var isTitleValidated = true.obs;
  TextEditingController inputCheckListController = TextEditingController();
  var isAddItemChecked = false.obs;
  var isAddItemValidate = true.obs;
  var editingIndex = -1;
  var progress = 0.0.obs;

  CheckList? editedCheckList;
  DateTime? selectedDate;
  var dateTimeText = "----".obs;

  @override
  void onReady() {
    super.onReady();
    // getAllToDoItems();
  }

  void getAllToDoItems() async {
    isLoading.value = true;
    var response = await _todoRepository.fetchAllTasks();
    totoItems = response;
    update();
  }

  void insertTodo() async {
    String deadline = selectedDate != null
        ? DateFormat('yyyyMMdd').format(selectedDate!)
        : "";

    AddTodoRequest addTodoRequest = new AddTodoRequest(
        checkLists: checkLists.toList(),
        deadline: deadline,
        description: titleController.text);
    isLoading.value = true;
    try {
      final response = await _todoRepository.insertTask(addTodoRequest);
      isLoading.value = false;
      Get.snackbar("Todo", response.responseMessage,
          snackPosition: SnackPosition.BOTTOM);
    } on DioError {
      isLoading.value = false;
    }
    Future.delayed(const Duration(milliseconds: 1000), () {
      Get.back(closeOverlays: true);
      Get.delete<TodoController>();
    });

    // getAllToDoItems();
    // update();
  }

  void deleteTodoById(int id) async {
    final response = await _todoRepository.deleteRowByID(id);
    Get.snackbar("Todo", response.responseMessage,
        snackPosition: SnackPosition.BOTTOM);
    getAllToDoItems();
    update();
  }

  saveCheckList() {
    if (editedCheckList != null) {
      checkLists.insert(editingIndex, editedCheckList!);
      checkLists[editingIndex].description = inputCheckListController.text;
      checkLists[editingIndex].done = isAddItemChecked.value;
      checkLists.refresh();
    } else {
      checkLists.add(CheckList(
          description: inputCheckListController.text,
          done: isAddItemChecked.value));
    }
    showAddCheckListWidget(false);
    clearCheckListInputController();
    updateProgress();
  }

  removeCheckList(int index) {
    checkLists.removeAt(index);
    updateProgress();
  }

  updateCheckListStatus(int index, bool status) {
    checkLists[index].done = status;
    checkLists.refresh();
    updateProgress();
  }

  showAddCheckListWidget(bool isShow) {
    isShowAddCheckListWidget.value = isShow;
    if (!isShow) {
      clearCheckListInputController();
      isAddItemValidate.value = true;
      isAddItemChecked.value = false;
      editingIndex = -1;
      editedCheckList = null;
    }
  }

  clearCheckListInputController() {
    inputCheckListController.text = "";
  }

  editCheckList(int index) {
    editingIndex = index;
    inputCheckListController.text = checkLists[index].description;
    isAddItemChecked.value = checkLists[index].done;
    editedCheckList = checkLists[index];
    removeCheckList(index);
    showAddCheckListWidget(true);
  }

  updateProgress() {
    var totalTasks = checkLists.length;
    var completedTasks = checkLists.where((i) => i.done).length;
    if (totalTasks == 0 || completedTasks == 0)
      progress.value = 0.0;
    else
      progress.value = completedTasks / totalTasks;
  }

  setSelectedDate(DateTime? dateTime) {
    selectedDate = dateTime;

    dateTimeText.value = selectedDate != null
        ? DateFormat('yyyy-MM-dd').format(selectedDate!)
        : "----";
  }
}
