
import 'package:json_annotation/json_annotation.dart';
import 'source_model.dart';
import 'metadata_model.dart';
import '../data/cache_data.dart';
part 'visit_model.g.dart';


@JsonSerializable()
class VisitModel {
  int userId=0;
  String deviceId;
  int visitIp;
  String publicIp="";
  String loaclIp="";
  String visitLy;
  var createTime=DateTime.now();

  VisitModel(this.userId, this.deviceId,this.loaclIp,this.createTime);

  String toString(){
    return
      "vod: ${userId}| ${deviceId}| ${loaclIp}| ${createTime}";
  }
  factory VisitModel.fromJson(Map<String, dynamic> json) =>
      _$VisitModelFromJson(json);

  Map<String, dynamic> toJson() => _$VisitModelToJson(this);
}

class VisitModelList {
  List<VisitModel> visitModelList;
  VisitModelList({this.visitModelList});
  factory VisitModelList.fromJson(List<dynamic> listJson) {

    List<VisitModel> visitModelList =
    listJson.map((value) => VisitModel.fromJson(value)).toList();

    return VisitModelList(visitModelList: visitModelList);
  }
}