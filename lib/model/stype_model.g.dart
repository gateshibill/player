// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stype_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StypeModel _$StypeModelFromJson(Map<String, dynamic> json) {
  return StypeModel()
    ..id = json['id'] as int
    ..appId = json['appId'] as int
    ..name = json['name'] as String
    ..type = json['type'] as int
    ..eng = json['eng'] as String
    ..rank = json['rank'] as int
    ..status = json['status'] as int
    ..url = json['url'] as String
    ..category = json['category'] as String
    ..num = json['num'] as int
    ..creatTime = json['creatTime'] == null
        ? null
        : DateTime.parse(json['creatTime'] as String);
}

Map<String, dynamic> _$StypeModelToJson(StypeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'appId': instance.appId,
      'name': instance.name,
      'type': instance.type,
      'eng': instance.eng,
      'rank': instance.rank,
      'status': instance.status,
      'url': instance.url,
      'category': instance.category,
      'num': instance.num,
      'creatTime': instance.creatTime?.toIso8601String()
    };
