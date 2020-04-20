// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'peer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PeerModel _$PeerModelFromJson(Map<String, dynamic> json) {
  return PeerModel(
      json['id'] as int, json['localIp'] as String, json['udpPort'] as int)
    ..name = json['name'] as String
    ..ip = json['ip'] as String
    ..port = json['port'] as int;
}

Map<String, dynamic> _$PeerModelToJson(PeerModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'localIp': instance.localIp,
      'ip': instance.ip,
      'port': instance.port,
      'udpPort': instance.udpPort
    };
