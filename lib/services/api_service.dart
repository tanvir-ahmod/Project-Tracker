import 'package:flutterapp/data/model/Task.dart';
import 'package:flutterapp/data/model/response/base_response.dart';

abstract class ApiService {
  Future<BaseResponse> insert(Task task);

  Future<List<Task>> fetchAllTasks();

  Future<BaseResponse> deleteRowByID(int id);

}
