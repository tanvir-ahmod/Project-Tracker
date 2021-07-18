import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:todo/data/model/project.dart';
import 'package:todo/data/model/request/login_request.dart';
import 'package:todo/data/model/request/registration_request.dart';
import 'package:todo/data/model/response/base_response.dart';
import 'package:todo/data/model/response/login_response.dart';
import 'package:todo/data/model/response/registration_response.dart';
import 'package:todo/helpers/Constants.dart';
import 'package:todo/services/api_service.dart';

import '../network/api_client.dart';
import 'auth_service.dart';

class RemoteServiceImpl implements ApiService, AuthService {
  final _apiClient = ApiClient().getApiClient();

  Future<LoginResponse> login(LoginRequest loginRequest) async {
    _apiClient.interceptors.clear();
    final data = jsonEncode(loginRequest.toJson());
    var response;
    try {
      response = await _apiClient.post('login', data: data);
    } on DioError catch (e) {
      if (e.response?.data != null)
        return LoginResponse.fromJson(e.response!.data);
    }
    if (response.statusCode == RESPONSE_OK) {
      return LoginResponse.fromJson(response.data);
    } else {
      return loginResponseFromJson("");
    }
  }

  Future<RegistrationResponse> register(
      RegistrationRequest registrationRequest) async {
    _apiClient.interceptors.clear();
    final data = registrationRequest.toRawJson();
    try {
      final response = await _apiClient.post("register", data: data);
      return RegistrationResponse.fromJson(response.data);
    } on DioError catch (e) {
      if (e.response?.statusCode == 400)
        return RegistrationResponse.fromJson(e.response!.data);
    }

    return registrationResponseFromJson("");
  }

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
    final response = await _apiClient.get("updateParentId", queryParameters: {
      'parent_id': parentId,
      'sub_project_id': subProjectId
    });
    if (response.statusCode == RESPONSE_OK) {
      return BaseResponse.fromJson(response.data);
    }
    return baseResponseFromJson("");
  }

  @override
  Future<BaseResponse> removeParentProject(int subProjectId) async {
    final response = await _apiClient.get("removeParentId/$subProjectId");
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
  Future<BaseResponse> resendConfirmationLink(String email) async {
    final response =
        await _apiClient.get("resendToken", queryParameters: {'email': email});
    if (response.statusCode == RESPONSE_OK) {
      return BaseResponse.fromJson(response.data);
    }
    return baseResponseFromJson("");
  }
}
