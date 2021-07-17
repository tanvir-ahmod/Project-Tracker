import 'package:todo/data/model/project.dart';
import 'package:todo/data/model/response/base_response.dart';
import 'package:todo/data/repositories/todo/todo_repository.dart';
import 'package:todo/services/api_service.dart';
import 'package:get/get.dart';

class TodoRepositoryImpl extends TodoRepository {
  ApiService _service = Get.find();

  @override
  Future<BaseResponse> addProject(Project project) =>
      _service.addProject(project);

  @override
  Future<List<Project>> fetchAllProjects() => _service.fetchAllProjects();

  @override
  Future<BaseResponse> deleteRowByID(int id) => _service.deleteRowByID(id);

  @override
  Future<List<Project>> fetchSubProjectsById(int id) =>
      _service.fetchSubProjectsById(id);

  @override
  Future<BaseResponse> updateProject(Project project) =>
      _service.updateProject(project);

  @override
  Future<Project?> fetchProjectById(int id) => _service.fetchProjectById(id);

  @override
  Future<List<Project>> fetchSubProjectsToAdd(int id) =>
      _service.fetchSubProjectsToAdd(id);

  @override
  Future<List<Project>> fetchParentProjectsToAdd(int id) =>
      _service.fetchParentProjectsToAdd(id);

  @override
  Future<BaseResponse> updateParentProject(int parentId, int subProjectId) =>
      _service.updateParentProject(parentId, subProjectId);

  @override
  Future<BaseResponse> removeParentProject(int subProjectId) =>
      _service.removeParentProject(subProjectId);
}
