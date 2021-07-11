import 'package:get/get.dart';
import 'package:todo/data/model/project.dart';
import 'package:todo/data/repositories/todo/todo_repository.dart';

class ViewProjectController extends GetxController {
  final TodoRepository _todoRepository = Get.find();
  var subProjects = <Project>[].obs;
  var isLoading = false.obs;
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
}
