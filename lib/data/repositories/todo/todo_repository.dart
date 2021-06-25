import 'package:flutterapp/data/model/Task.dart';
import 'package:flutterapp/data/model/response/get_all_to_do_item_response.dart';

abstract class TodoRepository {
  Future insertTask(Task task);

  Future fetchAllTasks();

  Future deleteRowByID(int id);

  Future<List<GetToDoItemResponse>> getAllToDoItems();
}
