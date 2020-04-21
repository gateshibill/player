
import 'package:json_annotation/json_annotation.dart';
import 'source_model.dart';
import 'metadata_model.dart';
import '../data/cache_data.dart';
part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  int userId;
  int appId;
  int groupId;
  String userName="";
  DateTime vipExpire;
  String deviceId="";
  String userPwd="";
  String userNickName="";
  String userQq="";
  String userEmail;
  String userPhone;
  bool userStatus;
  String userPortrait;
  String userPortraitThumb;
  String userOpenidQq;
  String userOpenIdWeixin;
  String userQestion;
  String userAnswer;
  int userPoints;
  int userPointsFroze;
  int userRegTime;
  int userRegIp;
  int userLoginTime;
  int userLoginIp;
  int userLastLoginTime;
  int userLastLoginIp;
  int userLoginNum;
  int userExtend;
  String userRandom;
  int userEndTime;
  int userPid;
  int userPid2;
  int userPid3;
  bool isLogin=false;

 // String country="";
 // String language="";

  UserModel();

  String detail(){
    return
      "vod: ${userId}| ${userName}| ${userPhone}| ${userRandom}";
  }
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

class UserModelList {
  List<UserModel> userModelList;

  UserModelList({this.userModelList});

  factory UserModelList.fromJson(List<dynamic> listJson) {

    List<UserModel> userModelList =
    listJson.map((value) => UserModel.fromJson(value)).toList();

    return UserModelList(userModelList: userModelList);
  }
}