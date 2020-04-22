// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientLog _$ClientLogFromJson(Map<String, dynamic> json) {
  return ClientLog(json['log'] as String, json['level'] as String)
    ..id = json['id'] as int
    ..appId = json['appId'] as int
    ..userId = json['userId'] as int
    ..deviceId = json['deviceId'] as String
    ..deviceBrand = json['deviceBrand'] as String
    ..clientIp = json['clientIp'] as String
    ..version = json['version'] as String;
}

Map<String, dynamic> _$ClientLogToJson(ClientLog instance) => <String, dynamic>{
      'id': instance.id,
      'appId': instance.appId,
      'userId': instance.userId,
      'deviceId': instance.deviceId,
      'deviceBrand': instance.deviceBrand,
      'clientIp': instance.clientIp,
      'version': instance.version,
      'log': instance.log,
      'level': instance.level
    };
