// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) {
  return MessageModel(
      json['event'] as String,
      json['requstId'] as int,
      json['content'] as String,
      json['fromPeer'] == null
          ? null
          : PeerModel.fromJson(json['fromPeer'] as Map<String, dynamic>),
      json['destPeer'] == null
          ? null
          : PeerModel.fromJson(json['destPeer'] as Map<String, dynamic>));
}

Map<String, dynamic> _$MessageModelToJson(MessageModel instance) =>
    <String, dynamic>{
      'requstId': instance.requstId,
      'event': instance.event,
      'content': instance.content,
      'fromPeer': instance.fromPeer,
      'destPeer': instance.destPeer
    };
