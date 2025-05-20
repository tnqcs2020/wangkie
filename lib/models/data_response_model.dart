import 'package:wangkie_app/models/user_model.dart';

class DataResponseModel {
  final bool success;
  final int code;
  final Data? data;
  final String message;

  DataResponseModel({
    required this.success,
    required this.code,
    this.data,
    required this.message,
  });

  factory DataResponseModel.fromJson(Map<String, dynamic> json) {
    return DataResponseModel(
      success: json['success'],
      code: json['code'],
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'code': code,
      'data': data?.toJson(),
      'message': message,
    };
  }
}

class Data {
  final String? token;
  final UserModel? user;

  Data({this.token, this.user});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(token: json['token'], user: UserModel.fromJson(json['user']));
  }

  Map<String, dynamic> toJson() {
    return {'token': token, 'user': user?.toJson()};
  }
}
