import 'package:dio/dio.dart';
import 'package:wangkie_app/models/video_model.dart';

class VideoRepository {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:3000/api/utube'));

  Future<List<VideoModel>> fetchTrendingVideos({
    String regionCode = 'VN',
    int maxResults = 50,
  }) async {
    final response = await _dio.get(
      '/trending',
      queryParameters: {'regionCode': regionCode, 'maxResults': maxResults},
    );

    if (response.statusCode == 200) {
      List data = response.data;
      return data.map((json) => VideoModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load trending videos');
    }
  }
}
