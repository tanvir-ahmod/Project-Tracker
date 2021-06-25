import 'package:flutterapp/data/model/request/login_request.dart';
import 'package:flutterapp/data/model/request/registration_request.dart';
import 'package:flutterapp/data/model/response/login_response.dart';
import 'package:flutterapp/data/model/response/registration_response.dart';
import 'package:flutterapp/data/repositories/auth/auth_repository.dart';
import 'package:flutterapp/helpers/Constants.dart';
import 'package:flutterapp/network/ApiService.dart';
import 'package:get_storage/get_storage.dart';

class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<LoginResponse> login(LoginRequest loginRequest) async {
    final response = await ApiService.login(loginRequest);
    final box = GetStorage();
    box.write(Constants.TOKEN, response.token);
    return response;
  }

  @override
  Future<RegistrationResponse> register(
      RegistrationRequest registrationRequest) async {
    return await ApiService.register(registrationRequest);
  }
}
