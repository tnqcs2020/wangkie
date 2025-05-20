import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:wangkie_app/common/app_sizes.dart';
import 'package:wangkie_app/common/blocs/video_bloc.dart';
import 'package:wangkie_app/common/equatable/video_equatable.dart';
import 'package:wangkie_app/repository/video_repository.dart';

class MoreScreen extends StatelessWidget {
  final VideoRepository repository;

  const MoreScreen({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VideoBloc(repository)..add(FetchTrendingVideos()),
      child: Scaffold(
        appBar: AppBar(title: Text('Trending Videos')),
        body: BlocBuilder<VideoBloc, VideoState>(
          builder: (context, state) {
            if (state is VideoLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is VideoLoaded) {
              final videos = state.videos;
              return ListView.builder(
                itemCount: videos.length,
                itemBuilder: (context, index) {
                  final video = videos[index];
                  return GestureDetector(
                    onTap: () {
                      context.push('/youtube', extra: video);
                    },
                    child: Container(
                      padding: EdgeInsets.only(bottom: 15.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize:
                            MainAxisSize
                                .min, // Quan trọng: cho phép co theo nội dung
                        children: [
                          // Thumbnail at top
                          AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Image.network(
                              video.thumbnail ?? '',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.error_outline),
                                );
                              },
                            ),
                          ),
                          // Video info
                          Padding(
                            padding: EdgeInsets.fromLTRB(15.w, 2.h, 10.w, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Channel Avatar
                                Padding(
                                  padding: EdgeInsets.only(top: 10.h),
                                  child: CircleAvatar(
                                    radius: 20.r,
                                    backgroundImage: NetworkImage(
                                      video.channelAvatar ?? '',
                                      scale: 2,
                                    ),
                                    onBackgroundImageError: (_, __) {},
                                    child:
                                        video.channelAvatar == null
                                            ? const Icon(Icons.person, size: 14)
                                            : null,
                                  ),
                                ),

                                // Title + Channel Info
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: 10.w,
                                      top: 5.h,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          video.title ?? '',
                                          style: TextStyle(
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          '${video.channelTitle ?? ''} • ${_formatViewCount(video.viewCount ?? '0')} lượt xem • ${_formatDate(video.publishedAt ?? '')}',
                                          style: TextStyle(
                                            fontSize: 11.sp,
                                            color: Colors.grey[600],
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // More icon
                                SizedBox(
                                  width: AppSizes.sl,
                                  height: AppSizes.sl,
                                  child: Stack(
                                    alignment: Alignment.topCenter,
                                    children: [
                                      Positioned(
                                        top: 0,
                                        child: SizedBox(
                                          width: AppSizes.xl,
                                          height: AppSizes.xl,
                                          child: IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              Icons.more_vert,
                                              size: AppSizes.iconSm,
                                              color: Colors.grey[600],
                                            ),
                                            padding: EdgeInsets.zero,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (state is VideoError) {
              return Center(child: Text('Lỗi: ${state.message}'));
            }
            return Center(child: Text('Start fetching trending videos'));
          },
        ),
      ),
    );
  }

  String _formatViewCount(String viewCount) {
    final count = int.tryParse(viewCount) ?? 0;
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        return 'Hôm nay';
      } else if (difference.inDays == 1) {
        return 'Hôm qua';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} ngày trước';
      } else if (difference.inDays < 30) {
        return '${(difference.inDays / 7).floor()} tuần trước';
      } else if (difference.inDays < 365) {
        return '${(difference.inDays / 30).floor()} tháng trước';
      } else {
        return '${(difference.inDays / 365).floor()} năm trước';
      }
    } catch (e) {
      return '';
    }
  }
}
