// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'peer_action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PeerAction _$PeerActionFromJson(Map<String, dynamic> json) {
  return PeerAction(json['pnodeId'] as int, json['log'] as String,
      json['stage'] as String, json['protocol'] as String)
    ..id = json['id'] as int
    ..appId = json['appId'] as int
    ..userId = json['userId'] as int
    ..deviceId = json['deviceId'] as String
    ..deviceBrand = json['deviceBrand'] as String
    ..clientIp = json['clientIp'] as String
    ..fromIp = json['fromIp'] as String
    ..vodName = json['vodName'] as String
    ..piece = json['piece'] as String
    ..size = json['size'] as int
    ..createTime = json['createTime']
    ..endTime = json['endTime'];
}

Map<String, dynamic> _$PeerActionToJson(PeerAction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'appId': instance.appId,
      'userId': instance.userId,
      'deviceId': instance.deviceId,
      'deviceBrand': instance.deviceBrand,
      'clientIp': instance.clientIp,
      'pnodeId': instance.pnodeId,
      'fromIp': instance.fromIp,
      'vodName': instance.vodName,
      'piece': instance.piece,
      'log': instance.log,
      'stage': instance.stage,
      'size': instance.size,
      'protocol': instance.protocol,
      'createTime': instance.createTime,
      'endTime': instance.endTime
    };
