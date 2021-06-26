import 'package:todo/data/model/request/login_request.dart';
import 'package:todo/data/model/request/registration_request.dart';
import 'package:todo/data/model/response/login_response.dart';
import 'package:todo/data/model/response/registration_response.dart';

abstract class AuthService{
  Future<LoginResponse> login(LoginRequest loginRequest);

  Future<RegistrationResponse> register(
      RegistrationRequest registrationRequest);

}