import 'package:get/get.dart';
import 'package:todo/data/model/project.dart';
import 'package:todo/data/repositories/todo/todo_repository.dart';

class ViewProjectController extends GetxController {
  final TodoRepository _todoRepository = Get.find();
  var subProjects = <Project>[].obs;
  var subProjectsToAdd = <Project>[].obs;
  var isLoading = false.obs;
  var isSubProjectsToAddLoading = false.obs;
  var project = Project(checkLists: [], deadline: null, description: "").obs;
  var checkListProgress = 0.0.obs;

  void getSubProjectsById(int id) async {
    isLoading.value = true;
    var response = await _todoRepository.fetchSubProjectsById(id);
    subProjects.assignAll(response);
    isLoading.value = false;
  }

  setProject(Project project) {
    this.project.value = project;

    var totalTasks = project.checkLists.length;
    var completedTasks = project.checkLists.where((i) => i.done).length;
    if (totalTasks == 0 || completedTasks == 0)
      checkListProgress.value = 0.0;
    else
      checkListProgress.value = completedTasks / totalTasks;
  }

  void removeSubItem(int id) async {
    Project subProject = subProjects.where((project) => project.id == id).first;
    subProject.parentId = -1;
    isLoading.value = true;
    await _todoRepository.updateProject(subProject);
    Project? updatedProject = await _todoRepository.fetchProjectById(id);
    if (updatedProject != null) project.value = updatedProject;
    subProjects.remove(subProject);
    subProjects.refresh();
    isLoading.value = false;
  }

  Future<void> showSubProjectsToAdd() async {
    isSubProjectsToAddLoading.value = true;
    final items =
        await _todoRepository.fetchSubProjectsToAdd(project.value.id!);
    subProjectsToAdd.assignAll(items);
    isSubProjectsToAddLoading.value = false;
  }
}
