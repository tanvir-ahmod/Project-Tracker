import 'package:flutter/widgets.dart';
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

  TextEditingController inputCheckListController = TextEditingController();
  var isAddItemChecked = false.obs;
  var isAddItemValidate = true.obs;
  var editingIndex = -1;

  CheckList? editedCheckList;

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

  void insertTodo(String taskName) async {
    final response = await _todoRepository.insertTask(Task(taskName: taskName));
    Get.snackbar("Todo", response.responseMessage,
        snackPosition: SnackPosition.BOTTOM);
    getAllToDoItems();
    update();
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
  }

  removeCheckList(int index) {
    checkLists.removeAt(index);
    // checkLists.refresh();
  }

  updateCheckListStatus(int index, bool status) {
    checkLists[index].done = status;
    checkLists.refresh();
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
}
