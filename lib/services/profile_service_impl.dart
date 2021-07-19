import 'package:todo/data/model/request/change_password_request.dart';
import 'package:todo/data/model/response/base_response.dart';
import 'package:todo/network/api_client.dart';
import 'package:todo/services/profile_service.dart';

class ProfileServiceImpl implements ProfileService {
  final _apiClient = ApiClient().getApiClient();

  @override
  Future<BaseResponse> changePassword(
      ChangePasswordRequest changePasswordRequest) async {
    final data = changePasswordRequest.toRawJson();
    final response = await _apiClient.post("changePassword", data: data);
    return BaseResponse.fromJson(response.data);
  }
}
