import 'package:equatable/equatable.dart';
import 'package:wangkie_app/models/video_model.dart';

// Event
abstract class VideoEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchTrendingVideos extends VideoEvent {
  final String regionCode;
  final int maxResults;

  FetchTrendingVideos({this.regionCode = 'VN', this.maxResults = 50});

  @override
  List<Object?> get props => [regionCode, maxResults];
}

// State
abstract class VideoState extends Equatable {
  @override
  List<Object?> get props => [];
}

class VideoInitial extends VideoState {}

class VideoLoading extends VideoState {}

class VideoLoaded extends VideoState {
  final List<VideoModel> videos;

  VideoLoaded(this.videos);

  @override
  List<Object?> get props => [videos];
}

class VideoError extends VideoState {
  final String message;

  VideoError(this.message);

  @override
  List<Object?> get props => [message];
}
