import 'package:json_annotation/json_annotation.dart';
import 'source_model.dart';
import 'metadata_model.dart';
import '../data/cache_data.dart';
import 'media_model.dart';

part 'vod_model.g.dart';

@JsonSerializable()
class VodModel extends MediaModel {
  int vodId = 0; //是不是可以用clientId
  int typeId = 0;
  String vodName = "";
  String vodActor = "汤姆克鲁斯";
  String vodDirector = "李安";
  String vodContent;
  int subId = 0;
  String subName = "";
  String baseDir = BASE_DIR;
  String vodPic = "";

  //String desc = "";
  String vodPlayUrl = "";
  String piece = "";
  bool vodCopyright = false;
  int cacheIndex = 0; //缓存进展
  int status = 0; //0未下载，1下载中，2已下载，3正在看，4已看完，
  double progress = 0; //观看进展
  double duration = 0;
  int vodHits = 0; //点击次数
  String playlistFileName = "playlist.m3u8";
  int vodTime; //= DateTime.now();
  String vodYear;

  //DateTime lastTime = DateTime.now();
  List<SourceModel> sourceModelList = new List();
  List<MetadataModel> metadataList = new List();

  //Vod:id,voidId,subvodId,pierceId,from,status(null,downing,watched),outOfDate,date,last;
  VodModel(this.vodName, this.vodContent);

  String getName() {
    return vodName;
  }

  MediaType getMediaType() {
    return MediaType.Video;
  }

  List<String> getPics() {
    List<String> list = new List<String>();
    list.add(vodPic);
    return list;
  }

  String getPlayUrl() {
    return vodPlayUrl;
  }

  String detail() {
    return "vod: ${vodId}| ${vodName}| ${vodPlayUrl}| ${vodPic}|$vodCopyright|$progress|$duration|$vodTime";
  }

  factory VodModel.fromJson(Map<String, dynamic> json) =>
      _$VodModelFromJson(json);

  Map<String, dynamic> toJson() => _$VodModelToJson(this);
}

class VodModelList {
  List<VodModel> vodModelList;

  VodModelList({this.vodModelList});

  factory VodModelList.fromJson(List<dynamic> listJson) {
    List<VodModel> vodModelList =
        listJson.map((value) => VodModel.fromJson(value)).toList();

    return VodModelList(vodModelList: vodModelList);
  }
}
