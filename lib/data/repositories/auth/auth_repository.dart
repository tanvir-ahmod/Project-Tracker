import 'package:flutterapp/data/model/request/login_request.dart';
import 'package:flutterapp/data/model/response/login_response.dart';

abstract class AuthRepository {
  Future<LoginResponse> login(LoginRequest loginRequest);
}
