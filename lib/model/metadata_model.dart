import 'package:json_annotation/json_annotation.dart';
import 'source_model.dart';
import '../data/cache_data.dart';
part 'metadata_model.g.dart';

@JsonSerializable()
class MetadataModel {
  int id;//是不是可以用clientId
 // String name;
  int vodId;
  String vodName="";
  int subId;
  String subName;
  String baseDir=BASE_DIR;
  String playUrl="";
  String piece="";
  String fromIp="";
  String fromId="";
  int status=0;
  //double progress;//观看进展
  int downloadTimes=0;//下载失败重试次数
  var time=DateTime.now();
  var lastTime=DateTime.now();
  List<SourceModel> sourceModelList =null;
  int validate=0;//校验文件是否完整；1为不完整，校验不通过；
  String md5;
  int expireIndex=0;

  //metadata:id,voidId,subvodId,pierceId,from,status(null,downing,watched),outOfDate,date,last;
  MetadataModel(this.vodName, this.piece);

  String toString(){
    return
      "vod: ${vodName}| ${vodId}| ${piece}|$status|$fromIp|$time";
  }
  factory MetadataModel.fromJson(Map<String, dynamic> json) =>
      _$MetadataModelFromJson(json);

  Map<String, dynamic> toJson() => _$MetadataModelToJson(this);
}

class MetadataModelList {
  List<MetadataModel> metadataModelList;

  MetadataModelList({this.metadataModelList});

  factory MetadataModelList.fromJson(List<dynamic> listJson) {

    List<MetadataModel> metadataModelList =
    listJson.map((value) => MetadataModel.fromJson(value)).toList();

    return MetadataModelList(metadataModelList: metadataModelList);
  }
}