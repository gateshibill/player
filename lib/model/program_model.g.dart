// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'program_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProgramModel _$ProgramModelFromJson(Map<String, dynamic> json) {
  return ProgramModel(json['name'] as String, json['content'] as String)
    ..id = json['id'] as int
    ..channelId = json['channelId'] as int
    ..channelName = json['channelName'] as String
    ..type = json['type'] as int
    ..subType = json['subType'] as int
    ..event = json['event'] as String
    ..playUrl = json['playUrl'] as String
    ..reserveUrls = json['reserveUrls'] as String
    ..posterUrl = json['posterUrl'] as String
    ..startTime = json['startTime'] == null
        ? null
        : DateTime.parse(json['startTime'] as String)
    ..endTime = json['endTime'] == null
        ? null
        : DateTime.parse(json['endTime'] as String)
    ..host = json['host'] as String
    ..homeTeam = json['homeTeam'] as String
    ..guestTeam = json['guestTeam'] as String
    ..homeTeamLogoUrl = json['homeTeamLogoUrl'] as String
    ..guestTeamLogoUrl = json['guestTeamLogoUrl'] as String
    ..homeTeamScore = json['homeTeamScore'] as int
    ..guestTeamScore = json['guestTeamScore'] as int
    ..playbackUrl = json['playbackUrl'] as String
    ..betUrl = json['betUrl'] as String
    ..creatTime = json['creatTime'] == null
        ? null
        : DateTime.parse(json['creatTime'] as String)
    ..lastTime = json['lastTime'] == null
        ? null
        : DateTime.parse(json['lastTime'] as String)
    ..reserveUrlList =
        (json['reserveUrlList'] as List)?.map((e) => e as String)?.toList();
}

Map<String, dynamic> _$ProgramModelToJson(ProgramModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'channelId': instance.channelId,
      'channelName': instance.channelName,
      'name': instance.name,
      'type': instance.type,
      'subType': instance.subType,
      'event': instance.event,
      'playUrl': instance.playUrl,
      'reserveUrls': instance.reserveUrls,
      'posterUrl': instance.posterUrl,
      'content': instance.content,
      'startTime': instance.startTime?.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'host': instance.host,
      'homeTeam': instance.homeTeam,
      'guestTeam': instance.guestTeam,
      'homeTeamLogoUrl': instance.homeTeamLogoUrl,
      'guestTeamLogoUrl': instance.guestTeamLogoUrl,
      'homeTeamScore': instance.homeTeamScore,
      'guestTeamScore': instance.guestTeamScore,
      'playbackUrl': instance.playbackUrl,
      'betUrl': instance.betUrl,
      'creatTime': instance.creatTime?.toIso8601String(),
      'lastTime': instance.lastTime?.toIso8601String(),
      'reserveUrlList': instance.reserveUrlList
    };
