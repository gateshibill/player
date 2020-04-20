import 'package:json_annotation/json_annotation.dart';
import 'package:player/data/cache_data.dart';
import '../config/config.dart';
part 'peer_action.g.dart';

@JsonSerializable()
class PeerAction {
  int id;
  int appId = APP_ID; // 应用ID；
  int userId = me.userId;
  String deviceId = DEVICE_ID;
  String deviceBrand = DEVICE_BRAND;
  String clientIp;
  int pnodeId;
  String fromIp;
  String vodName;
  String piece;
  String log;
  String stage;
  int size;
  String protocol;
  var createTime;
  var endTime;

  // peer:id,voidId,subvodId,pierceId,from,status(null,downing,watched),outOfDate,date,last;
  PeerAction(this.pnodeId,this.log,this.stage,this.protocol);

  String toString() {
    return "vod: ${userId}|  ${deviceId}|$clientIp|$pnodeId|$fromIp|$vodName|$piece";
  }

  factory PeerAction.fromJson(Map<String, dynamic> json) =>
      _$PeerActionFromJson(json);

  Map<String, dynamic> toJson() => _$PeerActionToJson(this);
}

class PeerActionList {
  List<PeerAction> peerModelList;

  PeerActionList({this.peerModelList});

  factory PeerActionList.fromJson(List<dynamic> listJson) {
    List<PeerAction> peerModelList =
        listJson.map((value) => PeerAction.fromJson(value)).toList();

    return PeerActionList(peerModelList: peerModelList);
  }
}
