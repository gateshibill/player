// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TopicModel _$TopicModelFromJson(Map<String, dynamic> json) {
  return TopicModel(json['topicName'] as String, json['topicContent'] as String)
    ..topicId = json['topicId'] as int
    ..topicHits = json['topicHits'] as int
    ..topicPic = json['topicPic'] as String
    ..playUrl = json['playUrl'] as String
    ..topicTime = json['topicTime'] as int;
}

Map<String, dynamic> _$TopicModelToJson(TopicModel instance) =>
    <String, dynamic>{
      'topicId': instance.topicId,
      'topicName': instance.topicName,
      'topicHits': instance.topicHits,
      'topicPic': instance.topicPic,
      'topicContent': instance.topicContent,
      'playUrl': instance.playUrl,
      'topicTime': instance.topicTime
    };
