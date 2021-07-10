import 'package:todo/data/model/project.dart';
import 'package:todo/data/model/response/base_response.dart';

abstract class TodoRepository {
  Future<BaseResponse> addProject(Project project);

  Future<List<Project>> fetchAllProjects();

  Future<BaseResponse> deleteRowByID(int id);

}
