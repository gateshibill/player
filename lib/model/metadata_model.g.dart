// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metadata_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MetadataModel _$MetadataModelFromJson(Map<String, dynamic> json) {
  return MetadataModel(json['vodName'] as String, json['piece'] as String)
    ..id = json['id'] as int
    ..vodId = json['vodId'] as int
    ..subId = json['subId'] as int
    ..subName = json['subName'] as String
    ..baseDir = json['baseDir'] as String
    ..playUrl = json['playUrl'] as String
    ..fromIp = json['fromIp'] as String
    ..fromId = json['fromId'] as String
    ..status = json['status'] as int
    ..downloadTimes = json['downloadTimes'] as int
    ..time =
        json['time'] == null ? null : DateTime.parse(json['time'] as String)
    ..lastTime = json['lastTime'] == null
        ? null
        : DateTime.parse(json['lastTime'] as String)
    ..sourceModelList = (json['sourceModelList'] as List)
        ?.map((e) =>
            e == null ? null : SourceModel.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..validate = json['validate'] as int
    ..md5 = json['md5'] as String
    ..expireIndex = json['expireIndex'] as int;
}

Map<String, dynamic> _$MetadataModelToJson(MetadataModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vodId': instance.vodId,
      'vodName': instance.vodName,
      'subId': instance.subId,
      'subName': instance.subName,
      'baseDir': instance.baseDir,
      'playUrl': instance.playUrl,
      'piece': instance.piece,
      'fromIp': instance.fromIp,
      'fromId': instance.fromId,
      'status': instance.status,
      'downloadTimes': instance.downloadTimes,
      'time': instance.time?.toIso8601String(),
      'lastTime': instance.lastTime?.toIso8601String(),
      'sourceModelList': instance.sourceModelList,
      'validate': instance.validate,
      'md5': instance.md5,
      'expireIndex': instance.expireIndex
    };
