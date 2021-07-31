import 'package:project_tracker/data/model/request/change_password_request.dart';
import 'package:project_tracker/data/model/response/base_response.dart';

abstract class ProfileRepository {
  Future<BaseResponse> changePassword(
      ChangePasswordRequest changePasswordRequest);
}
