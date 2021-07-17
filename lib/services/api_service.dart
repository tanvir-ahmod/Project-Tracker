import 'package:todo/data/model/project.dart';
import 'package:todo/data/model/response/base_response.dart';

abstract class ApiService {
  Future<BaseResponse> addProject(Project project);

  Future<BaseResponse> updateProject(Project project);

  Future<List<Project>> fetchAllProjects();

  Future<BaseResponse> deleteRowByID(int id);

  Future<List<Project>> fetchSubProjectsById(int id);

  Future<Project?> fetchProjectById(int id);

  Future<List<Project>> fetchSubProjectsToAdd(int id);

  Future<List<Project>> fetchParentProjectsToAdd(int id);

  Future<BaseResponse> updateParentProject(int parentId, int subProjectId);

  Future<BaseResponse> removeParentProject(int subProjectId);

}
