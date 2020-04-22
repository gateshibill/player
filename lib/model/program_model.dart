
import 'package:json_annotation/json_annotation.dart';
import 'source_model.dart';
import 'metadata_model.dart';
import '../data/cache_data.dart';
part 'program_model.g.dart';


@JsonSerializable()
class ProgramModel {
  int id=0;//
  int channelId;
  String channelName;
  String name="";
  int type;
  int subType;
  String event="";
  String playUrl="";
  String reserveUrls="";
  String posterUrl="";
  String content="";
  DateTime  startTime=DateTime.now();
  DateTime  endTime=DateTime.now();
  String host="";
  String homeTeam="";
  String guestTeam="";
  String homeTeamLogoUrl="";
  String guestTeamLogoUrl="";
  int homeTeamScore;
  int guestTeamScore;
  String playbackUrl="";
  String betUrl="";
  var creatTime=DateTime.now();
  var lastTime=DateTime.now();
  List<String> reserveUrlList =new List();

  ProgramModel(this.name, this.content);

  String detail(){
    return
      "program: ${channelId}| ${name}| ${playUrl}| ${posterUrl}";
  }
  factory ProgramModel.fromJson(Map<String, dynamic> json) =>
      _$ProgramModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProgramModelToJson(this);
}

class ProgramModelList {
  List<ProgramModel> programModelList;

  ProgramModelList({this.programModelList});

  factory ProgramModelList.fromJson(List<dynamic> listJson) {

    List<ProgramModel> programModelList =
    listJson.map((value) => ProgramModel.fromJson(value)).toList();

    return ProgramModelList(programModelList: programModelList);
  }
}