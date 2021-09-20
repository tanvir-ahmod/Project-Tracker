import 'package:project_tracker/data/model/project.dart';
import 'package:project_tracker/data/model/response/base_response.dart';

abstract class ProjectRepository {
  Future<BaseResponse> addProject(Project project);

  Future<BaseResponse> updateProject(Project project);

  Future<List<Project>> fetchAllProjects();

  Future<BaseResponse> deleteRowByID(int id);

  Future<List<Project>> fetchSubProjectsById(int id);

  Future<List<Project>> fetchParentProjectsById(int id);

  Future<Project?> fetchProjectById(int id);

  Future<List<Project>> fetchSubProjectsToAdd(int id);

  Future<List<Project>> fetchParentProjectsToAdd(int id);

  Future<BaseResponse> updateParentProject(int parentId, int subProjectId);

  Future<BaseResponse> removeParentProject(int parentProjectId,int subProjectId);

  Future<BaseResponse> updateProjectStatus(int projectId, bool status);
}
