import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wangkie_app/models/data_response_model.dart';
import 'package:wangkie_app/models/user_model.dart';
import 'package:wangkie_app/utils/user_save.dart';

class AuthState {
  final bool isAuthenticated;
  final String? token;
  final UserModel? user;
  AuthState({required this.isAuthenticated, this.user, this.token});
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState(isAuthenticated: false));

  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:3000'));

  Future login(String email, String password) async {
    try {
      final res = await _dio.post(
        '/api/auth/login',
        data: {"email": email, "password": password},
      );
      final resData = DataResponseModel.fromJson(res.data!);
      if (resData.success) {
        final token = resData.data!.token;
        final user = resData.data!.user;
        final authState = AuthState(
          isAuthenticated: true,
          token: token,
          user: user,
        );
        emit(authState);
        await saveAuthState({'email': email, 'token': token});
        return resData;
      }
    } on DioException catch (e) {
      final resData = DataResponseModel.fromJson(e.response!.data);
      print("Error code: ${resData.code}");
      print("Message: ${resData.message}");
      print("Error debug: ${e.message}");
      emit(AuthState(isAuthenticated: false));
      return resData;
    }
  }

  Future loginToken(String email, String token) async {
    try {
      final res = await _dio.post(
        '/api/auth/login-token',
        data: {"email": email},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final resData = DataResponseModel.fromJson(res.data!);
      if (resData.success) {
        final user = resData.data!.user;
        final authState = AuthState(
          isAuthenticated: true,
          token: token,
          user: user,
        );
        emit(authState);
        await saveAuthState({'email': email, 'token': token});
        return {"expired": false, "resData": resData};
      }
    } on DioException catch (e) {
      final resData = DataResponseModel.fromJson(e.response!.data);
      print("Error code: ${resData.code}");
      print("Message: ${resData.message}");
      print("Error debug: ${e.message}");
      emit(AuthState(isAuthenticated: false));
      // Kiểm tra lỗi token hết hạn
      if (e.error == 'Token expired' || e.error == 'Invalid token') {
        print("Login error: ${e.error}");
        logout();
        return {"expired": false, "resData": resData};
      }
    }
  }

  Future loginGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        final res = await _dio.post(
          '/api/user/isExistUser',
          data: {'email': googleUser.email},
        );
        final resData = DataResponseModel.fromJson(res.data!);
        if (resData.success) {
          final DataResponseModel _resData = await login(googleUser.email, "");
          return _resData;
        } else {
          await _dio.post(
            '/api/auth/register',
            data: {
              "email": googleUser.email,
              "password": "",
              "fullName": googleUser.displayName,
              "avatarUrl": googleUser.photoUrl,
              "provider": "google",
              "googleId": googleUser.id,
            },
          );
          final DataResponseModel _resData = await login(googleUser.email, "");
          return _resData;
        }
      } else {
        emit(AuthState(isAuthenticated: false));
      }
    } on DioException catch (e) {
      final resData = DataResponseModel.fromJson(e.response!.data!);
      print("Error code: ${resData.code}");
      print("Message: ${resData.message}");
      print("Error debug: ${e.message}");
      emit(AuthState(isAuthenticated: false));
      return resData;
    }
  }

  Future<void> loginApple() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        final res = await _dio.post(
          '/api/user/isExistUser',
          data: {'email': googleUser.email},
        );
        if (res.data) {
          await login(googleUser.email, "");
        } else {
          await _dio.post(
            '/api/auth/register',
            data: {
              "email": googleUser.email,
              "password": "",
              "fullName": googleUser.displayName,
              "avatarUrl": googleUser.photoUrl,
              "provider": "google",
              "googleId": googleUser.id,
            },
          );
          await login(googleUser.email, "");
        }
      } else {
        emit(AuthState(isAuthenticated: false));
      }
    } catch (e) {
      print("Login error: $e");
      emit(AuthState(isAuthenticated: false));
    }
  }

  Future register(UserModel user, String password) async {
    try {
      final res = await _dio.post(
        '/api/auth/register',
        data: {
          "email": user.email,
          "password": password,
          "fullName": user.fullName,
          "phoneNumber": user.phoneNumber,
          "dateOfBirth": user.dateOfBirth,
        },
      );
      final resData = DataResponseModel.fromJson(res.data);
      if (resData.success) {
        await login(user.email, password);
        return resData;
      }
    } on DioException catch (e) {
      final resData = DataResponseModel.fromJson(e.response!.data!);
      print("Error code: ${resData.code}");
      print("Message: ${resData.message}");
      print("Error debug: ${e.message}");
      emit(AuthState(isAuthenticated: false));
      return resData;
    }
  }

  Future updateProfile(UserModel updatedUser) async {
    if (state.token == null) return;
    try {
      final res = await _dio.put(
        '/api/user/profile',
        data: updatedUser.toJson(),
        options: Options(headers: {'Authorization': 'Bearer ${state.token}'}),
      );
      final resData = DataResponseModel.fromJson(res.data);
      emit(
        AuthState(
          isAuthenticated: true,
          token: state.token,
          user: resData.data!.user,
        ),
      );
      return resData;
    } on DioException catch (e) {
      final resData = DataResponseModel.fromJson(e.response!.data!);
      print("Error code: ${resData.code}");
      print("Message: ${resData.message}");
      print("Error debug: ${e.message}");
      return resData;
    }
  }

  //   Future<String?> _uploadAvatar(File imageFile) async {
  //   final dio = Dio();
  //   final fileName = path.basename(imageFile.path);
  //   final formData = FormData.fromMap({
  //     "avatar": await MultipartFile.fromFile(imageFile.path, filename: fileName),
  //   });

  //   try {
  //     final response = await dio.post(
  //       'http://10.0.2.2:3000/upload-avatar',
  //       data: formData,
  //       options: Options(
  //         headers: {
  //           'Authorization': 'Bearer ${context.read<AuthCubit>().state.token}',
  //           'Content-Type': 'multipart/form-data',
  //         },
  //       ),
  //     );
  //     return response.data['avatarUrl'];
  //   } catch (e) {
  //     print("Lỗi tải ảnh: $e");
  //     return null;
  //   }
  // }

  void logout() {
    emit(AuthState(isAuthenticated: false));
    logoutAuthState();
  }
}
