// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'picture_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PictureModel _$PictureModelFromJson(Map<String, dynamic> json) {
  return PictureModel(
      json['id'] as int, json['name'] as String, json['url'] as String)
    ..type = json['type'] as int
    ..thumbs = json['thumbs'] as String
    ..rank = json['rank'] as int
    ..content = json['content'] as String
    ..createTime = json['createTime'] == null
        ? null
        : DateTime.parse(json['createTime'] as String);
}

Map<String, dynamic> _$PictureModelToJson(PictureModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'url': instance.url,
      'thumbs': instance.thumbs,
      'rank': instance.rank,
      'content': instance.content,
      'createTime': instance.createTime?.toIso8601String()
    };
