import 'package:json_annotation/json_annotation.dart';
import '../config/config.dart';
part 'client_log.g.dart';

@JsonSerializable()
class ClientLog {
  int id;
  int appId = APP_ID; // 应用ID；
  int userId = USER_ID;
  String deviceId = DEVICE_ID;
  String deviceBrand = DEVICE_BRAND;
  String clientIp;
  String version=VERSION;
  String log;
  String level;
 // var createTime=new DateTime.now();

  // peer:id,voidId,subvodId,pierceId,from,status(null,downing,watched),outOfDate,date,last;
  ClientLog(this.log,this.level);

  factory ClientLog.fromJson(Map<String, dynamic> json) =>
      _$ClientLogFromJson(json);

  Map<String, dynamic> toJson() => _$ClientLogToJson(this);
}

class ClientLogList {
  List<ClientLog> clientLoglList;

  ClientLogList({this.clientLoglList});

  factory ClientLogList.fromJson(List<dynamic> listJson) {
    List<ClientLog> clientLoglList =
        listJson.map((value) => ClientLog.fromJson(value)).toList();

    return ClientLogList(clientLoglList: clientLoglList);
  }
}
