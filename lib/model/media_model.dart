
import 'package:json_annotation/json_annotation.dart';
import 'source_model.dart';
import 'metadata_model.dart';
import '../data/cache_data.dart';

enum MediaType {
  Video,
  Topic,
  Channel,
  Program,
  Anchor,
  Serial,//连续剧
}

abstract  class MediaModel {
  String getName();
  MediaType getMediaType();//1:
  List<String>getPics();
  String getPlayUrl();
}
