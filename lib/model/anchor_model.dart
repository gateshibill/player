import 'package:json_annotation/json_annotation.dart';
import 'source_model.dart';
import 'metadata_model.dart';
import '../data/cache_data.dart';

part 'anchor_model.g.dart';

@JsonSerializable()
class AnchorModel {
  int id = 0; //
  int appId;
  String name = "";
  int age;
  int gender;
  int rank;
  int type;
  int subType;
  String playUrl = "";
  String posterUrl = "";
  int online;
  String content = "";

  var creatTime = DateTime.now();
  var lastTime = DateTime.now();

  AnchorModel();

  String toString() {
    return "anchor: ${id}| ${name}| ${playUrl}| ${posterUrl}";
  }

  factory AnchorModel.fromJson(Map<String, dynamic> json) =>
      _$AnchorModelFromJson(json);

  Map<String, dynamic> toJson() => _$AnchorModelToJson(this);
}

class AnchorModelList {
  List<AnchorModel> anchorModelList;

  AnchorModelList({this.anchorModelList});

  factory AnchorModelList.fromJson(List<dynamic> listJson) {
    List<AnchorModel> anchorModelList =
        listJson.map((value) => AnchorModel.fromJson(value)).toList();

    return AnchorModelList(anchorModelList: anchorModelList);
  }
}
