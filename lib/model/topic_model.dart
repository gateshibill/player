
import 'package:json_annotation/json_annotation.dart';
import 'source_model.dart';
import 'metadata_model.dart';
import '../data/cache_data.dart';
import 'media_model.dart';
part 'topic_model.g.dart';


@JsonSerializable()
class TopicModel extends MediaModel{
  int topicId=0;//是不是可以用clientId
  String topicName="";
  int topicHits=0;
  String topicPic="";
  String topicContent="";
  String playUrl;
  int topicTime;

  //Vod:id,voidId,subvodId,pierceId,from,status(null,downing,watched),outOfDate,date,last;
  TopicModel(this.topicName, this.topicContent);
  String getName(){
    return topicName;
  }
  MediaType getMediaType(){
    return MediaType.Topic;
  }
  List<String>getPics(){
    return topicPic.split(",");
  }
  String getPlayUrl(){
    return playUrl;
  }

  String toString(){
    return
      "vod: ${topicId}| ${topicName}| ${topicHits}| ${topicPic}|${topicContent}";

  }
  factory TopicModel.fromJson(Map<String, dynamic> json) =>
      _$TopicModelFromJson(json);

  Map<String, dynamic> toJson() => _$TopicModelToJson(this);
}

class TopicModelList {
  List<TopicModel> topicModelList;

  TopicModelList({this.topicModelList});

  factory TopicModelList.fromJson(List<dynamic> listJson) {

    List<TopicModel> topicModelList =
    listJson.map((value) => TopicModel.fromJson(value)).toList();

    return TopicModelList(topicModelList: topicModelList);
  }
}