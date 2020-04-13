import 'package:json_annotation/json_annotation.dart';
import 'source_model.dart';
import 'metadata_model.dart';
import '../data/cache_data.dart';

part 'stype_model.g.dart';

@JsonSerializable()
class StypeModel {
  int id = 0; //
  int appId;
  String name = "";
  int type;
  String eng;
  int rank;
  int status;
  String url = "";
  String category = "";
  int num;
  var creatTime = DateTime.now();

  StypeModel();

  String toString() {
    return "vod: ${id}| ${name}| ${url}| ${num}";
  }

  factory StypeModel.fromJson(Map<String, dynamic> json) =>
      _$StypeModelFromJson(json);

  Map<String, dynamic> toJson() => _$StypeModelToJson(this);
}

class StypeModelList {
  List<StypeModel> stypeModelList;

  StypeModelList({this.stypeModelList});

  factory StypeModelList.fromJson(List<dynamic> listJson) {
    List<StypeModel> stypeModelList =
        listJson.map((value) => StypeModel.fromJson(value)).toList();

    return StypeModelList(stypeModelList: stypeModelList);
  }
}
