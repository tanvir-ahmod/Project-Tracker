import 'package:get/get.dart';
import 'package:project_tracker/data/model/project.dart';
import 'package:project_tracker/data/repositories/project/project_repository.dart';
import 'package:project_tracker/helpers/Constants.dart';
import 'package:project_tracker/ui/projects/add_project.dart';

class ViewProjectController extends GetxController {
  final ProjectRepository _projectRepository = Get.find();
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
  Function? _onUpdateClicked;

  void getSubProjectsById(int id) async {
    isLoading.value = true;
    var response = await _projectRepository.fetchSubProjectsById(id);
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
    getSubProjectsById(currentProject.value.id!);
  }

  void removeSubItem(int subProjectId) async {
     isLoading.value = true;
    await _projectRepository.removeParentProject(subProjectId);
    isLoading.value = false;
    updateCurrentProject();
  }

  void removeParentItem() async {
    isLoading.value = true;
    await _projectRepository.removeParentProject(currentProject.value.id!);
    currentProject.value.parentId = null;
    parentProject.value = null;
    isLoading.value = false;
    updateCurrentProject();
  }

  Future<void> showSubProjectsToAdd() async {
    isSubProjectsToAddLoading.value = true;
    final items =
        await _projectRepository.fetchSubProjectsToAdd(currentProject.value.id!);
    subProjectsToAdd.assignAll(items);
    isSubProjectsToAddLoading.value = false;
  }

  Future<void> showParentProjectsToAdd() async {
    isParentProjectsLoading.value = true;
    final items = await _projectRepository
        .fetchParentProjectsToAdd(currentProject.value.id!);
    parentProjectsToAdd.assignAll(items);
    isParentProjectsLoading.value = false;
  }

  Future<void> setAsParentProject(Project parentProject) async {
    isParentProjectsLoading.value = true;
    currentProject.value.parentId = parentProject.id;
    await _projectRepository.updateParentProject(
        parentProject.id!, currentProject.value.id!);
    this.parentProject.value = parentProject;
    isParentProjectsLoading.value = false;
    _getParentProject();
  }

  Future<void> setAsSubProject(Project subProject) async {
    subProject.parentId = currentProject.value.id!;
    await _projectRepository.updateParentProject(
        currentProject.value.id!, subProject.id!);
    updateCurrentProject();
  }

  void _getParentProject() async {
    Project? parentProject;
    if (currentProject.value.parentId != null &&
        currentProject.value.parentId != 0)
      parentProject = await _projectRepository
          .fetchProjectById(currentProject.value.parentId!);
    this.parentProject.value = parentProject;
  }

  void gotoAddToDoPage(Function? onUpdateWidget) {
    Get.off(() => AddProject(), arguments: {
      PARENT_ID: this.currentProject.value.id!,
      UPDATE_LISTENER: onUpdateWidget
    });
  }

  updateCurrentProject() async {
    Project? updatedProject =
        await _projectRepository.fetchProjectById(currentProject.value.id!);
    if (updatedProject != null) {
      setProject(updatedProject);
    }
    _onUpdateClicked?.call();
  }

  void setOnUpdateClick(Function? onUpdateClicked){
    _onUpdateClicked = onUpdateClicked;
  }
}
