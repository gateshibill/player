// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientAction _$ClientActionFromJson(Map<String, dynamic> json) {
  return ClientAction(
      json['pageId'] as int,
      json['pageName'] as String,
      json['columnId'] as int,
      json['columnName'] as String,
      json['objectId'] as int,
      json['objectName'] as String,
      json['actionId'] as int,
      json['actionName'] as String)
    ..id = json['id'] as int
    ..appId = json['appId'] as int
    ..deviceId = json['deviceId'] as String
    ..deviceBrand = json['deviceBrand'] as String
    ..userId = json['userId'] as int
    ..version = json['version'] as String
    ..fromId = json['fromId'] as int
    ..fromWay = json['fromWay'] as int
    ..subActionId = json['subActionId'] as int
    ..subActionName = json['subActionName'] as String
    ..superId = json['superId'] as int;
}

Map<String, dynamic> _$ClientActionToJson(ClientAction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'appId': instance.appId,
      'deviceId': instance.deviceId,
      'deviceBrand': instance.deviceBrand,
      'userId': instance.userId,
      'version': instance.version,
      'fromId': instance.fromId,
      'fromWay': instance.fromWay,
      'pageId': instance.pageId,
      'pageName': instance.pageName,
      'columnId': instance.columnId,
      'columnName': instance.columnName,
      'objectId': instance.objectId,
      'objectName': instance.objectName,
      'actionId': instance.actionId,
      'actionName': instance.actionName,
      'subActionId': instance.subActionId,
      'subActionName': instance.subActionName,
      'superId': instance.superId
    };
