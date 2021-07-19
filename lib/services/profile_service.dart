import 'package:todo/data/model/request/change_password_request.dart';
import 'package:todo/data/model/response/base_response.dart';

abstract class ProfileService {
  Future<BaseResponse> changePassword(
      ChangePasswordRequest changePasswordRequest);
}
