import 'package:uts_1123150074/core/constants/api_constants.dart';
import 'package:uts_1123150074/core/services/dio_client.dart';
import 'package:uts_1123150074/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<String> verifyFirebaseToken(String firebaseToken) async {
    final response = await DioClient.instance.post(
      ApiConstants.verifyToken,
      data: {'firebase_token': firebaseToken},
    );


    final data = response.data['data'] as Map<String, dynamic>;
    return data['access_token'] as String;
  }
}
