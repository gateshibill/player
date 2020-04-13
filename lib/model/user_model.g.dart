// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return UserModel()
    ..userId = json['userId'] as int
    ..appId = json['appId'] as int
    ..groupId = json['groupId'] as int
    ..userName = json['userName'] as String
    ..userPwd = json['userPwd'] as String
    ..userNickName = json['userNickName'] as String
    ..userQq = json['userQq'] as String
    ..userEmail = json['userEmail'] as String
    ..userPhone = json['userPhone'] as String
    ..userStatus = json['userStatus'] as bool
    ..userPortrait = json['userPortrait'] as String
    ..userPortraitThumb = json['userPortraitThumb'] as String
    ..userOpenidQq = json['userOpenidQq'] as String
    ..userOpenIdWeixin = json['userOpenIdWeixin'] as String
    ..userQestion = json['userQestion'] as String
    ..userAnswer = json['userAnswer'] as String
    ..userPoints = json['userPoints'] as int
    ..userPointsFroze = json['userPointsFroze'] as int
    ..userRegTime = json['userRegTime'] as int
    ..userRegIp = json['userRegIp'] as int
    ..userLoginTime = json['userLoginTime'] as int
    ..userLoginIp = json['userLoginIp'] as int
    ..userLastLoginTime = json['userLastLoginTime'] as int
    ..userLastLoginIp = json['userLastLoginIp'] as int
    ..userLoginNum = json['userLoginNum'] as int
    ..userExtend = json['userExtend'] as int
    ..userRandom = json['userRandom'] as String
    ..userEndTime = json['userEndTime'] as int
    ..userPid = json['userPid'] as int
    ..userPid2 = json['userPid2'] as int
    ..userPid3 = json['userPid3'] as int;
}

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'userId': instance.userId,
      'appId': instance.appId,
      'groupId': instance.groupId,
      'userName': instance.userName,
      'userPwd': instance.userPwd,
      'userNickName': instance.userNickName,
      'userQq': instance.userQq,
      'userEmail': instance.userEmail,
      'userPhone': instance.userPhone,
      'userStatus': instance.userStatus,
      'userPortrait': instance.userPortrait,
      'userPortraitThumb': instance.userPortraitThumb,
      'userOpenidQq': instance.userOpenidQq,
      'userOpenIdWeixin': instance.userOpenIdWeixin,
      'userQestion': instance.userQestion,
      'userAnswer': instance.userAnswer,
      'userPoints': instance.userPoints,
      'userPointsFroze': instance.userPointsFroze,
      'userRegTime': instance.userRegTime,
      'userRegIp': instance.userRegIp,
      'userLoginTime': instance.userLoginTime,
      'userLoginIp': instance.userLoginIp,
      'userLastLoginTime': instance.userLastLoginTime,
      'userLastLoginIp': instance.userLastLoginIp,
      'userLoginNum': instance.userLoginNum,
      'userExtend': instance.userExtend,
      'userRandom': instance.userRandom,
      'userEndTime': instance.userEndTime,
      'userPid': instance.userPid,
      'userPid2': instance.userPid2,
      'userPid3': instance.userPid3
    };
