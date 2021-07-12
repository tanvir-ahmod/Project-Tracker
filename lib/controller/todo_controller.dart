import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:todo/data/model/project.dart';
import 'package:todo/data/repositories/todo/todo_repository.dart';
import 'package:get/get.dart';

class TodoController extends GetxController {
  var isLoading = false.obs;
  TodoRepository _todoRepository = Get.find();

  var projects = <Project>[].obs;
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
  var showDateTimeRemoveIcon = false.obs;
  var isEditable = false.obs;

  var project = Project(checkLists: [], deadline: null, description: "").obs;

  void getAllProjects() async {
    isLoading.value = true;
    var response = await _todoRepository.fetchAllProjects();
    projects.assignAll(response);
    isLoading.value = false;
  }

  void addOrModifyProject() async {
    String deadline = selectedDate != null
        ? DateFormat('yyyy-MM-dd').format(selectedDate!)
        : "";
    late Project tempProject;
    if (isEditable.value) {
      tempProject = project.value;
      tempProject.checkLists.assignAll(checkLists);
      tempProject.deadline = deadline;
      tempProject.description = titleController.text;
    } else {
      tempProject = new Project(
          checkLists: checkLists.toList(),
          deadline: deadline,
          description: titleController.text);
    }
    isLoading.value = true;
    try {
      final response = isEditable.value
          ? await _todoRepository.updateProject(tempProject)
          : await _todoRepository.addProject(tempProject);
      isLoading.value = false;
      Get.snackbar("Todo", response.responseMessage,
          snackPosition: SnackPosition.BOTTOM);
    } on DioError {
      isLoading.value = false;
    }
    Future.delayed(const Duration(milliseconds: 500), () {
      Get.back(closeOverlays: true);
    });
    getAllProjects();
    update();
  }

  Future<bool> deleteTodoById(int id) async {
    isLoading.value = true;
    final response = await _todoRepository.deleteRowByID(id);
    isLoading.value = false;
    Get.snackbar("Todo", response.responseMessage,
        snackPosition: SnackPosition.BOTTOM);
    Project project = projects.where((p) => p.id == id).first;
    projects.removeAt(projects.indexOf(project));
    projects.refresh();
    return true;
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

    if (selectedDate != null) {
      dateTimeText.value = DateFormat('yyyy-MM-dd').format(selectedDate!);
      showDateTimeRemoveIcon.value = true;
    }
  }

  clearSelectedDate() {
    selectedDate = null;
    dateTimeText.value = "----";
    showDateTimeRemoveIcon.value = false;
  }

  clearCache() {
    titleController.text = "";
    checkLists.clear();
    clearSelectedDate();
    progress.value = 0.0;
    isEditable.value = false;
  }

  setProjectToEdit(Project? project) {
    if (project != null) {
      isEditable.value = true;
      this.project.value = project;
      this.checkLists.assignAll(project.checkLists);
      titleController.text = project.description;
      if (project.deadline != null)
        setSelectedDate(DateFormat('yyyy-MM-dd').parse(project.deadline!));
      updateProgress();
    }
  }
}
