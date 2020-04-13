import 'package:json_annotation/json_annotation.dart';
import '../config/config.dart';
part 'source_model.g.dart';

@JsonSerializable()
class SourceModel {
  int id=0;//与asset id保持一致；
  String ip="";
  String localIp="";
  String deviceId=DEVICE_ID;
  String userId="";
  int nodeId;
  String name="";
  int vodId=0;
  String vodName="";
  int subId=0;
  String subName="";
  String piece="";
  var createTime = new DateTime.now();
  var lastTime = new DateTime.now();
  int status=0;
  String md5="";//文件完整性校验码；服务是生成的；

  SourceModel(this.name, this.subName);

  String toString(){
    return "SM: ${vodName}| ${vodId}| ${piece}|$status|$ip|$localIp|$deviceId|$lastTime";
  }

  factory SourceModel.fromJson(Map<String, dynamic> json) =>
      _$SourceModelFromJson(json);

  Map<String, dynamic> toJson() => _$SourceModelToJson(this);
}

class SourceModelList {
  List<SourceModel> sourceModelList;

  SourceModelList({this.sourceModelList});

  factory SourceModelList.fromJson(List<dynamic> listJson) {

    List<SourceModel> sourceModelList =
    listJson.map((value) => SourceModel.fromJson(value)).toList();

    return SourceModelList(sourceModelList: sourceModelList);
  }
} 