// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vod_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VodModel _$VodModelFromJson(Map<String, dynamic> json) {
  return VodModel(json['vodName'] as String, json['vodContent'] as String)
    ..vodId = json['vodId'] as int
    ..typeId = json['typeId'] as int
    ..vodActor = json['vodActor'] as String
    ..vodDirector = json['vodDirector'] as String
    ..subId = json['subId'] as int
    ..subName = json['subName'] as String
    ..baseDir = json['baseDir'] as String
    ..vodPic = json['vodPic'] as String
    ..vodTv = json['vodTv'] as String
    ..tvSerialNumber = json['tvSerialNumber'] as int
    ..vodSerial = json['vodSerial'] as String
    ..vodPlayUrl = json['vodPlayUrl'] as String
    ..piece = json['piece'] as String
    ..vodCopyright = json['vodCopyright'] as bool
    ..cacheIndex = json['cacheIndex'] as int
    ..status = json['status'] as int
    ..progress = (json['progress'] as num)?.toDouble()
    ..duration = (json['duration'] as num)?.toDouble()
    ..vodHits = json['vodHits'] as int
    ..playlistFileName = json['playlistFileName'] as String
    ..vodTime = json['vodTime'] as int
    ..vodYear = json['vodYear'] as String
    ..sourceModelList = (json['sourceModelList'] as List)
        ?.map((e) =>
            e == null ? null : SourceModel.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..metadataList = (json['metadataList'] as List)
        ?.map((e) => e == null
            ? null
            : MetadataModel.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$VodModelToJson(VodModel instance) => <String, dynamic>{
      'vodId': instance.vodId,
      'typeId': instance.typeId,
      'vodName': instance.vodName,
      'vodActor': instance.vodActor,
      'vodDirector': instance.vodDirector,
      'vodContent': instance.vodContent,
      'subId': instance.subId,
      'subName': instance.subName,
      'baseDir': instance.baseDir,
      'vodPic': instance.vodPic,
      'vodTv': instance.vodTv,
      'tvSerialNumber': instance.tvSerialNumber,
      'vodSerial': instance.vodSerial,
      'vodPlayUrl': instance.vodPlayUrl,
      'piece': instance.piece,
      'vodCopyright': instance.vodCopyright,
      'cacheIndex': instance.cacheIndex,
      'status': instance.status,
      'progress': instance.progress,
      'duration': instance.duration,
      'vodHits': instance.vodHits,
      'playlistFileName': instance.playlistFileName,
      'vodTime': instance.vodTime,
      'vodYear': instance.vodYear,
      'sourceModelList': instance.sourceModelList,
      'metadataList': instance.metadataList
    };
