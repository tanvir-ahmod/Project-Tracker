import 'package:get/get.dart';
import 'package:todo/data/model/project.dart';
import 'package:todo/data/repositories/todo/todo_repository.dart';
import 'package:todo/helpers/Constants.dart';
import 'package:todo/ui/projects/add_project.dart';

class ViewProjectController extends GetxController {
  final TodoRepository _todoRepository = Get.find();
  var subProjects = <Project>[].obs;
  var subProjectsToAdd = <Project>[].obs;
  var parentProjectsToAdd = <Project>[].obs;
  var isLoading = false.obs;
  var isParentProjectsLoading = false.obs;
  var isSubProjectsToAddLoading = false.obs;
  var currentProject =
      Project(checkLists: [], deadline: null, description: "").obs;
  var parentProject = Rxn<Project>();
  var checkListProgress = 0.0.obs;

  void getSubProjectsById(int id) async {
    isLoading.value = true;
    var response = await _todoRepository.fetchSubProjectsById(id);
    subProjects.assignAll(response);
    isLoading.value = false;
  }

  setProject(Project project) {
    this.currentProject.value = project;

    var totalTasks = project.checkLists.length;
    var completedTasks = project.checkLists.where((i) => i.done).length;
    if (totalTasks == 0 || completedTasks == 0)
      checkListProgress.value = 0.0;
    else
      checkListProgress.value = completedTasks / totalTasks;

    _getParentProject();
  }

  void removeSubItem(int subProjectId) async {
    Project subProject =
        subProjects.where((project) => project.id == subProjectId).first;
    isLoading.value = true;
    await _todoRepository.removeParentProject(subProjectId);
    Project? updatedProject;
    if (subProject.parentId != null)
      updatedProject =
          await _todoRepository.fetchProjectById(subProject.parentId!);
    if (updatedProject != null) currentProject.value = updatedProject;
    subProjects.remove(subProject);
    subProjects.refresh();
    isLoading.value = false;
  }

  void removeParentItem() async {
    isLoading.value = true;
    await _todoRepository.removeParentProject(currentProject.value.id!);
    currentProject.value.parentId = null;
    parentProject.value = null;
    isLoading.value = false;
  }

  Future<void> showSubProjectsToAdd() async {
    isSubProjectsToAddLoading.value = true;
    final items =
        await _todoRepository.fetchSubProjectsToAdd(currentProject.value.id!);
    subProjectsToAdd.assignAll(items);
    isSubProjectsToAddLoading.value = false;
  }

  Future<void> showParentProjectsToAdd() async {
    isParentProjectsLoading.value = true;
    final items = await _todoRepository
        .fetchParentProjectsToAdd(currentProject.value.id!);
    parentProjectsToAdd.assignAll(items);
    isParentProjectsLoading.value = false;
  }

  Future<void> setAsParentProject(Project parentProject) async {
    isParentProjectsLoading.value = true;
    currentProject.value.parentId = parentProject.id;
    await _todoRepository.updateParentProject(
        parentProject.id!, currentProject.value.id!);
    this.parentProject.value = parentProject;
    isParentProjectsLoading.value = false;
  }

  Future<void> setAsSubProject(Project subProject) async {
    isSubProjectsToAddLoading.value = true;
    subProject.parentId = currentProject.value.id!;
    await _todoRepository.updateParentProject(
        currentProject.value.id!, subProject.id!);
    Project? updatedProject =
        await _todoRepository.fetchProjectById(currentProject.value.id!);
    if (updatedProject != null) {
      setProject(updatedProject);
    }
    subProjects.add(subProject);
    subProjects.refresh();
    isSubProjectsToAddLoading.value = false;
  }

  void _getParentProject() async {
    Project? parentProject;
    if (currentProject.value.parentId != null &&
        currentProject.value.parentId != 0)
      parentProject = await _todoRepository
          .fetchProjectById(currentProject.value.parentId!);
    this.parentProject.value = parentProject;
  }

  void gotoAddToDoPage() {
    Get.off(() => AddTodoScreen(),
        arguments: {PARENT_ID: this.currentProject.value.id!});
  }
}
