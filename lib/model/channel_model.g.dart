// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelModel _$ChannelModelFromJson(Map<String, dynamic> json) {
  return ChannelModel(json['name'] as String, json['desc'] as String)
    ..id = json['id'] as int
    ..playUrl = json['playUrl'] as String
    ..reserveUrls = json['reserveUrls'] as String
    ..posterUrl = json['posterUrl'] as String
    ..type = json['type'] as int
    ..country = json['country'] as String
    ..language = json['language'] as String
    ..creatTime = json['creatTime'] == null
        ? null
        : DateTime.parse(json['creatTime'] as String)
    ..lastTime = json['lastTime'] == null
        ? null
        : DateTime.parse(json['lastTime'] as String)
    ..tvid = json['tvid'] as String
    ..parts = json['parts'] as String
    ..serverUrl = json['serverUrl'] as String
    ..reserveUrlList =
        (json['reserveUrlList'] as List)?.map((e) => e as String)?.toList();
}

Map<String, dynamic> _$ChannelModelToJson(ChannelModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'playUrl': instance.playUrl,
      'reserveUrls': instance.reserveUrls,
      'posterUrl': instance.posterUrl,
      'desc': instance.desc,
      'type': instance.type,
      'country': instance.country,
      'language': instance.language,
      'creatTime': instance.creatTime?.toIso8601String(),
      'lastTime': instance.lastTime?.toIso8601String(),
      'tvid': instance.tvid,
      'parts': instance.parts,
      'serverUrl': instance.serverUrl,
      'reserveUrlList': instance.reserveUrlList
    };
