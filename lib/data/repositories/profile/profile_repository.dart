import 'package:todo/data/model/request/change_password_request.dart';
import 'package:todo/data/model/request/login_request.dart';
import 'package:todo/data/model/request/registration_request.dart';
import 'package:todo/data/model/response/base_response.dart';
import 'package:todo/data/model/response/login_response.dart';
import 'package:todo/data/model/response/registration_response.dart';

abstract class ProfileRepository {
  Future<BaseResponse> changePassword(
      ChangePasswordRequest changePasswordRequest);
}
