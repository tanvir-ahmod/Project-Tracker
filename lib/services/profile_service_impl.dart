import 'package:project_tracker/data/model/request/change_password_request.dart';
import 'package:project_tracker/data/model/response/base_response.dart';
import 'package:project_tracker/network/api_client.dart';
import 'package:project_tracker/services/profile_service.dart';

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
