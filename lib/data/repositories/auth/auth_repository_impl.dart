import 'package:project_tracker/data/model/request/login_request.dart';
import 'package:project_tracker/data/model/request/registration_request.dart';
import 'package:project_tracker/data/model/response/base_response.dart';
import 'package:project_tracker/data/model/response/login_response.dart';
import 'package:project_tracker/data/model/response/registration_response.dart';
import 'package:project_tracker/data/repositories/auth/auth_repository.dart';
import 'package:project_tracker/helpers/Constants.dart';
import 'package:project_tracker/services/auth_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthRepositoryImpl extends AuthRepository {
  AuthService _service = Get.find();

  @override
  Future<LoginResponse> login(LoginRequest loginRequest) async {
    final response = await _service.login(loginRequest);
    final box = GetStorage();
    box.write(TOKEN, response.token);
    return response;
  }

  @override
  Future<RegistrationResponse> register(
      RegistrationRequest registrationRequest) async {
    return await _service.register(registrationRequest);
  }

  @override
  void logout() {
    GetStorage().erase();
  }

  @override
  Future<BaseResponse> resendConfirmationLink(String email) =>
      _service.resendConfirmationLink(email);

  @override
  Future<BaseResponse> resetPassword(String email)=>_service.resetPassword(email);
}
