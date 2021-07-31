import 'package:project_tracker/data/model/request/login_request.dart';
import 'package:project_tracker/data/model/request/registration_request.dart';
import 'package:project_tracker/data/model/response/base_response.dart';
import 'package:project_tracker/data/model/response/login_response.dart';
import 'package:project_tracker/data/model/response/registration_response.dart';

abstract class AuthRepository {
  Future<LoginResponse> login(LoginRequest loginRequest);

  Future<RegistrationResponse> register(
      RegistrationRequest registrationRequest);

  Future<BaseResponse> resendConfirmationLink(String email);

  Future<BaseResponse> resetPassword(String email);

  void logout();
}
