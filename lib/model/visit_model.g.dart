// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VisitModel _$VisitModelFromJson(Map<String, dynamic> json) {
  return VisitModel(
      json['userId'] as int,
      json['deviceId'] as String,
      json['loaclIp'] as String,
      json['createTime'] == null
          ? null
          : DateTime.parse(json['createTime'] as String))
    ..visitIp = json['visitIp'] as int
    ..publicIp = json['publicIp'] as String
    ..visitLy = json['visitLy'] as String;
}

Map<String, dynamic> _$VisitModelToJson(VisitModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'deviceId': instance.deviceId,
      'visitIp': instance.visitIp,
      'publicIp': instance.publicIp,
      'loaclIp': instance.loaclIp,
      'visitLy': instance.visitLy,
      'createTime': instance.createTime?.toIso8601String()
    };
