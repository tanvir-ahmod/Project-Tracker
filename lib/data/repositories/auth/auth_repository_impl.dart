import 'package:flutterapp/data/model/request/login_request.dart';
import 'package:flutterapp/data/model/response/login_response.dart';
import 'package:flutterapp/data/repositories/auth/auth_repository.dart';
import 'package:flutterapp/network/ApiService.dart';

class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<LoginResponse> login(LoginRequest loginRequest) async {
    return await ApiService.login(loginRequest);
  }
}
