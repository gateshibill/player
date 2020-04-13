import 'package:json_annotation/json_annotation.dart';

part 'picture_model.g.dart';

@JsonSerializable()
class PictureModel {
  int id = 0; //是不是可以用clientId
  String name = "";
  int type;
  String url;
  String thumbs;
  int rank;
  String content;
  DateTime createTime;

  PictureModel(this.id, this.name, this.url);

  factory PictureModel.fromJson(Map<String, dynamic> json) =>
      _$PictureModelFromJson(json);

  Map<String, dynamic> toJson() => _$PictureModelToJson(this);
}

class PictureModelList {
  List<PictureModel> pictureModelList;

  PictureModelList({this.pictureModelList});

  factory PictureModelList.fromJson(List<dynamic> listJson) {
    List<PictureModel> pictureModelList =
        listJson.map((value) => PictureModel.fromJson(value)).toList();

    return PictureModelList(pictureModelList: pictureModelList);
  }
}
