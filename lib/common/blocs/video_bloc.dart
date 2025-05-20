import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wangkie_app/common/equatable/video_equatable.dart';
import 'package:wangkie_app/repository/video_repository.dart';

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  final VideoRepository repository;

  VideoBloc(this.repository) : super(VideoInitial()) {
    on<FetchTrendingVideos>((event, emit) async {
      emit(VideoLoading());
      try {
        final videos = await repository.fetchTrendingVideos(
          regionCode: event.regionCode,
          maxResults: event.maxResults,
        );
        emit(VideoLoaded(videos));
      } catch (e) {
        emit(VideoError(e.toString()));
      }
    });
  }
}
