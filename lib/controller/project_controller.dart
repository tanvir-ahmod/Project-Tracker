import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:project_tracker/data/model/project.dart';
import 'package:project_tracker/data/repositories/project/project_repository.dart';
import 'package:project_tracker/helpers/Constants.dart';

class ProjectController extends GetxController {
  var isLoading = false.obs;
  ProjectRepository _projectRepository = Get.find();

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

  int? parentId;
  Function? _onUpdateClicked;

  void getAllProjects() async {
    isLoading.value = true;
    var response = await _projectRepository.fetchAllProjects();
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
      tempProject.parentId = this.parentId;
    }
    isLoading.value = true;
    try {
      final response = isEditable.value
          ? await _projectRepository.updateProject(tempProject)
          : await _projectRepository.addProject(tempProject);
      isLoading.value = false;
      Fluttertoast.showToast(
          msg: response.responseMessage, toastLength: Toast.LENGTH_LONG);
    } on DioError {
      isLoading.value = false;
    }
    _onUpdateClicked?.call();
    Get.back();
  }

  Future<bool> deleteProjectById(int id) async {
    isLoading.value = true;
    final response = await _projectRepository.deleteProjectById(id);
    isLoading.value = false;
    Fluttertoast.showToast(
        msg: response.responseMessage, toastLength: Toast.LENGTH_LONG);
    if (response.responseCode == RESPONSE_OK) {
      _onUpdateClicked?.call();
      if (isPopup) Get.back(closeOverlays: true);
    }
  }

  saveCheckList() {
    if (editedCheckList != null) {
      editedCheckList?.description = inputCheckListController.text;
      editedCheckList?.done = isAddItemChecked.value;
      checkLists.insert(editingIndex, editedCheckList!);
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

  void cancelEditing() {
    if (editedCheckList != null) {
      checkLists.insert(editingIndex, editedCheckList!);
      checkLists.refresh();
    }
    showAddCheckListWidget(false);
  }

  clearCheckListInputController() {
    inputCheckListController.text = "";
  }

  editCheckList(int index) {
    editingIndex = index;
    inputCheckListController.text = checkLists[index].description;
    isAddItemChecked.value = checkLists[index].done;
    editedCheckList = checkLists[index];
    checkLists.removeAt(index);
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

  setProjectToEdit(Project? project, int? parentId) {
    this.parentId = parentId;
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

  void updateProjectStatus(int projectId, bool status, {Function? onUpdate}) async {
    isLoading.value = true;
    final response =
        await _projectRepository.updateProjectStatus(projectId, status);
    isLoading.value = false;
    Fluttertoast.showToast(
        msg: response.responseMessage, toastLength: Toast.LENGTH_LONG);
    onUpdate?.call();
  }

  void setOnUpdateClick(Function? onUpdateClicked) {
    _onUpdateClicked = onUpdateClicked;
  }

  clearCache() {
    titleController.text = "";
    checkLists.clear();
    clearSelectedDate();
    progress.value = 0.0;
    isEditable.value = false;
  }
}
