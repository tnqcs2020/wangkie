class VideoModel {
  String? videoId;
  String? title;
  String? description;
  String? thumbnail;
  String? publishedAt;
  String? cachedAt;
  String? categoryId;
  List<String>? keywords;
  String? type;
  String? channelId;
  String? channelTitle;
  String? channelAvatar;
  String? viewCount;
  String? likeCount;
  String? commentCount;
  String? duration;
  List<String>? tags;
  bool? isLive;

  VideoModel({
    this.videoId,
    this.title,
    this.description,
    this.thumbnail,
    this.publishedAt,
    this.cachedAt,
    this.categoryId,
    this.keywords,
    this.type,
    this.channelId,
    this.channelTitle,
    this.channelAvatar,
    this.viewCount,
    this.likeCount,
    this.commentCount,
    this.duration,
    this.tags,
    this.isLive,
  });

  VideoModel.fromJson(Map<String, dynamic> json) {
    videoId = json['videoId'];
    title = json['title'];
    description = json['description'];
    thumbnail = json['thumbnail'];
    publishedAt = json['publishedAt'];
    cachedAt = json['cachedAt'];
    categoryId = json['categoryId'];
    keywords = json['keywords'] != null ? json['keywords'].cast<String>() : [];
    type = json['type'];
    channelId = json['channelId'];
    channelTitle = json['channelTitle'];
    channelAvatar = json['channelAvatar'];
    viewCount = json['viewCount'];
    likeCount = json['likeCount'];
    commentCount = json['commentCount'];
    duration = json['duration'];
    tags = json['tags'] != null ? json['tags'].cast<String>() : [];
    isLive = json['isLive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['videoId'] = videoId;
    data['title'] = title;
    data['description'] = description;
    data['thumbnail'] = thumbnail;
    data['publishedAt'] = publishedAt;
    data['cachedAt'] = cachedAt;
    data['categoryId'] = categoryId;
    data['keywords'] = keywords;
    data['type'] = type;
    data['channelId'] = channelId;
    data['channelTitle'] = channelTitle;
    data['channelAvatar'] = channelAvatar;
    data['viewCount'] = viewCount;
    data['likeCount'] = likeCount;
    data['commentCount'] = commentCount;
    data['duration'] = duration;
    data['tags'] = tags;
    data['isLive'] = isLive;
    return data;
  }
}
