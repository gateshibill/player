import 'package:json_annotation/json_annotation.dart';
import 'package:player/data/cache_data.dart';
import '../config/config.dart';
part 'client_action.g.dart';



@JsonSerializable()
class ClientAction {
   int id;
   int appId=APP_ID;// 应用ID；
   String deviceId=DEVICE_ID;
   String deviceBrand=DEVICE_BRAND;
   int userId=me?.userId;
   String version=VERSION;
   int fromId;// 这里记录，用户是自己进来点击的，还是通过分享进来的，这里可以分享客户的主动性
   int fromWay=1;//渠道
   int pageId;//tab:1-5,home:1,event:2,program:3,channel:4,my:5,column.
   String pageName;
   int columnId;
   String columnName;
   int objectId;
   String objectName;
   int actionId;//1.访问浏览；2.点击;3.下拉；4.上拉；5.点赞；6.评价；7.阅读；8.播放；
   String actionName;
   int subActionId;
   String subActionName;
   int superId;
  // DateTime createTime=new DateTime.now();


  //client:id,voidId,subvodId,pierceId,from,status(null,downing,watched),outOfDate,date,last;
  ClientAction(this.pageId, this.pageName,this.columnId,this.columnName,this.objectId,this.objectName,this.actionId,this.actionName);
  String toString(){
    return
      "vod: ${userId}|  ${pageName}|$columnName|$columnName|$objectName|$actionName|$subActionName";
  }
  factory ClientAction.fromJson(Map<String, dynamic> json) =>
      _$ClientActionFromJson(json);

  Map<String, dynamic> toJson() => _$ClientActionToJson(this);
}

class ClientActionList {
  List<ClientAction> clientModelList;

  ClientActionList({this.clientModelList});

  factory ClientActionList.fromJson(List<dynamic> listJson) {

    List<ClientAction> clientModelList =
    listJson.map((value) => ClientAction.fromJson(value)).toList();

    return ClientActionList(clientModelList: clientModelList);
  }
}