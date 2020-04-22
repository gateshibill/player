// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anchor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnchorModel _$AnchorModelFromJson(Map<String, dynamic> json) {
  return AnchorModel()
    ..id = json['id'] as int
    ..appId = json['appId'] as int
    ..name = json['name'] as String
    ..age = json['age'] as int
    ..gender = json['gender'] as int
    ..rank = json['rank'] as int
    ..type = json['type'] as int
    ..subType = json['subType'] as int
    ..playUrl = json['playUrl'] as String
    ..posterUrl = json['posterUrl'] as String
    ..online = json['online'] as int
    ..content = json['content'] as String
    ..creatTime = json['creatTime'] == null
        ? null
        : DateTime.parse(json['creatTime'] as String)
    ..lastTime = json['lastTime'] == null
        ? null
        : DateTime.parse(json['lastTime'] as String);
}

Map<String, dynamic> _$AnchorModelToJson(AnchorModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'appId': instance.appId,
      'name': instance.name,
      'age': instance.age,
      'gender': instance.gender,
      'rank': instance.rank,
      'type': instance.type,
      'subType': instance.subType,
      'playUrl': instance.playUrl,
      'posterUrl': instance.posterUrl,
      'online': instance.online,
      'content': instance.content,
      'creatTime': instance.creatTime?.toIso8601String(),
      'lastTime': instance.lastTime?.toIso8601String()
    };
