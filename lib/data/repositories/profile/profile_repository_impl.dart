import 'package:get/get.dart';
import 'package:project_tracker/data/model/request/change_password_request.dart';
import 'package:project_tracker/data/model/response/base_response.dart';
import 'package:project_tracker/data/repositories/profile/profile_repository.dart';
import 'package:project_tracker/services/profile_service.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileService _service = Get.find();

  @override
  Future<BaseResponse> changePassword(
          ChangePasswordRequest changePasswordRequest) =>
      _service.changePassword(changePasswordRequest);
}
