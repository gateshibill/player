import 'package:json_annotation/json_annotation.dart';
import 'source_model.dart';
import 'metadata_model.dart';
import '../data/cache_data.dart';
import 'media_model.dart';

part 'channel_model.g.dart';

@JsonSerializable()
class ChannelModel extends MediaModel {
  int id = 0; //是不是可以用clientId
  String name = "";
  String playUrl = "";
  String reserveUrls = "";
  String posterUrl = "";
  String desc = "";
  int type;
  String country = "";
  String language = "";
  var creatTime = DateTime.now();
  var lastTime = DateTime.now();
  String tvid;
  String parts;
  String serverUrl;

  List<String> reserveUrlList = new List();

  ChannelModel(this.name, this.desc);

  String getName() {
    return name;
  }

  MediaType getMediaType() {
    return MediaType.Channel;
  }

  List<String> getPics() {
    List<String> list = new List<String>();
    list.add(posterUrl);
    return list;
  }

  String getPlayUrl(){
    return playUrl;
  }

  String toString() {
    return "vod: ${id}| ${name}| ${playUrl}| ${posterUrl}|${reserveUrls}";
  }

  factory ChannelModel.fromJson(Map<String, dynamic> json) =>
      _$ChannelModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChannelModelToJson(this);
}

class ChannelModelList {
  List<ChannelModel> channelModelList;

  ChannelModelList({this.channelModelList});

  factory ChannelModelList.fromJson(List<dynamic> listJson) {
    List<ChannelModel> channelModelList =
        listJson.map((value) => ChannelModel.fromJson(value)).toList();

    return ChannelModelList(channelModelList: channelModelList);
  }
}
