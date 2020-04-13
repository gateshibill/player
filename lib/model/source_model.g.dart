// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'source_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SourceModel _$SourceModelFromJson(Map<String, dynamic> json) {
  return SourceModel(json['name'] as String, json['subName'] as String)
    ..id = json['id'] as int
    ..ip = json['ip'] as String
    ..localIp = json['localIp'] as String
    ..deviceId = json['deviceId'] as String
    ..userId = json['userId'] as String
    ..nodeId = json['nodeId'] as int
    ..vodId = json['vodId'] as int
    ..vodName = json['vodName'] as String
    ..subId = json['subId'] as int
    ..piece = json['piece'] as String
    ..createTime = json['createTime'] == null
        ? null
        : DateTime.parse(json['createTime'] as String)
    ..lastTime = json['lastTime'] == null
        ? null
        : DateTime.parse(json['lastTime'] as String)
    ..status = json['status'] as int
    ..md5 = json['md5'] as String;
}

Map<String, dynamic> _$SourceModelToJson(SourceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ip': instance.ip,
      'localIp': instance.localIp,
      'deviceId': instance.deviceId,
      'userId': instance.userId,
      'nodeId': instance.nodeId,
      'name': instance.name,
      'vodId': instance.vodId,
      'vodName': instance.vodName,
      'subId': instance.subId,
      'subName': instance.subName,
      'piece': instance.piece,
      'createTime': instance.createTime?.toIso8601String(),
      'lastTime': instance.lastTime?.toIso8601String(),
      'status': instance.status,
      'md5': instance.md5
    };
