import 'package:todo/data/model/request/login_request.dart';
import 'package:todo/data/model/request/registration_request.dart';
import 'package:todo/data/model/response/login_response.dart';
import 'package:todo/data/model/response/registration_response.dart';
import 'package:todo/data/repositories/auth/auth_repository.dart';
import 'package:todo/helpers/Constants.dart';
import 'package:todo/services/auth_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthRepositoryImpl extends AuthRepository {
  AuthService service = Get.find();
  @override
  Future<LoginResponse> login(LoginRequest loginRequest) async {
    final response = await service.login(loginRequest);
    final box = GetStorage();
    box.write(TOKEN, response.token);
    return response;
  }

  @override
  Future<RegistrationResponse> register(
      RegistrationRequest registrationRequest) async {
    return await service.register(registrationRequest);
  }

  @override
  void logout() {
    GetStorage().erase();
  }
}
