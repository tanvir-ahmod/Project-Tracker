import 'package:project_tracker/data/model/project.dart';
import 'package:project_tracker/data/model/response/base_response.dart';
import 'package:project_tracker/helpers/Constants.dart';
import 'package:project_tracker/services/api_service.dart';

import '../network/api_client.dart';

class RemoteServiceImpl implements ApiService {
  final _apiClient = ApiClient().getApiClient();

  @override
  Future<List<Project>> fetchAllProjects() async {
    final response = await _apiClient.get("getAllProjects");
    if (response.statusCode == RESPONSE_OK) {
      return List<Project>.from(response.data.map((x) => Project.fromJson(x)));
    }
    return [];
  }

  @override
  Future<BaseResponse> deleteRowByID(int id) async {
    final response = await _apiClient.delete("deleteProjectById/$id");
    if (response.statusCode == RESPONSE_OK) {
      return BaseResponse.fromJson(response.data);
    } else {
      return baseResponseFromJson("");
    }
  }

  @override
  Future<BaseResponse> addProject(Project project) async {
    final data = project.toRawJson();
    final response = await _apiClient.post("addProject", data: data);
    if (response.statusCode == RESPONSE_OK) {
      return BaseResponse.fromJson(response.data);
    } else {
      return baseResponseFromJson("");
    }
  }

  @override
  Future<List<Project>> fetchSubProjectsById(int id) async {
    final response = await _apiClient.get("getSubProjectByParentId/$id");
    if (response.statusCode == RESPONSE_OK) {
      return List<Project>.from(response.data.map((x) => Project.fromJson(x)));
    }
    return [];
  }

  @override
  Future<BaseResponse> updateProject(Project project) async {
    final data = project.toRawJson();
    final response = await _apiClient.post("updateProject", data: data);
    if (response.statusCode == RESPONSE_OK) {
      return BaseResponse.fromJson(response.data);
    } else {
      return baseResponseFromJson("");
    }
  }

  @override
  Future<Project?> fetchProjectById(int id) async {
    final response = await _apiClient.get("getProjectById/$id");
    if (response.statusCode == RESPONSE_OK) {
      return Project.fromJson(response.data);
    }
    return null;
  }

  @override
  Future<List<Project>> fetchSubProjectsToAdd(int id) async {
    final response = await _apiClient.get("getSubProjectsToAdd/$id");
    if (response.statusCode == RESPONSE_OK) {
      return List<Project>.from(response.data.map((x) => Project.fromJson(x)));
    }
    return [];
  }

  @override
  Future<BaseResponse> updateParentProject(
      int parentId, int subProjectId) async {
    final response = await _apiClient.get("addToSubProject", queryParameters: {
      'parent_id': parentId,
      'sub_project_id': subProjectId
    });
    if (response.statusCode == RESPONSE_OK) {
      return BaseResponse.fromJson(response.data);
    }
    return baseResponseFromJson("");
  }

  @override
  Future<BaseResponse> removeParentProject(int parentId, int subProjectId) async {
    final response = await _apiClient.get("removeParentProject",
        queryParameters: {'parent_id': parentId, 'sub_project_id': subProjectId});
    if (response.statusCode == RESPONSE_OK) {
      return BaseResponse.fromJson(response.data);
    }
    return baseResponseFromJson("");
  }

  @override
  Future<List<Project>> fetchParentProjectsToAdd(int id) async {
    final response = await _apiClient.get("getParentProjectsToAdd/$id");
    if (response.statusCode == RESPONSE_OK) {
      return List<Project>.from(response.data.map((x) => Project.fromJson(x)));
    }
    return [];
  }

  @override
  Future<BaseResponse> updateProjectStatus(int projectId, bool status) async {
    final response = await _apiClient.get("activateProject",
        queryParameters: {'projectId': projectId, 'isActive': status});
    if (response.statusCode == RESPONSE_OK) {
      return BaseResponse.fromJson(response.data);
    }
    return baseResponseFromJson("");
  }

  @override
  Future<List<Project>> fetchParentProjectsById(int id) async{
    final response = await _apiClient.get("getParentProjectById/$id");
    if (response.statusCode == RESPONSE_OK) {
      return List<Project>.from(response.data.map((x) => Project.fromJson(x)));
    }
    return [];
  }
}
