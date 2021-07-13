import 'package:todo/data/model/project.dart';
import 'package:todo/data/model/response/base_response.dart';

abstract class TodoRepository {
  Future<BaseResponse> addProject(Project project);

  Future<BaseResponse> updateProject(Project project);

  Future<List<Project>> fetchAllProjects();

  Future<BaseResponse> deleteRowByID(int id);

  Future<List<Project>> fetchSubProjectsById(int id);

  Future<Project?> fetchProjectById(int id);
}
